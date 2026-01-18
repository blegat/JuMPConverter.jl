function parse_variable(
    model::JuMPConverter.Model,
    s::AbstractString;
    lower_bound::Union{Nothing,String} = nothing,
    upper_bound::Union{Nothing,String} = nothing,
)
    for name in strip.(split(s, ','))
        push!(model, JuMPConverter.Variable(; name, lower_bound, upper_bound))
    end
end

function parse_solve(model::JuMPConverter.Model, s::AbstractString)
    args = strip.(split(s))
    sign = args[4]
    if sign == "maximizing"
        sense = MOI.MAX_SENSE
    else
        error("Unsupported sign $sign")
    end
    expression = args[5]
    model.objective = JuMPConverter.Objective(; sense, expression)
    return
end

function parse_constraint(
    model::JuMPConverter.Model,
    name::AbstractString,
    expression::AbstractString,
)
    expression = replace(expression, "=e=" => "==")
    expression = replace(expression, "=l=" => "<=")
    push!(model, JuMPConverter.Constraint(; name, expression))
    return
end

function parse_model(mod::AbstractString)
    model = JuMPConverter.Model()
    commands = filter(!isempty, strip.(split(mod, ';')))
    for command in commands
        JuMPConverter._get_command(
            command,
            [
                "Model" => (_, _) -> nothing,
                "Equations" => (_, _) -> nothing,
                r"^Positive\s+Variables" =>
                    rest -> parse_variable(model, rest, lower_bound = "0"),
                "Variables" => (_, rest) -> parse_variable(model, rest),
                "solve" => (_, rest) -> parse_solve(model, rest),
                r"^(\w+).." =>
                    (command, rest) -> parse_constraint(model, command, rest),
            ],
        )
    end
    return model
end

function read_model(path::AbstractString)
    return parse_model(read(path, String))
end
