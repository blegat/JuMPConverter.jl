using JuMP
function build_model(; _kwargs...)
    model = Model()
    @variable(model, 1 <= x1 <= 5)
    @variable(model, 1 <= x2 <= 5)
    @variable(model, 1 <= x3 <= 5)
    @variable(model, 1 <= x4 <= 5)
    @variable(model, obj)
    @constraint(model, ob, x1*x4*(x1+x2+x3)+x3 == obj)
    @constraint(model, c1, x1*x2*x3*x4-25 >= 0)
    @constraint(model, c2, x1*x1 + x2*x2 + x3*x3 + x4*x4 - 40 == 0)
    @objective(model, Min, obj)
    optimize!(model)
    return model
end
