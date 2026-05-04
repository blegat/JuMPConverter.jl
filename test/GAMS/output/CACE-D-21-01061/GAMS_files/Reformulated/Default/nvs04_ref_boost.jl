using JuMP
function build_model()
    model = Model()
    @variable(model, objvar)
    @variable(model, 0 <= X0 <= 458.3200000000002)
    @variable(model, 0 <= X3 <= 1)
    @variable(model, Y1, Bin)
    @variable(model, Y2 <= 2, Int)
    @constraint(model, E1, - X0 - 34.4*Y1 + 28*Y2 + 117*X3 - 240*Y1*Y2 + 240*Y1*X3 + 100*SQR(Y2) - 200*Y2*X3 + 100*SQR(X3) == -2.12)
    @constraint(model, E2, - X3 + SQR(Y1) == 0)
    @constraint(model, E3, objvar == X0)
    @objective(model, Min, objvar)
    optimize!(model)
    return model
end
