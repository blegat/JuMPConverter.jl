function Base.show(io::IO, set::Set)
    if set.parent !== nothing
        print(io, "# $(set.name) is a subset of $(set.parent)")
    else
        print(io, "# Set: $(set.name)")
    end
    return
end

function Base.show(io::IO, variable::Variable)
    print(io, "@variable(model, ")
    name_str = variable.name
    if variable.axes !== nothing
        indices =
            join(["$(a.name) in $(a.set)" for a in variable.axes.axes], ", ")
        name_str = "$(variable.name)[$indices]"
    end
    if !isnothing(variable.fixed_value)
        print(io, "$name_str == $(variable.fixed_value)")
    else
        if !isnothing(variable.lower_bound) && !isnothing(variable.upper_bound)
            print(io, "$(variable.lower_bound) <= ")
        end
        print(io, name_str)
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
    if constraint.axes !== nothing
        indices =
            join(["$(a.name) in $(a.set)" for a in constraint.axes.axes], ", ")
        print(
            io,
            "@constraint(model, $(constraint.name)[$indices], $(constraint.expression))",
        )
    else
        print(
            io,
            "@constraint(model, $(constraint.name), $(constraint.expression))",
        )
    end
    return
end

function Base.show(io::IO, model::JuMPConverter.Model)
    println(io, "using JuMP")
    if model.gdx_file !== nothing
        println(io, "using GDXInterface")
        println(io)
        println(io, "gdx = GDXInterface.read_gdx(\"$(model.gdx_file)\")")
        println(io)
        # Extract sets as vectors
        for (name, set) in model.sets
            println(io, "$name = gdx[:$name][!, 1]")
        end
        # Extract parameters as DataFrames
        for (name, param) in model.parameters
            println(io, "$name = gdx[:$name]")
        end
        println(io)
    end
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
