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
function read_dat(filename::String, model::Union{JuMPConverter.Model,Nothing} = nothing)
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
    # Store each column as a separate parameter
    for col in DataFrames.names(df)
        if col == "index"
            continue
        end
        vals = df[!, col]
        sz = length.(ax)
        container = if length(vals) < prod(sz) || any(ismissing, vals)
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
            inner = read_balanced!(lex, TOKEN_LPAREN, TOKEN_RPAREN)
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
"""
function _dat_parse_multi_column!(
    lex::Lexer,
    data::Dict{String,Any},
    model::Union{Nothing,JuMPConverter.Model},
    prefix_name::Union{Nothing,String},
)
    col_names = String[]
    while peek(lex).kind != TOKEN_ASSIGN &&
              peek(lex).kind != TOKEN_SEMICOLON &&
              peek(lex).kind != TOKEN_EOF
        t = read_token!(lex)
        if t.kind == TOKEN_IDENTIFIER || t.kind == TOKEN_NUMBER
            push!(col_names, t.value)
        end
    end
    if peek(lex).kind == TOKEN_ASSIGN
        read_token!(lex)
    end
    num_cols = length(col_names)
    if num_cols == 0
        return
    end
    all_values = Any[]
    while peek(lex).kind != TOKEN_SEMICOLON && peek(lex).kind != TOKEN_EOF
        t = peek(lex)
        if t.kind == TOKEN_COMMA
            read_token!(lex)
            continue
        elseif t.kind == TOKEN_COLON
            read_token!(lex)
            continue
        end
        push!(all_values, _read_dat_value!(lex))
    end
    if isempty(all_values)
        return
    end
    # Determine number of index columns
    num_indices = nothing
    if !isnothing(model) && !isnothing(prefix_name)
        nd = _param_ndims(model, prefix_name)
        if !isnothing(nd) && nd > 0
            # For named tables, column headers provide one dimension
            num_indices = nd - 1
        end
    end
    if isnothing(num_indices) && !isnothing(model)
        nd = _param_ndims(model, col_names[1])
        if !isnothing(nd) && nd > 0
            num_indices = nd
        end
    end
    if isnothing(num_indices)
        for ni in 1:3
            rs = ni + num_cols
            if length(all_values) % rs != 0
                continue
            end
            # Validate that all index positions are integers
            indices_ok = true
            for row_start in 1:rs:length(all_values)
                for j in 0:(ni-1)
                    if !(all_values[row_start+j] isa Int)
                        indices_ok = false
                        break
                    end
                end
                indices_ok || break
            end
            if indices_ok
                num_indices = ni
                break
            end
        end
    end
    if isnothing(num_indices)
        num_indices = 1
    end
    row_size = num_indices + num_cols
    all_ints =
        all(i -> all_values[i] isa Int, 1:min(num_indices, length(all_values)))
    IndexType = if all_ints
        NTuple{num_indices,Int}
    else
        @assert num_indices == 1
        String
    end
    cols = Any["index"=>IndexType[]]
    for col in col_names
        push!(cols, col => Union{Float64,Missing}[])
    end
    df = DataFrames.DataFrame(cols)
    i = 1
    while i + row_size - 1 <= length(all_values)
        idx = if all_ints
            ntuple(j -> all_values[i+j-1]::Int, num_indices)
        else
            string(all_values[i])
        end
        vals = Any[idx]
        for j in 1:num_cols
            v = all_values[i+num_indices+j-1]
            push!(vals, v isa Missing ? missing : Float64(v))
        end
        push!(df, vals)
        i += row_size
    end
    if isnothing(prefix_name)
        # Unnamed: each column becomes a separate parameter
        df_to_container!(data, df)
    else
        # Named: store as DataFrame under the prefix name
        data[prefix_name] = df
    end
    return
end

"""
Parse slice notation: `param E [*,*,1]: col1 col2 := ...`
Handles 3D arrays stored slice-by-slice.
"""
function _dat_parse_slice!(lex::Lexer, data::Dict{String,Any}, name::String)
    arr_data = Dict{Vector{Int},Union{Float64,Missing}}()
    dim_sizes = zeros(Int, 3)  # Will be expanded if needed
    # Parse all slices
    while true
        # Read [*,*,h] bracket
        expect!(lex, TOKEN_LBRACKET)
        bracket_content = read_balanced!(lex, TOKEN_LBRACKET, TOKEN_RBRACKET)
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
function parse_dat(text::String, model::Union{JuMPConverter.Model,Nothing} = nothing)
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
            _dat_parse_param!(lex, data, model)
        elseif kw == "fix"
            read_token!(lex)
            @warn("fix is not supported yet")
            while peek(lex).kind != TOKEN_SEMICOLON &&
                peek(lex).kind != TOKEN_EOF
                read_token!(lex)
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
