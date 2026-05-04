using JuMP
function build_model(; _kwargs...)
    model = Model()
    @variable(model, 0 <= x1 <= 1)
    @variable(model, 0 <= x2 <= 1)
    @variable(model, 0 <= x3 <= 1)
    @variable(model, 0 <= x4 <= 1)
    @variable(model, 0 <= x5 <= 1)
    @variable(model, 0 <= x6 <= 1)
    @variable(model, 0 <= x7 <= 1)
    @variable(model, 0 <= x8 <= 1)
    @variable(model, obj)
    @constraint(model, ob, ((x1*x1*x1 + x2*x2*x2 + x3*x3*x3 + x4*x4*x4 + x5*x5*x5 + x6*x6*x6 + x7*x7*x7 + x8*x8*x8))^(2) - ((x1*x1*x1*x1 + x2*x2*x2*x2 + x3*x3*x3*x3 + x4*x4*x4*x4 + x5*x5*x5*x5 + x6*x6*x6*x6 + x7*x7*x7*x7 + x8*x8*x8*x8)*(x1*x1 + x2*x2 + x3*x3 + x4*x4 + x5*x5 + x6*x6 + x7*x7 + x8*x8)) == obj)
    @objective(model, Min, obj)
    optimize!(model)
    return model
end
