function Base.show(io::IO, variable::Variable)
    print(io, "@variable(model, ")
    if !isnothing(variable.fixed_value)
        print(io, "$(variable.name) == $(variable.fixed_value)")
    else
        if !isnothing(variable.lower_bound) && !isnothing(variable.upper_bound)
            print(io, "$(variable.lower_bound) <= ")
        end
        print(io, variable.name)
        if isnothing(variable.upper_bound)
            if !isnothing(variable.lower_bound)
                print(io, " >= $(variable.lower_bound)")
            end
        else
            print(io, " <= $(variable.upper_bound)")
        end
    end
    if variable.binary
        print(io, ", Bin")
    elseif variable.integer
        print(io, ", Int")
    end
    print(io, ")")
    return
end

function Base.show(io::IO, objective::Objective)
    if objective.sense == MOI.MAX_SENSE
        sense = "Max"
    elseif objective.sense == MOI.MIN_SENSE
        sense = "Min"
    else
        @assert objective.sense == MOI.FEASIBILITY_SENSE
        return
    end
    print(io, "@objective(model, $sense, $(objective.expression))")
    return
end

function Base.show(io::IO, constraint::Constraint)
    print(
        io,
        "@constraint(model, $(constraint.name), $(constraint.expression))",
    )
    return
end

function Base.show(io::IO, model::JuMPConverter.Model)
    println(io, "using JuMP")
    print(io, "function build_model(")
    if !isempty(model.parameters)
        print(io, "; ")
        join(io, keys(model.parameters), ", ")
    end
    println(io, ")")
    println(io, "    model = Model()")
    for variable in values(model.variables)
        println(io, "    ", variable)
    end
    for constraint in model.constraints
        println(io, "    ", constraint)
    end
    println(io, "    ", model.objective)
    println(io, "    optimize!(model)")
    println(io, "    return model")
    print(io, "end")
    return
end
