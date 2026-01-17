Base.@kwdef struct Axe
    name::String
    set::String
end

Base.@kwdef struct Axes
    axes::Vector{Axe}
    condition::Union{Nothing,String} = nothing
end

Base.@kwdef struct Parameter
    name::String
    axes::Union{Nothing,Axes} = nothing
    integer::Bool
    default::Union{Nothing,Float64} = nothing
end

Base.@kwdef struct Variable
    name::String
    axes::Union{Nothing,Axes} = nothing
    lower_bound::Union{Nothing,String} = nothing
    upper_bound::Union{Nothing,String} = nothing
end

Base.@kwdef struct Objective
    name::Union{Nothing,String} = nothing
    sense::MOI.OptimizationSense
    expression::String
end

Base.@kwdef struct Constraint
    name::String
    axes::Union{Nothing,Axes} = nothing
    expression::String
end

mutable struct Model
    params::OrderedCollections.OrderedDict{String,Parameter}
    variables::OrderedCollections.OrderedDict{String,Variable}
    objective::Union{Nothing,Objective}
    constraints::Vector{Constraint}
    function Model()
        return new(
            OrderedCollections.OrderedDict{String,Parameter}(),
            OrderedCollections.OrderedDict{String,Variable}(),
            nothing,
            Constraint[],
        )
    end
end

function Base.push!(model::Model, parameter::Parameter)
    model.parameters[parameter.name] = parameter
    return model
end

function Base.push!(model::Model, variable::Variable)
    model.variables[variable.name] = variable
    return model
end

function Base.push!(model::Model, constraint::Constraint)
    push!(model.constraints, constraint)
    return model
end
