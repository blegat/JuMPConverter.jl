using JuMP
function build_model(; _kwargs...)
    model = Model()
    @variable(model, 0 <= x1 <= 36)
    @variable(model, 0 <= x2 <= 5)
    @variable(model, 0 <= x3 <= 125)
    @variable(model, obj)
    @constraint(model, ob, -0.0201*1e-7*(x1)^(4)*x2*(x3)^(2) == obj)
    @constraint(model, c1, x1*x1*x2 -675 <= 0)
    @constraint(model, c2, x1*x1*x3*x3 <= 0.419*1e7)
    @objective(model, Min, obj)
    optimize!(model)
    return model
end
