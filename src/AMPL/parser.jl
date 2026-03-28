import DataFrames
import OrderedCollections
import JuMP

function _parse(T::Type, s::AbstractString; allow_dot::Bool = false)
    s = strip(s)
    if allow_dot && s == "."
        return missing
    else
        parse(T, s)
    end
end

# TODO remove
_maybe_parse(T::Type, s::AbstractString) = _parse(T, s; allow_dot = true)
_maybe_parse(s::AbstractString) = _maybe_parse(Float64, s)

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

function _concrete_eltype(container)
    if any(Base.Fix2(isa, AbstractString), container)
        return String
    end
    return mapreduce(typeof, promote_type, container, init = Int)
end

"""
    read_ampl_dat(filename::String) -> Dict{String, Any}

Read an AMPL .dat file and return a dictionary mapping parameter names to their values.

# Arguments
- `filename::String`: Path to the AMPL .dat file

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
function read_ampl_dat(filename::String)
    s = read(filename, String)
    return parse_ampl_dat(s)
end

function _convert_to_concrete_eltype(container::Vector)
    T = _concrete_eltype(container)
    return convert(Vector{T}, container)
end

"""
    parse_ampl_dat(text::String) -> Dict{String, Any}

Parse AMPL .dat file content from a vector of lines.

# Arguments
- `text::String`: Text from the AMPL .dat file

# Returns
- `Dict{String, Any}`: Dictionary mapping parameter names to values
"""
function parse_ampl_dat(text::String)
    data = Dict{String, Any}()
    for element in split(text, ";")
        element = strip(element)
        if startswith(element, "fix")
            @warn("fix is not supported yet")
            continue
        end
        if !isempty(element)
            parsed = parse_element(element)
            if parsed isa DataFrames.DataFrame
                df_to_container!(data, parsed)
            else
                name, value = parsed
                data[name] = value
            end
        end
    end
    return data
end

function parse_element(element::AbstractString)
    while startswith(element, "#")
        i = findfirst(isequal('\n'), element)
        element = strip(chop(element, head = i, tail = 0))
    end
    command, rest = _get_command(element, ["param", "let", "set"])
    if command == "param"
        parse_param(rest)
    elseif command == "let"
        # TODO what's the different with let ?
        parse_param(rest)
    else
        @assert command == "set"
        parse_set(rest)
    end
end

function _get_command(s::AbstractString, expected::Vector{String})
    for command in expected
        if startswith(s, command)
            return command, chop(s, head = length(command), tail = 0)
        end
    end
    error("Cannot parse element, does not start with any of the commands $expected in:\"\n$s\"")
end

function parse_set(element::AbstractString)
    name, values_str = strip.(split(element, ":="))
    # Parse space-separated values
    if startswith(values_str, "(")
        i = 1
        sub = String[]
        while i < length(values_str)
            j = findfirst(isequal(')'), values_str[i:end])
            j += i - 1
            push!(sub, values_str[i:j])
            i = findfirst(isequal('('), values_str[j:end])
            if isnothing(i)
                break
            end
            i += j - 1
        end
    elseif contains(values_str, ",")
        sub = split(values_str, ',')
    else
        sub = split(values_str, " ")
    end
    parsed_values = _any_parse.(sub)
    value = _convert_to_concrete_eltype(parsed_values)
    return name, value
end

function _lines(element::AbstractString)
    return filter(map(strip, split(element, "\n"))) do line
        return !isempty(line) && !startswith(line, "#")
    end
end

function parse_param(element::AbstractString)
    header, data = strip.(split(element, ":=", limit = 2))
    if contains(header, "[")
        return parse_indexed_table(element)
    elseif contains(header, ":")
        if startswith(header, ":")
            # No name so we create a DataFrame and it will be one variable per column
            header = strip(chop(header, head = 1, tail = 0))
            return parse_dataframe(header, data)
        else
            name, header = split(header, ":")
            return name, parse_dataframe(header, data)
        end
    end

    lines = _lines(element)

    i = 1
    line = lines[i]
    
    # Parse scalar parameter: param NAME := VALUE;
    m = match(r"(\w+)\s*:=\s*([^;]+)", line)
    if m !== nothing
        @assert i == length(lines)
        return m.captures[1], _any_parse(m.captures[2])
    end
    
    # Parse 1D array: param NAME := INDEX1 VAL1 INDEX2 VAL2 ... ;
    # or multi-line: param NAME := \n INDEX1 VAL1 \n INDEX2 VAL2 \n ... ;
    m = match(r"(\w+)\s*:=\s*$", line)
    if m !== nothing
        name = m.captures[1]
        i += 1  # Move to next line
        arr_data = Dict{Int, Float64}()
        while i <= length(lines)
            line = strip(lines[i])
            if line == ";" || isempty(line)
                i += 1
                break
            end
            # Remove trailing semicolon if present
            line = replace(line, r";\s*$" => "")
            parts = split(line)
            if length(parts) >= 2
                idx = parse(Int, parts[1])
                arr_data[idx] = _maybe_parse(parts[2])
            end
            i += 1
        end
        # Convert to vector
        @assert !isempty(arr_data)
        max_idx = maximum(keys(arr_data))
        value = Vector{Float64}(undef, max_idx)
        fill!(value, NaN)
        for (idx, val) in arr_data
            value[idx] = val
        end
        @assert i == length(lines) + 1
        return name, value
    end

    error("Cannot parse parameter:\"\n$element\"")
end

"""
    parse_dataframe(lines, start_idx, data) -> Union{Int, Nothing}

Parse multi-column table format: param : col1 col2 ... := data ;
For format like: param \n : rho beta alpha := \n 1 val1 val2 val3 \n ...
"""
function parse_dataframe(header_line::AbstractString, table::AbstractString)
    lines = _lines(table)
    col_names = split(strip(header_line))
    num_cols = length(col_names)
    
    @assert num_cols > 0
    
    # Parse data rows to determine structure
    # First, scan to see if we have 1 or 2 indices
    scan_i = 1
    sample_line = ""
    while scan_i <= length(lines)
        scan_line = strip(lines[scan_i])
        if scan_line == ";" || isempty(scan_line)
            break
        end
        if scan_line != ":" && !startswith(scan_line, ":")
            sample_line = scan_line
            break
        end
        scan_i += 1
    end

    # Determine number of indices by checking first data line
    num_indices = 1
    all_ints = true
    if !isempty(sample_line)
        parts = split(sample_line)
        # If we have more parts than columns, check if first two are integers
        num_indices = length(parts) - num_cols
        for i in 1:num_indices
            all_ints = all_ints && !isnothing(tryparse(Int, parts[i]))
        end
    end

    # Move i to start of data (after header line)
    i = 1
    if all_ints
        IndexType = NTuple{num_indices,Int}
    else
        @assert num_indices == 1
        IndexType = String
    end
    cols = Any["index" => IndexType[]]
    for col in col_names
        push!(cols, col => Union{Float64,Missing}[])
    end

    df = DataFrames.DataFrame(cols)

    # Fill up dataframe
    while i <= length(lines)
        line = strip(lines[i])

        if line == ";" || isempty(line)
            i += 1
            break
        end
        
        # Skip header lines with just ":"
        if line == ":" || (startswith(line, ":") && !occursin(":=", line))
            i += 1
            continue
        end
        
        parts = split(line)
        index = if all_ints
            ntuple(i -> parse(Int, parts[i]), num_indices)
        else
            parts[1]
        end
        vals = Any[index]
        
        for (col_idx, col_name) in enumerate(col_names)
            val_idx = num_indices + col_idx  # Skip first two parts (indices)
            push!(vals, _maybe_parse(parts[val_idx]))
        end

        push!(df, vals)
       
        i += 1
    end

    return df
end

function _range(bounds::NTuple{2,Int})
    if bounds[1] == 1
        return Base.OneTo(bounds[2])
    else
        return bounds[1]:bounds[2]
    end
end

function _axes(indices::Vector{NTuple{N,Int}}) where N
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

function df_to_container!(data::Dict{String, Any}, df::DataFrames.DataFrame)
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
            dict = OrderedCollections.OrderedDict{NTuple{length(ax),Int}, Float64}()
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
    parse_indexed_table(lines, start_idx, data) -> Union{Int, Nothing}

Parse indexed table format: param NAME [dims] : header := data ;
Handles 1D, 2D, 3D+ arrays.
"""
function parse_indexed_table(text::AbstractString)
    lines = _lines(text)
    i = 1
    line = strip(lines[i])
    
    # Extract parameter name and dimensions
    # Format: param NAME [*,*,1] or param \n NAME [*,*,1]
    param_name::String = ""
    dims_pattern::String = ""
    
    # Check if param is on its own line (with optional trailing space)
    if occursin(r"^param\s*$", line)
        if i + 1 <= length(lines)
            next_line = strip(lines[i + 1])
            # Match: "E [*,*,1]" or "NAME [dims]"
            m = match(r"^(\w+)\s+(\[.*?\])", next_line)
            if m !== nothing
                param_name = string(m.captures[1])
                dims_pattern = string(m.captures[2])
                i += 1
            else
                return nothing
            end
        else
            return nothing
        end
    else
        # Try to match param NAME [dims] on same line
        m = match(r"(\w+)\s+(\[.*?\])", line)
        if m !== nothing
            param_name = string(m.captures[1])
            dims_pattern = string(m.captures[2])
        else
            return nothing
        end
    end
    
    # Count dimensions from pattern [*,*,1] -> 3 dimensions
    # Count commas and add 1 (e.g., [*,*,1] has 2 commas, so 3 dimensions)
    num_dims = count(==(','), dims_pattern) + 1
    
    # Parse the data
    # Skip the line with [*,*,h] if it's on the current line, otherwise it's already been consumed
    if i <= length(lines)
        line = strip(lines[i])
        if occursin(r"\[.*?,\s*\d+\]", line)
            i += 1  # Move past the [*,*,h] line
        end
    end
    
    # Initialize storage based on dimensions
    if num_dims == 1
        # 1D array: simple list
        arr_data = Dict{Int, Union{Float64, Missing}}()
        while i <= length(lines)
            line = strip(lines[i])
            if line == ";" || isempty(line)
                i += 1
                break
            end
            parts = split(line)
            if length(parts) >= 2
                idx = parse(Int, parts[1])
                arr_data[idx] = _maybe_parse(parts[2])
            end
            i += 1
        end
        # Convert to vector
        @assert !isempty(arr_data)
        max_idx = maximum(keys(arr_data))
        result = Vector{Float64}(undef, max_idx)
        fill!(result, NaN)
        for (idx, val) in arr_data
            result[idx] = val
        end
        return param_name, result
    elseif num_dims == 2
        # 2D array: table format
        arr_data = Dict{Tuple{Int, Int}, Union{Float64, Missing}}()
        while i <= length(lines)
            line = strip(lines[i])
            if line == ";" || isempty(line)
                i += 1
                break
            end
            # Skip header lines
            if line == ":" || startswith(line, ":")
                i += 1
                continue
            end
            parts = split(line)
            if length(parts) >= 3
                idx1 = parse(Int, parts[1])
                idx2 = parse(Int, parts[2])
                arr_data[(idx1, idx2)] = _maybe_parse(parts[3])
            end
            i += 1
        end
        # Convert to 2D array
        @assert !isempty(arr_data)
        max_idx1 = maximum([k[1] for k in keys(arr_data)])
        max_idx2 = maximum([k[2] for k in keys(arr_data)])
        result = Matrix{Union{Float64, Missing}}(undef, max_idx1, max_idx2)
        fill!(result, NaN)
        for ((idx1, idx2), val) in arr_data
            result[idx1, idx2] = val
        end
        return param_name, result
    else
        # 3D+ array: handle slice-by-slice
        return param_name, parse_multi_dimensional_array(lines, i, num_dims)
    end
end

"""
    parse_multi_dimensional_array(lines, start_idx, param_name, num_dims) -> Int

Parse multi-dimensional arrays (3D+) that are stored slice-by-slice in AMPL format.
"""
function parse_multi_dimensional_array(
    lines::Vector{<:AbstractString}, 
    start_idx::Int, 
    num_dims::Int
)
    i = start_idx
    arr_data = Dict{Vector{Int}, Union{Float64, Missing}}()
    current_slice_indices = Dict{Int, Int}()  # Track which slice we're in for each dimension
    
    # Determine dimension sizes by parsing all data first
    dim_sizes = zeros(Int, num_dims)
    
    while i <= length(lines)
        line = strip(lines[i])
        
        if line == ";"
            i += 1
            break
        end
        
        # Check for new slice indicator: [*,*,h] or [*,*,h] :
        # Match [*,*,h] with or without trailing colon
        m = match(r"\[.*?,\s*(\d+)\]", line)
        if m !== nothing
            # This indicates a new slice for the last dimension
            slice_idx = parse(Int, m.captures[1])
            current_slice_indices[num_dims] = slice_idx
            dim_sizes[num_dims] = max(dim_sizes[num_dims], slice_idx)
            i += 1
            # Skip header line with column indices (if present)
            if i <= length(lines) && (strip(lines[i]) == ":" || startswith(strip(lines[i]), ":"))
                i += 1
            end
            continue
        end
        
        # Skip header lines
        if line == ":" || startswith(line, ":")
            i += 1
            continue
        end
        
        # Parse data row
        # For 3D array E[s,w,h] in format: s w1 w2 w3 w4
        # First part is s (dimension 1), remaining parts are values for different w (dimension 2)
        # h (dimension 3) comes from current_slice_indices
        parts = split(line)
        if length(parts) >= 2
            # First part is the index for dimension 1 (s)
            try
                idx1 = parse(Int, parts[1])
                dim_sizes[1] = max(dim_sizes[1], idx1)
                
                # Remaining parts are values for dimension 2 (w) for this s and current h
                h_idx = get(current_slice_indices, num_dims, 1)  # Default to 1 if not set
                for (w_idx, val_str) in enumerate(parts[2:end])
                    # For 3D: E[s, w, h]
                    indices = [idx1, w_idx, h_idx]
                    arr_data[indices] = _maybe_parse(val_str)
                    dim_sizes[2] = max(dim_sizes[2], w_idx)
                end
            catch
                # Skip if first part is not an integer (might be a header or comment)
            end
        end
        
        i += 1
    end
    
    # Create multi-dimensional array
    if !isempty(arr_data)
        # For 3D, create a 3D array; for higher dimensions, use nested structure
        if num_dims == 3
            # Ensure all dimensions are at least 1
            dim1 = max(1, dim_sizes[1])
            dim2 = max(1, dim_sizes[2])
            dim3 = max(1, dim_sizes[3])
            result = Array{Union{Float64, Missing}}(undef, dim1, dim2, dim3)
            # Initialize with NaN
            fill!(result, NaN)
            for (indices, val) in arr_data
                if length(indices) == 3
                    result[indices[1], indices[2], indices[3]] = val
                end
            end
        else
            # For 4D+, store as nested structure or use a more complex representation
            # For now, store as Dict mapping indices to values
            result = arr_data
        end
        return result
    end
    
    return i
end
