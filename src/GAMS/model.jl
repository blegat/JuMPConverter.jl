function _preprocess(mod::AbstractString)
    lines = split(mod, '\n')
    filtered = String[]
    for line in lines
        stripped = rstrip(line)
        # Skip * comments (must be in column 1)
        if startswith(stripped, '*')
            continue
        end
        # Skip $ directives (must be in column 1)
        if startswith(stripped, '$')
            continue
        end
        push!(filtered, stripped)
    end
    return join(filtered, '\n')
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

function parse_variable(
    model::JuMPConverter.Model,
    s::AbstractString;
    lower_bound::Union{Nothing,String} = nothing,
    upper_bound::Union{Nothing,String} = nothing,
    binary::Bool = false,
    integer::Bool = false,
)
    for name in strip.(split(s, ','))
        isempty(name) && continue
        push!(
            model,
            JuMPConverter.Variable(;
                name,
                lower_bound,
                upper_bound,
                binary,
                integer,
            ),
        )
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
    expression::AbstractString,
)
    expression = clean_expression(expression)
    push!(
        model,
        JuMPConverter.Constraint(;
            name = strip(name),
            expression = strip(expression),
        ),
    )
    return
end

function parse_model(mod::AbstractString)
    mod = _preprocess(mod)
    model = JuMPConverter.Model()
    commands = filter(!isempty, strip.(split(mod, ';')))
    for command in commands
        command = strip(command)
        isempty(command) && continue
        JuMPConverter._get_command(
            command,
            [
                r"^Model\b"i => (_) -> nothing,
                r"^Equations?\b"i => (_) -> nothing,
                r"^Display\b"i => (_) -> nothing,
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
                r"^Variables?\b"i => (rest) -> parse_variable(model, rest),
                r"^(solve\s+.*)"is =>
                    (full_stmt, _) -> parse_solve(model, full_stmt),
                r"^(\w+)\s*\.\s*(\w+)\s*="i =>
                    (name, suffix, rest) ->
                        parse_bound(model, name, suffix, rest),
                r"^(\w+)\s*\.\."i =>
                    (name, rest) -> parse_constraint(model, name, rest),
            ],
        )
    end
    return model
end

function read_model(path::AbstractString)
    return parse_model(read(path, String))
end
