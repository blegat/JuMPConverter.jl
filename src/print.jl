function Base.show(io::IO, variable::Variable)
    print(io, "@variable(model, ")
    name = variable.name * _format_axes(variable.axes)
    lb =
        isnothing(variable.lower_bound) ? nothing :
        _ampl_range_to_julia(variable.lower_bound)
    ub =
        isnothing(variable.upper_bound) ? nothing :
        _ampl_range_to_julia(variable.upper_bound)
    if !isnothing(variable.fixed_value)
        print(io, "$name == $(_ampl_range_to_julia(variable.fixed_value))")
    else
        if !isnothing(lb) && !isnothing(ub)
            print(io, "$lb <= ")
        end
        print(io, name)
        if isnothing(ub)
            if !isnothing(lb)
                print(io, " >= $lb")
            end
        else
            print(io, " <= $ub")
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

# AMPL `{t in T, k in K}` / `{T, K}` / `{t in T : cond}` becomes JuMP's
# bracketed indexing `[t in T, k in K]` / `[T, K]` / `[t in T; cond]`.
# Returns "" when there are no axes.
_format_axes(::Nothing) = ""

function _format_axes(axes::Axes)
    parts = String[]
    for axe in axes.axes
        set = _ampl_range_to_julia(axe.set)
        if axe.name == axe.set
            push!(parts, set)
        else
            push!(parts, "$(axe.name) in $set")
        end
    end
    body = join(parts, ", ")
    if !isnothing(axes.condition)
        body *= "; " * _ampl_range_to_julia(axes.condition)
    end
    return "[$body]"
end

# AMPL ranges use `..`; Julia's `UnitRange` uses `:` and has lower
# precedence than `+`, so `1..3+H` becomes `1:3+H` (= `1:(3+H)`).
_ampl_range_to_julia(s::AbstractString) = replace(s, ".." => ":")

# Build the keyword-argument fragment for a parameter. For an indexed
# parameter with a default (e.g. `param ALPHA{K} default 1.`) the default
# must be a container indexable by the parameter's axes, otherwise
# `ALPHA[k]` fails because the default is a scalar.
function _format_param_kwarg(p::Parameter)
    isnothing(p.default) && return p.name
    if isnothing(p.axes)
        return "$(p.name) = $(p.default)"
    end
    axes_strs = [_ampl_range_to_julia(a.set) for a in p.axes.axes]
    lengths = join(["length($a)" for a in axes_strs], ", ")
    fill_call = "fill($(p.default), $lengths)"
    return "$(p.name) = JuMP.Containers.DenseAxisArray($fill_call, $(join(axes_strs, ", ")))"
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
    name = constraint.name * _format_axes(constraint.axes)
    print(io, "@constraint(model, $name, $(constraint.expression))")
    return
end

function Base.show(io::IO, model::JuMPConverter.Model)
    println(io, "using JuMP")
    print(io, "function build_model(")
    kwargs = String[]
    for s in values(model.sets)
        push!(
            kwargs,
            isnothing(s.default) ? s.name : "$(s.name) = $(s.default)",
        )
    end
    for p in values(model.parameters)
        push!(kwargs, _format_param_kwarg(p))
    end
    if !isempty(kwargs)
        print(io, "; ")
        join(io, kwargs, ", ")
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
    println(io, "    return model")
    print(io, "end")
    if !isempty(model.parameters) || !isempty(model.sets)
        println(io)
        println(io)
        _print_data_loader(io, model)
    end
    return
end

# Emit a single `build_model(path::String)` that hard-codes the
# `DatSchema` derived from this model and dispatches between
# `read_dat` (for a `.dat` file) and `read_csv` (for a directory of
# CSVs) based on `isdir(path)`. Lets the generated `.jl` load data
# at runtime without re-parsing the `.mod`.
function _print_data_loader(io::IO, model::JuMPConverter.Model)
    println(io, "function build_model(path::String)")
    println(io, "    schema = JuMPConverter.AMPL.DatSchema(")
    println(io, "        Dict{Symbol,Int}(")
    for (name, p) in model.parameters
        nd = isnothing(p.axes) ? 0 : length(p.axes.axes)
        println(io, "            :$name => $nd,")
    end
    print(io, "        )")
    if !isempty(model.sets)
        println(io, ",")
        print(io, "        [")
        join(io, (":$n" for n in keys(model.sets)), ", ")
        println(io, "],")
    else
        println(io)
    end
    println(io, "    )")
    println(io, "    data = if isdir(path)")
    println(io, "        JuMPConverter.AMPL.read_csv(path, schema)")
    println(io, "    else")
    println(io, "        JuMPConverter.AMPL.read_dat(path, schema)")
    println(io, "    end")
    println(io, "    return build_model(; data...)")
    print(io, "end")
    return
end
