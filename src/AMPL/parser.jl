import DataFrames
import OrderedCollections
import JuMP

function _concrete_eltype(container)
    if any(Base.Fix2(isa, AbstractString), container)
        return String
    end
    return mapreduce(typeof, promote_type, container, init = Int)
end

function _convert_to_concrete_eltype(container::Vector)
    T = _concrete_eltype(container)
    return convert(Vector{T}, container)
end

function _any_parse(s::AbstractString; allow_dot::Bool = false)
    s = strip(s)
    if allow_dot && s == "."
        return missing
    end
    val = tryparse(Int, s)
    if !isnothing(val)
        return val
    end
    val = tryparse(Float64, s)
    if !isnothing(val)
        return val
    end
    return s
end

"""
    read_dat(filename::String, model::Union{JuMPConverter.Model,Nothing} = nothing) -> Dict{String, Any}

Read an AMPL .dat file and return a dictionary mapping parameter names to their values.

# Arguments
- `filename::String`: Path to the AMPL .dat file
- `model`: used to determine parameter dimensionality

# Returns
- `Dict{String, Any}`: Dictionary where keys are parameter names and values are:
  - Scalars: Numbers (Int or Float64)
  - 1D arrays: Vectors
  - 2D+ arrays: Multi-dimensional arrays (as nested vectors or arrays)
  - Sets: Vectors

# Example
```julia
data = read_ampl_dat("model.dat")
S = data["S"]  # Scalar
rho = data["rho"]  # Vector
E = data["E"]  # 3D array
```
"""
function read_dat(
    filename::String,
    model::Union{JuMPConverter.Model,Nothing} = nothing,
)
    s = read(filename, String)
    return parse_dat(s, model)
end

function _range(bounds::NTuple{2,Int})
    if bounds[1] == 1
        return Base.OneTo(bounds[2])
    else
        return bounds[1]:bounds[2]
    end
end

function _axes(indices::Vector{NTuple{N,Int}}) where {N}
    return ntuple(Val(N)) do i
        return _range(extrema(Base.Fix2(getindex, i), indices))
    end
end

_axes(i::Vector{String}) = (i,)

function _container(vals::Array{Float64}, ::NTuple{N,Base.OneTo{Int}}) where {N}
    return vals
end

function _container(vals::Array{Float64}, ax)
    return JuMP.Containers.DenseAxisArray(vals, ax...)
end

function df_to_container!(data::Dict{String,Any}, df::DataFrames.DataFrame)
    df = sort(df, :index, by = reverse)
    ax = _axes(df.index)
    for col in DataFrames.names(df)
        col == "index" && continue
        vals = df[!, col]
        sz = length.(ax)
        container = if df.index isa Vector{String}
            if any(ismissing, vals)
                dict = OrderedCollections.OrderedDict{Tuple{String},Float64}()
                for i in axes(df, 1)
                    !ismissing(vals[i]) &&
                        (dict[(df.index[i],)] = Float64(vals[i]))
                end
                JuMP.Containers.SparseAxisArray(dict)
            else
                JuMP.Containers.DenseAxisArray(
                    convert(Vector{Float64}, vals),
                    ax...,
                )
            end
        elseif length(vals) < prod(sz) || any(ismissing, vals)
            dict = OrderedCollections.OrderedDict{NTuple{length(ax),Int},Float64}()
            for i in axes(df, 1)
                if !ismissing(vals[i])
                    dict[df.index[i]] = vals[i]
                end
            end
            JuMP.Containers.SparseAxisArray(dict)
        else
            vals = convert(Vector{Float64}, vals)
            _container(reshape(vals, sz), ax)
        end
        data[col] = container
    end
    return
end

"""
    _param_ndims(model::JuMPConverter.Model, name::String)

Return the number of indexing dimensions for a parameter, or `nothing`
if the parameter is not declared in the model.
"""
function _param_ndims(model::JuMPConverter.Model, name::String)
    if !haskey(model.parameters, name)
        return nothing
    end
    p = model.parameters[name]
    if isnothing(p.axes)
        return 0
    end
    return length(p.axes.axes)
end

"""
    _read_dat_value!(lex::Lexer)

Read a single numeric value or missing (dot) from the token stream.
"""
function _read_dat_value!(lex::Lexer)
    t = peek(lex)
    if t.kind == TOKEN_DOT
        read_token!(lex)
        return missing
    elseif t.kind == TOKEN_MINUS
        read_token!(lex)
        t2 = expect!(lex, TOKEN_NUMBER)
        return _any_parse("-" * t2.value)
    elseif t.kind == TOKEN_NUMBER
        read_token!(lex)
        return _any_parse(t.value)
    elseif t.kind == TOKEN_IDENTIFIER
        read_token!(lex)
        return t.value
    else
        error("Expected value but got $(t.kind) '$(t.value)'")
    end
end

"""
    _dat_parse_set!(lex::Lexer, data::Dict{String,Any})

Parse: `set NAME := val1 val2 ... ;`
"""
function _dat_parse_set!(lex::Lexer, data::Dict{String,Any})
    name = expect!(lex, TOKEN_IDENTIFIER).value
    expect!(lex, TOKEN_ASSIGN)
    values = Any[]
    while peek(lex).kind != TOKEN_SEMICOLON && peek(lex).kind != TOKEN_EOF
        t = peek(lex)
        if t.kind == TOKEN_COMMA
            read_token!(lex)
            continue
        elseif t.kind == TOKEN_LPAREN
            read_token!(lex)
            inner =
                read_balanced!(lex, TOKEN_LPAREN, TOKEN_RPAREN; compact = true)
            push!(values, "(" * inner * ")")
        else
            push!(values, _read_dat_value!(lex))
        end
    end
    parsed = _convert_to_concrete_eltype(values)
    data[name] = parsed
    return
end

"""
    _dat_parse_param!(lex, data, model)

Parse a `param` data command using the tokenizer.
"""
function _dat_parse_param!(
    lex::Lexer,
    data::Dict{String,Any},
    model::Union{Nothing,JuMPConverter.Model},
)
    t = peek(lex)
    # Multi-column: `param : col1 col2 := ...`
    if t.kind == TOKEN_COLON
        read_token!(lex)
        return _dat_parse_multi_column!(lex, data, model, nothing)
    end
    if t.kind != TOKEN_IDENTIFIER
        error("Expected parameter name but got $(t.kind) '$(t.value)'")
    end
    name = t.value
    read_token!(lex)
    t = peek(lex)
    if t.kind == TOKEN_LBRACKET
        # Slice: `param E [*,*,1]: ...`
        return _dat_parse_slice!(lex, data, name)
    elseif t.kind == TOKEN_COLON
        read_token!(lex)
        # Named table: `param name: col1 col2 := ...`
        return _dat_parse_multi_column!(lex, data, model, name)
    elseif t.kind == TOKEN_ASSIGN
        read_token!(lex)
        return _dat_parse_param_values!(lex, data, model, name)
    elseif t.kind == TOKEN_IDENTIFIER && t.value == "default"
        read_token!(lex)
        _read_dat_value!(lex)  # skip default value
        if peek(lex).kind == TOKEN_ASSIGN
            read_token!(lex)
            return _dat_parse_param_values!(lex, data, model, name)
        end
    end
    # Skip until semicolon
    while peek(lex).kind != TOKEN_SEMICOLON && peek(lex).kind != TOKEN_EOF
        read_token!(lex)
    end
    return
end

"""
Parse values after `param name :=` using model info for dimensionality.
"""
function _dat_parse_param_values!(
    lex::Lexer,
    data::Dict{String,Any},
    model::Union{Nothing,JuMPConverter.Model},
    name::String,
)
    # Handle set literal: let SS := {18, 20, 22, ...};
    if peek(lex).kind == TOKEN_LBRACE
        read_token!(lex)  # consume {
        values = Any[]
        while peek(lex).kind != TOKEN_RBRACE && peek(lex).kind != TOKEN_EOF
            t = peek(lex)
            if t.kind == TOKEN_COMMA
                read_token!(lex)
                continue
            end
            push!(values, _read_dat_value!(lex))
        end
        if peek(lex).kind == TOKEN_RBRACE
            read_token!(lex)  # consume }
        end
        data[name] = _convert_to_concrete_eltype(values)
        return
    end
    ndims = isnothing(model) ? nothing : _param_ndims(model, name)
    values = Any[]
    while peek(lex).kind != TOKEN_SEMICOLON && peek(lex).kind != TOKEN_EOF
        t = peek(lex)
        if t.kind == TOKEN_COMMA
            read_token!(lex)
            continue
        end
        push!(values, _read_dat_value!(lex))
    end
    if isempty(values)
        return
    end
    if length(values) == 1
        data[name] = values[1]
        return
    end
    if ndims == 0
        data[name] = values[1]
    elseif ndims == 1 ||
           (isnothing(ndims) && length(values) >= 2 && iseven(length(values)))
        arr = Dict{Int,Any}()
        for i in 1:2:length(values)
            idx = values[i] isa Int ? values[i] : parse(Int, string(values[i]))
            arr[idx] = values[i+1]
        end
        max_idx = maximum(keys(arr))
        result = Vector{Float64}(undef, max_idx)
        fill!(result, NaN)
        for (idx, val) in arr
            result[idx] = Float64(val)
        end
        data[name] = result
    else
        data[name] = length(values) == 1 ? values[1] : values
    end
    return
end

"""
Parse multi-column table: `: col1 col2 := idx v1 v2 ...`
Handles multiple column sections (`: c1 c2 := data : c3 c4 := data`).
"""
function _dat_parse_multi_column!(
    lex::Lexer,
    data::Dict{String,Any},
    model::Union{Nothing,JuMPConverter.Model},
    prefix_name::Union{Nothing,String},
)
    # Collect sections as (col_names, flat_values) pairs
    sections = Tuple{Vector{String},Vector{Any}}[]

    while true
        # Read column names for this section until :=
        section_cols = String[]
        while peek(lex).kind != TOKEN_ASSIGN &&
                  peek(lex).kind != TOKEN_SEMICOLON &&
                  peek(lex).kind != TOKEN_EOF
            t = read_token!(lex)
            if t.kind == TOKEN_IDENTIFIER || t.kind == TOKEN_NUMBER
                push!(section_cols, t.value)
            end
        end
        peek(lex).kind != TOKEN_ASSIGN && break
        read_token!(lex)  # consume :=
        isempty(section_cols) && continue

        # Collect flat values for this section until : or ;
        section_vals = Any[]
        while peek(lex).kind != TOKEN_SEMICOLON && peek(lex).kind != TOKEN_EOF
            t = peek(lex)
            if t.kind == TOKEN_COLON
                read_token!(lex)  # consume : → next section
                break
            elseif t.kind == TOKEN_COMMA
                read_token!(lex)
                continue
            end
            push!(section_vals, _read_dat_value!(lex))
        end
        push!(sections, (section_cols, section_vals))
        peek(lex).kind == TOKEN_SEMICOLON && break
    end

    isempty(sections) && return

    # Collect all column names in order
    all_col_names = String[]
    for (cols, _) in sections
        for col in cols
            col ∉ all_col_names && push!(all_col_names, col)
        end
    end

    # Determine num_indices (row index dimensions)
    num_indices =
        _determine_num_indices(model, prefix_name, all_col_names, sections)

    # Parse rows from each section
    # Key type: NTuple{num_indices,Int} or String
    # Determine if all row indices are ints by scanning first section
    first_cols, first_vals = sections[1]
    row_size_1 = num_indices + length(first_cols)
    all_ints =
        row_size_1 <= length(first_vals) &&
        all(j -> first_vals[j] isa Int, 1:num_indices)

    row_dict =
        OrderedCollections.OrderedDict{Any,Dict{String,Union{Float64,Missing}}}()

    for (section_cols, section_vals) in sections
        row_size = num_indices + length(section_cols)
        i = 1
        while i + row_size - 1 <= length(section_vals)
            idx = if all_ints
                ntuple(j -> section_vals[i+j-1]::Int, num_indices)
            else
                string(section_vals[i])
            end
            if !haskey(row_dict, idx)
                row_dict[idx] = Dict{String,Union{Float64,Missing}}()
            end
            for (j, col) in enumerate(section_cols)
                v = section_vals[i+num_indices+j-1]
                row_dict[idx][col] = v isa Missing ? missing : Float64(v)
            end
            i += row_size
        end
    end

    isempty(row_dict) && return

    IndexType = all_ints ? NTuple{num_indices,Int} : String
    cols = Any["index"=>IndexType[]]
    for col in all_col_names
        push!(cols, col => Union{Float64,Missing}[])
    end
    df = DataFrames.DataFrame(cols)

    for (idx, col_vals) in row_dict
        row = Any[idx]
        for col in all_col_names
            push!(row, get(col_vals, col, missing))
        end
        push!(df, row)
    end

    if isnothing(prefix_name)
        df_to_container!(data, df)
    else
        data[prefix_name] = df
    end
    return
end

function _determine_num_indices(
    model::Union{Nothing,JuMPConverter.Model},
    prefix_name::Union{Nothing,String},
    all_col_names::Vector{String},
    sections::Vector{Tuple{Vector{String},Vector{Any}}},
)
    # From model info (most reliable)
    if !isnothing(model) && !isnothing(prefix_name)
        nd = _param_ndims(model, prefix_name)
        if !isnothing(nd) && nd > 0
            return nd - 1  # named: col headers provide one dimension
        end
    end
    if !isnothing(model) && !isempty(all_col_names)
        nd = _param_ndims(model, all_col_names[1])
        if !isnothing(nd) && nd > 0
            return nd  # unnamed: all dims come from row indices
        end
    end
    # Heuristic: try num_indices 1, 2, 3 against first section
    if !isempty(sections)
        first_cols, first_vals = sections[1]
        num_cols = length(first_cols)
        for ni in 1:3
            rs = ni + num_cols
            (isempty(first_vals) || length(first_vals) % rs != 0) && continue
            ok = true
            for row_start in 1:rs:length(first_vals)
                for k in 0:(ni-1)
                    if !(first_vals[row_start+k] isa Int)
                        ok = false
                        break
                    end
                end
                ok || break
            end
            ok && return ni
        end
    end
    return 1
end

"""
Parse slice notation: `param E [*,*,1]: col1 col2 := ...`
Handles 3D arrays stored slice-by-slice.
Also handles `let x[1] := val` (subscript assignment) by skipping.
"""
function _dat_parse_slice!(lex::Lexer, data::Dict{String,Any}, name::String)
    arr_data = Dict{Vector{Int},Union{Float64,Missing}}()
    dim_sizes = zeros(Int, 3)  # Will be expanded if needed
    # Parse all slices
    while true
        # Read [*,*,h] or [subscript] bracket
        expect!(lex, TOKEN_LBRACKET)
        bracket_content =
            read_balanced!(lex, TOKEN_LBRACKET, TOKEN_RBRACKET; compact = true)
        # If followed by := it's a subscript assignment (e.g. let x[1] := 0) — skip
        if peek(lex).kind == TOKEN_ASSIGN
            read_token!(lex)  # consume :=
            _read_dat_value!(lex)  # skip value
            return
        end
        # Extract the fixed index from the bracket (last number)
        m = match(r"(\d+)\s*$", bracket_content)
        if isnothing(m)
            error("Cannot parse slice index from [$bracket_content]")
        end
        slice_idx = parse(Int, m.captures[1])
        num_dims = count(==(','), bracket_content) + 1
        if length(dim_sizes) < num_dims
            resize!(dim_sizes, num_dims)
        end
        dim_sizes[num_dims] = max(dim_sizes[num_dims], slice_idx)
        # Expect : then column headers then :=
        expect!(lex, TOKEN_COLON)
        col_indices = Int[]
        while peek(lex).kind != TOKEN_ASSIGN &&
                  peek(lex).kind != TOKEN_SEMICOLON &&
                  peek(lex).kind != TOKEN_EOF
            t = read_token!(lex)
            if t.kind == TOKEN_NUMBER
                push!(col_indices, parse(Int, t.value))
            end
        end
        if peek(lex).kind == TOKEN_ASSIGN
            read_token!(lex)
        end
        num_cols = length(col_indices)
        dim_sizes[2] =
            max(dim_sizes[2], isempty(col_indices) ? 0 : maximum(col_indices))
        # Read data rows until next [ or ;
        while peek(lex).kind != TOKEN_LBRACKET &&
                  peek(lex).kind != TOKEN_SEMICOLON &&
                  peek(lex).kind != TOKEN_EOF
            t = peek(lex)
            if t.kind == TOKEN_NUMBER || t.kind == TOKEN_MINUS
                # Read row: row_idx val1 val2 ...
                row_idx_val = _read_dat_value!(lex)
                row_idx =
                    row_idx_val isa Int ? row_idx_val :
                    parse(Int, string(row_idx_val))
                dim_sizes[1] = max(dim_sizes[1], row_idx)
                for w_idx in col_indices
                    val = _read_dat_value!(lex)
                    indices = [row_idx, w_idx, slice_idx]
                    arr_data[indices] = val isa Missing ? missing : Float64(val)
                end
            elseif t.kind == TOKEN_DOT
                val = _read_dat_value!(lex)  # reads the dot as missing
            else
                read_token!(lex)
            end
        end
        # Check if there's another slice
        if peek(lex).kind != TOKEN_LBRACKET
            break
        end
    end
    # Build 3D array
    if !isempty(arr_data)
        dim1 = max(1, dim_sizes[1])
        dim2 = max(1, dim_sizes[2])
        dim3 = max(1, dim_sizes[3])
        result = Array{Union{Float64,Missing}}(undef, dim1, dim2, dim3)
        fill!(result, NaN)
        for (indices, val) in arr_data
            result[indices[1], indices[2], indices[3]] = val
        end
        data[name] = result
    end
    return
end

"""
    parse_dat(text::String, model::Union{JuMPConverter.Model,Nothing} = nothing) -> Dict{String, Any}

Parse AMPL .dat content using the tokenizer. Uses model info to determine
parameter dimensionality.
"""
function parse_dat(
    text::String,
    model::Union{JuMPConverter.Model,Nothing} = nothing,
)
    data = Dict{String,Any}()
    lex = Lexer(text)
    while peek(lex).kind != TOKEN_EOF
        t = peek(lex)
        if t.kind == TOKEN_SEMICOLON
            read_token!(lex)
            continue
        end
        if t.kind != TOKEN_IDENTIFIER
            read_token!(lex)
            continue
        end
        kw = t.value
        if kw == "param"
            read_token!(lex)
            _dat_parse_param!(lex, data, model)
        elseif kw == "set"
            read_token!(lex)
            _dat_parse_set!(lex, data)
        elseif kw == "let"
            read_token!(lex)
            if peek(lex).kind == TOKEN_LBRACE
                # Indexed let: let{s in S} name[idx] := expr; — skip
                while peek(lex).kind != TOKEN_SEMICOLON &&
                    peek(lex).kind != TOKEN_EOF
                    read_token!(lex)
                end
            else
                _dat_parse_param!(lex, data, model)
            end
        elseif kw == "fix"
            read_token!(lex)
            @warn("fix is not supported yet")
            while peek(lex).kind != TOKEN_SEMICOLON &&
                peek(lex).kind != TOKEN_EOF
                read_token!(lex)
            end
        elseif kw == "for" || kw == "if"
            read_token!(lex)
            depth = 0
            while peek(lex).kind != TOKEN_EOF
                tk = peek(lex)
                if tk.kind in (TOKEN_LBRACE, TOKEN_LBRACKET, TOKEN_LPAREN)
                    depth += 1
                    read_token!(lex)
                elseif tk.kind in (TOKEN_RBRACE, TOKEN_RBRACKET, TOKEN_RPAREN)
                    depth -= 1
                    read_token!(lex)
                elseif tk.kind == TOKEN_SEMICOLON && depth == 0
                    break
                else
                    read_token!(lex)
                end
            end
        else
            read_token!(lex)
        end
        if peek(lex).kind == TOKEN_SEMICOLON
            read_token!(lex)
        end
    end
    return data
end
