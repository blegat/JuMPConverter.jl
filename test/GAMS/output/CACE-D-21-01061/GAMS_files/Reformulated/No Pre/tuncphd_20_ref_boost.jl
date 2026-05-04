using JuMP
function build_model(; _kwargs...)
    model = Model()
    @variable(model, objvar)
    @variable(model, -18 <= X1 <= 0)
    @variable(model, -8 <= X3 <= 10)
    @variable(model, 0 <= X4 <= 10)
    @variable(model, -1692 <= X0 <= 10240)
    @variable(model, 0 <= X7 <= 100)
    @variable(model, -118 <= X2 <= 0)
    @constraint(model, E1, - X1 - X3 + X4 == 8)
    @constraint(model, E2, - X0 + 24*X3 - 14*X7 - SQR(X4) + SQR(X7) == 0)
    @constraint(model, E3, - X2 - 2*X3 + X4 - X7 == -2)
    @constraint(model, E4, - X7 + SQR(X3) == 0)
    @constraint(model, E5, objvar == X0)
    @objective(model, Min, objvar)
    optimize!(model)
    return model
end
