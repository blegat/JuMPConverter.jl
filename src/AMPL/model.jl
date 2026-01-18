function parse_axe(s::AbstractString)
    sp = strip.(split(s))
    if length(sp) == 1
        return JuMPConverter.Axe(nothing, s)
    else
        @assert sp[2] == "in"
        return JuMPConverter.Axe(sp[1], sp[3])
    end
end

function parse_axes(rest::AbstractString)
    if startswith(rest, "{")
        j = findfirst(isequal('}'), rest)
        if isnothing(j)
            error("Cannot find closing } in $rest")
        end
        axes_str, rest = rest[2:(j-1)], strip(rest[(j+1):end])
        axes_str, cond = JuMPConverter.next_token(axes_str, ':')
        axes = parse_axe.(strip.(split(axes_str, ',')))
        return JuMPConverter.Axes(axes, isempty(cond) ? nothing : cond), rest
    else
        return nothing, rest
    end
end

function parse_parameter(rest::AbstractString)
    name, rest = strip.(split(rest, limit = 2))
    axes, rest = parse_axes(rest)
    default = nothing
    integer = false
    while !isempty(rest)
        JuMPConverter._get_command(
            rest,
            [
                "default" =>
                    (_, s) -> begin
                        def, rest = JuMPConverter.next_token(s)
                        default = parse(Float64, def)
                    end,
                "integer" => (_, s) -> begin
                    integer = true
                    rest = s
                end,
            ],
        )
    end
    return JuMPConverter.Parameter(; name, axes, integer, default)
end

function parse_variable(rest::AbstractString)
    name, rest = strip.(split(rest, limit = 2))
    axes, rest = parse_axes(rest)
    lower_bound = nothing
    upper_bound = nothing
    rest = strip(replace(rest, "," => ""))
    while !isempty(rest)
        JuMPConverter._get_command(
            rest,
            [
                ">=" =>
                    (_, s) -> (lower_bound, rest) = JuMPConverter.next_token(s),
                "<=" =>
                    (_, s) -> (upper_bound, rest) = JuMPConverter.next_token(s),
            ],
        )
    end
    return JuMPConverter.Variable(; name, axes, lower_bound, upper_bound)
end

function parse_objective(sense::MOI.OptimizationSense, s::AbstractString)
    sp = strip.(split(s, ':'))
    if length(sp) == 1
        name = nothing
        expression = s
    else
        name, expression = sp
    end
    return JuMPConverter.Objective(; name, sense, expression)
end

function parse_constraint(s::AbstractString)
    header, expression = strip.(rsplit(s, ':', limit = 2))
    name, axe = strip.(split(header, limit = 2))
    axes, rest = parse_axes(axe)
    @assert isempty(rest)
    return JuMPConverter.Constraint(; name, axes, expression)
end

function parse_model(mod::AbstractString)
    model = JuMPConverter.Model()
    # Remove comments
    mod = replace(mod, r"#.*" => "")
    commands = filter(!isempty, strip.(split(mod, ';')))
    first_constraint = nothing
    for (i, command) in enumerate(commands)
        JuMPConverter._get_command(
            command,
            [
                "param" => (_, rest) -> push!(model, parse_parameter(rest)),
                "var" => (_, rest) -> push!(model, parse_variable(rest)),
                "maximize" =>
                    (_, rest) ->
                        model.objective = parse_objective(MOI.MAX_SENSE, rest),
                "subject to" =>
                    (_, rest) -> begin
                        push!(model, parse_constraint(rest))
                        first_constraint = i + 1
                    end,
            ],
        )
        if !isnothing(first_constraint)
            break
        end
    end
    for command in commands[first_constraint:end]
        push!(model.constraints, parse_constraint(command))
    end
    return model
end

function read_model(path::AbstractString)
    return parse_model(read(path, String))
end
