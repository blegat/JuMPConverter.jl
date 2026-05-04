using JuMP
function build_model(; _kwargs...)
    model = Model()
    @variable(model, objvar)
    @variable(model, -7 <= X0 <= -0)
    @variable(model, 0 <= X3 <= 3)
    @variable(model, 0 <= X4 <= 4)
    @variable(model, -236 <= X1 <= 0)
    @variable(model, 0 <= X7 <= 9)
    @variable(model, -1152 <= X2 <= 0)
    @constraint(model, E1, - X0 - X3 - X4 == -0)
    @constraint(model, E2, - X1 + X4 - 8*X7 + 8*X3*X7 - 2*SQR(X7) == 2)
    @constraint(model, E3, - X2 + 96*X3 + X4 - 88*X7 + 32*X3*X7 - 4*SQR(X7) == 36)
    @constraint(model, E4, - X7 + SQR(X3) == 0)
    @constraint(model, E5, objvar == X0)
    @objective(model, Min, objvar)
    optimize!(model)
    return model
end
