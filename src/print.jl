function Base.show(io::IO, variable::Variable)
    print(io, "@variable(model, ")
    if !isnothing(variable.lower_bound) && !isnothing(variable.upper_bound)
        print(io, "$(variable.lower_bound) <= ")
    end
    print(io, variable.name)
    if !isnothing(variable.lower_bound) && !isnothing(variable.upper_bound)
        print(io, "$(variable.lower_bound) <= ")
    end
    if isnothing(variable.upper_bound)
        if !isnothing(variable.lower_bound)
            print(io, " >= $(variable.lower_bound)")
        end
    else
        print(io, " <= $(variable.upper_bound)")
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
    println(io, "model = Model()")
    for variable in values(model.variables)
        println(io, variable)
    end
    for constraint in model.constraints
        println(io, constraint)
    end
    println(io, model.objective)
    print(io, "optimize!(model)")
    return
end
