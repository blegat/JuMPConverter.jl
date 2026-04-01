"""
    GDXDirective(gdx_file, symbols)

A `\$gdxIn`/`\$load` directive pair extracted from preprocessing.
"""
struct GDXDirective
    gdx_file::String
    symbols::Vector{String}
end

"""
    _preprocess(mod)

Preprocess GAMS source: strip comments, handle block comments,
extract `\$gdxIn`/`\$load` directives.

Returns `(preprocessed_text, gdx_directives)`.
"""
function _preprocess(mod::AbstractString)
    lines = split(mod, '\n')
    filtered = String[]
    gdx_directives = GDXDirective[]
    current_gdx_file = nothing
    in_block_comment = false
    in_echo_block = false
    for line in lines
        stripped = rstrip(line)
        # Handle $onText/$offText block comments
        if startswith(lowercase(lstrip(stripped)), "\$offtext")
            in_block_comment = false
            continue
        end
        if in_block_comment
            continue
        end
        if startswith(lowercase(lstrip(stripped)), "\$ontext")
            in_block_comment = true
            continue
        end
        # Handle $onechoV/$offecho blocks (skip entirely)
        if startswith(lowercase(lstrip(stripped)), "\$offecho")
            in_echo_block = false
            continue
        end
        if in_echo_block
            continue
        end
        if occursin(r"\$onecho"i, stripped)
            in_echo_block = true
            continue
        end
        # Skip * comments (must be in column 1)
        if startswith(stripped, '*')
            continue
        end
        # Handle $ directives
        if startswith(stripped, '$')
            directive = strip(stripped[2:end])
            dl = lowercase(directive)
            if startswith(dl, "gdxin")
                rest = strip(directive[6:end])
                if isempty(rest)
                    current_gdx_file = nothing  # $gdxin with no args closes
                else
                    # Remove quotes
                    current_gdx_file = replace(rest, "\"" => "")
                end
            elseif startswith(dl, "load")
                # $load, $loadDC, $loadM, etc.
                rest = replace(directive, r"^load\w*\s+"i => "")
                symbols = [strip(s) for s in split(rest) if !isempty(strip(s))]
                if !isnothing(current_gdx_file) && !isempty(symbols)
                    push!(gdx_directives, GDXDirective(current_gdx_file, symbols))
                end
            end
            # Skip all other $ directives ($if, $eval, $set, $batinclude, $onEmpty, etc.)
            continue
        end
        push!(filtered, stripped)
    end
    return join(filtered, '\n'), gdx_directives
end

"""
    clean_expression(expr)

Transform GAMS expression syntax to JuMP/Julia syntax:
- `power(base, exp)` → `(base)^(exp)`
- `**` → `^`
- Case-insensitive `=e=`, `=l=`, `=g=` → `==`, `<=`, `>=`
"""
function clean_expression(expr::AbstractString)
    s = expr
    # Convert `power(base, exp)` to `(base)^(exp)`.
    # Must handle nested parentheses in base argument.
    while true
        m = match(r"power\s*\("i, s)
        m === nothing && break
        start = m.offset
        # Find the matching arguments by counting parens
        paren_start = m.offset + length(m.match) - 1  # position of '('
        depth = 1
        i = paren_start + 1
        comma_pos = nothing
        while i <= ncodeunits(s) && depth > 0
            c = s[i]
            if c == '('
                depth += 1
            elseif c == ')'
                depth -= 1
            elseif c == ',' && depth == 1 && comma_pos === nothing
                comma_pos = i
            end
            i += 1
        end
        if comma_pos === nothing || depth != 0
            break  # malformed, give up
        end
        paren_end = i - 1  # position of closing ')'
        base = strip(s[(paren_start+1):(comma_pos-1)])
        exp = strip(s[(comma_pos+1):(paren_end-1)])
        s = s[1:(start-1)] * "($base)^($exp)" * s[(paren_end+1):end]
    end
    # Convert ** to ^
    s = replace(s, "**" => "^")
    # Convert constraint operators (case-insensitive)
    s = replace(s, r"=e="i => "==")
    s = replace(s, r"=l="i => "<=")
    s = replace(s, r"=g="i => ">=")
    return s
end

"""
    convert_gams_expression(expr, model)

Convert a GAMS expression to Julia/JuMP syntax:
- `sum(domain, body)` → `sum(body for domain_var in domain_set)`
- `param(idx1,idx2)` → `param[idx1,idx2]`
- Also calls `clean_expression` for operator conversion.
"""
function convert_gams_expression(expr::AbstractString, model::JuMPConverter.Model)
    s = clean_expression(expr)
    # Convert sum(domain, body) to sum(body for vars in sets)
    s = _convert_sums(s, model)
    # Convert parameter/variable indexing: name(idx1,idx2) → name[idx1,idx2]
    # Must do this AFTER sum conversion to avoid converting sum(...)
    s = _convert_indexing(s, model)
    return s
end

"""
    _convert_sums(s, model)

Convert GAMS sum expressions to Julia generator syntax.
Handles both `sum(set, body)` and `sum((set1,set2), body)`.
"""
function _convert_sums(s::AbstractString, model::JuMPConverter.Model)
    result = s
    search_from = 1
    while true
        m = match(r"\bsum\s*\("i, result, search_from)
        m === nothing && break
        start = m.offset
        paren_start = m.offset + length(m.match) - 1
        # Find matching close paren and the domain-body comma
        depth = 1
        i = paren_start + 1
        comma_pos = nothing
        while i <= ncodeunits(result) && depth > 0
            c = result[i]
            if c == '(' || c == '['
                depth += 1
            elseif c == ')' || c == ']'
                depth -= 1
            elseif c == ',' && depth == 1 && comma_pos === nothing
                comma_pos = i
            end
            i += 1
        end
        if comma_pos === nothing || depth != 0
            # Already converted or malformed — skip past this match
            search_from = paren_start + 1
            continue
        end
        paren_end = i - 1
        domain_str = strip(result[(paren_start+1):(comma_pos-1)])
        body = strip(result[(comma_pos+1):(paren_end-1)])
        # Recursively convert sums in the body
        body = _convert_sums(body, model)
        # Parse domain: either single set name or (set1, set2, ...)
        # Handle $ conditions: sum(set$cond, body) or sum((s1,s2)$cond, body)
        condition = nothing
        if occursin(r"\$", domain_str) && !startswith(domain_str, "(")
            parts = split(domain_str, "\$", limit = 2)
            domain_str = strip(parts[1])
            condition = strip(parts[2])
        elseif startswith(domain_str, "(")
            inner_m = match(r"^\(([^)]+)\)\s*\$\s*(.+)$", domain_str)
            if inner_m !== nothing
                domain_str = "(" * inner_m.captures[1] * ")"
                condition = inner_m.captures[2]
            end
        end
        # Parse domain names — handle both simple "jc" and complex "js1(s,j)"
        if startswith(domain_str, "(")
            inner = strip(domain_str[2:end-1])
            sets = [strip(x) for x in split(inner, ',')]
        else
            # Could be "jc" or "js1(s,j)" — strip parenthetical part for generator
            dm = match(r"^(\w+)", domain_str)
            sets = dm !== nothing ? [dm.captures[1]] : [domain_str]
        end
        gen_str = join(["$s in $s" for s in sets], ", ")
        if condition !== nothing
            converted = "sum($body for $gen_str if $condition)"
        else
            converted = "sum($body for $gen_str)"
        end
        result = result[1:(start-1)] * converted * result[(paren_end+1):end]
        search_from = start + length(converted)
    end
    return result
end

"""
    _convert_indexing(s, model)

Convert GAMS-style parenthetical indexing to Julia bracket indexing.
`param(i,j)` → `param[i,j]` for known parameters/variables.
"""
function _convert_indexing(s::AbstractString, model::JuMPConverter.Model)
    known_names = Base.Set{String}()
    for k in keys(model.parameters)
        push!(known_names, k)
    end
    for k in keys(model.variables)
        push!(known_names, k)
    end
    # Also add aliases
    for k in keys(model.aliases)
        push!(known_names, k)
    end
    # Match word(args) patterns and convert to word[args] if word is a known name
    # Process from right to left to handle nested correctly
    result = s
    while true
        changed = false
        for m in reverse(collect(eachmatch(r"\b(\w+)\s*\(", result)))
            name = m.captures[1]
            # Skip known functions
            if lowercase(name) in ("sum", "power", "sqr", "sqrt", "abs", "exp",
                                    "log", "sin", "cos", "min", "max", "mod",
                                    "ceil", "floor", "round", "sign", "ord", "card")
                continue
            end
            if lowercase(name) in known_names || name in known_names
                # Find matching close paren
                paren_start = m.offset + length(m.match) - 1
                depth = 1
                i = paren_start + 1
                while i <= ncodeunits(result) && depth > 0
                    c = result[i]
                    if c == '('
                        depth += 1
                    elseif c == ')'
                        depth -= 1
                    end
                    i += 1
                end
                if depth == 0
                    paren_end = i - 1
                    args = result[(paren_start+1):(paren_end-1)]
                    before = result[1:(m.offset-1)]
                    after = result[(paren_end+1):end]
                    result = before * name * "[" * args * "]" * after
                    changed = true
                    break  # restart since offsets changed
                end
            end
        end
        !changed && break
    end
    return result
end

function parse_set(model::JuMPConverter.Model, s::AbstractString)
    # GAMS set declarations can span multiple lines within a single semicolon-terminated block.
    # An alias() call may also appear within the same semicolon-delimited block.
    lines = split(s, '\n')
    for line in lines
        line = strip(line)
        isempty(line) && continue
        # Check if this line is actually an alias declaration
        if startswith(lowercase(line), "alias")
            parse_alias(model, replace(line, r"^alias\s*"i => ""))
            continue
        end
        m = match(r"^\s*(\w+)(?:\(([^)]*)\))?\s*(.*?)(?:\s*/\s*(.*?)\s*/)?$", line)
        m === nothing && continue
        name = lowercase(m.captures[1])
        parent_str = m.captures[2]
        parent = parent_str !== nothing ? lowercase(strip(split(parent_str, ',')[1])) : nothing
        push!(model, JuMPConverter.Set(; name, parent))
    end
end

function parse_parameter_decl(model::JuMPConverter.Model, s::AbstractString)
    # GAMS parameter declarations span multiple lines:
    #   parameters  c(j)        objective coefs
    #               cobj        objective constant
    #               b(i)        right hand sides
    #               ac (i,jc)   matrix coefs: continuous variables
    # Each parameter starts with name or name(domain) followed by description.
    # Inline data: name(domain) / key1 val1, key2 val2 /
    lines = split(s, '\n')
    for line in lines
        line = strip(line)
        isempty(line) && continue
        # Match: name or name(domain) followed by optional description and optional / data /
        m = match(r"^\s*(\w+)\s*(?:\(([^)]*)\))?\s*(.*?)(?:\s*/\s*(.*?)\s*/)?$", line)
        m === nothing && continue
        name = lowercase(m.captures[1])
        domain_str = m.captures[2]
        domain = domain_str !== nothing ?
            [lowercase(strip(d)) for d in split(domain_str, ',')] : String[]
        push!(model, JuMPConverter.Parameter(; name, domain))
    end
end

function parse_scalar_decl(model::JuMPConverter.Model, s::AbstractString)
    # Parse scalar declarations like: f description / value /
    remaining = strip(s)
    while !isempty(remaining)
        m = match(r"^\s*(\w+)\s*", remaining)
        m === nothing && break
        name = lowercase(m.captures[1])
        remaining = strip(remaining[length(m.match)+1:end])
        # Skip description, look for / value /
        if occursin('/', remaining)
            slash1 = findfirst('/', remaining)
            slash2 = findnext('/', remaining, slash1 + 1)
            if slash2 !== nothing
                remaining = strip(remaining[slash2+1:end])
            end
        end
        push!(model, JuMPConverter.Parameter(; name, domain = String[]))
        # Skip separator
        if startswith(remaining, ",")
            remaining = strip(remaining[2:end])
        end
    end
end

function _split_outside_parens(s::AbstractString, delim::Char=',')
    parts = String[]
    depth = 0
    start = 1
    for i in eachindex(s)
        c = s[i]
        if c == '('
            depth += 1
        elseif c == ')'
            depth -= 1
        elseif c == delim && depth == 0
            push!(parts, s[start:prevind(s, i)])
            start = nextind(s, i)
        end
    end
    push!(parts, s[start:end])
    return parts
end

function _parse_variable_names(
    model::JuMPConverter.Model,
    s::AbstractString;
    lower_bound::Union{Nothing,String} = nothing,
    upper_bound::Union{Nothing,String} = nothing,
    binary::Bool = false,
    integer::Bool = false,
)
    lines = split(s, '\n')
    for line in lines
        for part in _split_outside_parens(line, ',')
            part = strip(part)
            isempty(part) && continue
            m = match(r"^\s*(\w+)\s*(?:\(([^)]*)\))?\s*", part)
            m === nothing && continue
            name = m.captures[1]
            indices_str = m.captures[2]
            axes = nothing
            if indices_str !== nothing
                axe_list = [JuMPConverter.Axe(; name = strip(idx), set = strip(idx))
                            for idx in split(indices_str, ',')]
                axes = JuMPConverter.Axes(; axes = axe_list)
            end
            push!(
                model,
                JuMPConverter.Variable(;
                    name,
                    axes,
                    lower_bound,
                    upper_bound,
                    binary,
                    integer,
                ),
            )
        end
    end
end

# Variable type keywords that can appear on continuation lines
const _VAR_TYPE_PATTERNS = [
    r"\bpositive\s+variables?\b"i => (; lower_bound = "0"),
    r"\bnegative\s+variables?\b"i => (; upper_bound = "0"),
    r"\bbinary\s+variables?\b"i => (; binary = true),
    r"\binteger\s+variables?\b"i => (; integer = true),
    r"\bfree\s+variables?\b"i => (;),
    r"\bsemicont\s+variables?\b"i => (;),
    r"\bsemiint\s+variables?\b"i => (;),
    r"\bsos1\s+variables?\b"i => (;),
    r"\bsos2\s+variables?\b"i => (;),
]

function parse_variable(
    model::JuMPConverter.Model,
    s::AbstractString;
    lower_bound::Union{Nothing,String} = nothing,
    upper_bound::Union{Nothing,String} = nothing,
    binary::Bool = false,
    integer::Bool = false,
)
    # Check if the text contains embedded variable type keywords on continuation lines.
    # e.g. "obj  desc\npositive variables xc(j) desc\nbinary variables xb(j) desc"
    # Split into segments by type keywords and parse each with the right attributes.
    remaining = s
    current_kwargs = (; lower_bound, upper_bound, binary, integer)
    while !isempty(strip(remaining))
        # Find the next type keyword
        next_pos = nothing
        next_len = 0
        next_kwargs = nothing
        for (pat, kwargs) in _VAR_TYPE_PATTERNS
            m = match(pat, remaining)
            if m !== nothing
                pos = m.offset
                if next_pos === nothing || pos < next_pos
                    next_pos = pos
                    next_len = length(m.match)
                    next_kwargs = kwargs
                end
            end
        end
        if next_pos !== nothing
            # Parse everything before this keyword with current kwargs
            before = remaining[1:next_pos-1]
            if !isempty(strip(before))
                _parse_variable_names(model, before; current_kwargs...)
            end
            remaining = remaining[next_pos+next_len:end]
            lb = get(next_kwargs, :lower_bound, nothing)
            ub = get(next_kwargs, :upper_bound, nothing)
            bi = get(next_kwargs, :binary, false)
            int = get(next_kwargs, :integer, false)
            current_kwargs = (; lower_bound = lb, upper_bound = ub, binary = bi, integer = int)
        else
            # No more keywords, parse the rest
            _parse_variable_names(model, remaining; current_kwargs...)
            break
        end
    end
end

function parse_bound(model::JuMPConverter.Model, name, suffix, value)
    name = strip(String(name))
    suffix = lowercase(strip(String(suffix)))
    value = strip(String(value))
    var = get(model.variables, name, nothing)
    if var === nothing
        # Variable not yet declared — create it
        var = JuMPConverter.Variable(; name)
    end
    if suffix == "lo"
        var = JuMPConverter.Variable(;
            name = var.name,
            axes = var.axes,
            lower_bound = value,
            upper_bound = var.upper_bound,
            fixed_value = var.fixed_value,
            binary = var.binary,
            integer = var.integer,
        )
    elseif suffix == "up"
        var = JuMPConverter.Variable(;
            name = var.name,
            axes = var.axes,
            lower_bound = var.lower_bound,
            upper_bound = value,
            fixed_value = var.fixed_value,
            binary = var.binary,
            integer = var.integer,
        )
    elseif suffix == "fx"
        var = JuMPConverter.Variable(;
            name = var.name,
            axes = var.axes,
            lower_bound = var.lower_bound,
            upper_bound = var.upper_bound,
            fixed_value = value,
            binary = var.binary,
            integer = var.integer,
        )
    else
        return  # skip unknown suffixes (initial level .l, model options, etc.)
    end
    push!(model, var)
    return
end

function parse_solve(model::JuMPConverter.Model, s::AbstractString)
    m = match(
        r"solve\s+\w+\s+using\s+\w+\s+(minimizing|maximizing|min|max)\s+(\w+)"i,
        s,
    )
    if m === nothing
        error("Cannot parse solve statement: $s")
    end
    sense_str = lowercase(m.captures[1])
    if startswith(sense_str, "max")
        sense = MOI.MAX_SENSE
    elseif startswith(sense_str, "min")
        sense = MOI.MIN_SENSE
    else
        error("Unsupported sense: $sense_str")
    end
    expression = String(m.captures[2])
    model.objective = JuMPConverter.Objective(; sense, expression)
    return
end

function parse_constraint(
    model::JuMPConverter.Model,
    name::AbstractString,
    indices::Union{Nothing,AbstractString},
    expression::AbstractString,
)
    expression = convert_gams_expression(expression, model)
    axes = nothing
    if indices !== nothing
        axe_list = [JuMPConverter.Axe(; name = strip(idx), set = strip(idx))
                    for idx in split(indices, ',')]
        axes = JuMPConverter.Axes(; axes = axe_list)
    end
    push!(
        model,
        JuMPConverter.Constraint(;
            name = strip(name),
            axes,
            expression = strip(expression),
        ),
    )
    return
end

function parse_alias(model::JuMPConverter.Model, s::AbstractString)
    # Parse alias(j,jj),(v,vv),... or alias(j,jj)
    for m in eachmatch(r"\((\w+)\s*,\s*(\w+)\)", s)
        parent = lowercase(m.captures[1])
        child = lowercase(m.captures[2])
        model.aliases[child] = parent
    end
end

function parse_model(mod::AbstractString; gams_params::Dict{String,String} = Dict{String,String}())
    preprocessed, gdx_directives = _preprocess(mod)
    # Substitute GAMS parameters like %iname%, %MTYPE% in all text
    for (k, v) in gams_params
        preprocessed = replace(preprocessed, "%$k%" => v)
    end
    model = JuMPConverter.Model()
    # Store GDX file path if found
    if !isempty(gdx_directives)
        gdx_file = gdx_directives[1].gdx_file
        for (k, v) in gams_params
            gdx_file = replace(gdx_file, "%$k%" => v)
        end
        model.gdx_file = gdx_file
    end
    commands = filter(!isempty, strip.(split(preprocessed, ';')))
    for command in commands
        command = strip(command)
        isempty(command) && continue
        JuMPConverter._get_command(
            command,
            [
                r"^Model\b"i => (_) -> nothing,
                r"^Equations?\b"i => (_) -> nothing,
                r"^Display\b"i => (_) -> nothing,
                r"^option\b"i => (_) -> nothing,
                r"^alias\b"i =>
                    (rest) -> parse_alias(model, rest),
                r"^Sets?\b"i =>
                    (rest) -> parse_set(model, rest),
                r"^Parameters?\b"i =>
                    (rest) -> parse_parameter_decl(model, rest),
                r"^Scalars?\b"i =>
                    (rest) -> parse_scalar_decl(model, rest),
                r"^Positive\s+Variables?\b"i =>
                    (rest) -> parse_variable(model, rest; lower_bound = "0"),
                r"^Negative\s+Variables?\b"i =>
                    (rest) -> parse_variable(model, rest; upper_bound = "0"),
                r"^Binary\s+Variables?\b"i =>
                    (rest) -> parse_variable(model, rest; binary = true),
                r"^Integer\s+Variables?\b"i =>
                    (rest) -> parse_variable(model, rest; integer = true),
                r"^Free\s+Variables?\b"i =>
                    (rest) -> parse_variable(model, rest),
                r"^Semicont\s+Variables?\b"i =>
                    (rest) -> parse_variable(model, rest),
                r"^Semiint\s+Variables?\b"i =>
                    (rest) -> parse_variable(model, rest),
                r"^SOS1\s+Variables?\b"i =>
                    (rest) -> parse_variable(model, rest),
                r"^SOS2\s+Variables?\b"i =>
                    (rest) -> parse_variable(model, rest),
                r"^Variables?\b"i => (rest) -> parse_variable(model, rest),
                r"^(solve\s+.*)"is =>
                    (full_stmt, _) -> parse_solve(model, full_stmt),
                r"^(\w+)\s*\.\s*(\w+)\s*="i =>
                    (name, suffix, rest) ->
                        parse_bound(model, name, suffix, rest),
                r"^(\w+)\s*(\([^)]*\))?\s*\.\."i =>
                    (name, indices, rest) ->
                        parse_constraint(model, name,
                            indices !== nothing ? strip(indices[2:end-1]) : nothing,
                            rest),
            ],
        )
    end
    return model
end

function read_model(path::AbstractString; gams_params::Dict{String,String} = Dict{String,String}())
    model = parse_model(read(path, String); gams_params)
    # Resolve GDX file path relative to the .gms file (only if relative)
    if model.gdx_file !== nothing && !isabspath(model.gdx_file)
        base_dir = dirname(path)
        # Only prepend base_dir if the file doesn't already exist at the given path
        if !isfile(model.gdx_file) && !isempty(base_dir)
            model.gdx_file = joinpath(base_dir, model.gdx_file)
        end
    end
    return model
end
