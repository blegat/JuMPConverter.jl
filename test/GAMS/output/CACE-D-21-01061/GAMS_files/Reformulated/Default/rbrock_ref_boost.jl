using JuMP
function build_model()
    model = Model()
    @variable(model, objvar)
    @variable(model, 0 <= X0 <= 9.524814060426158e-14)
    @variable(model, 0.9999999924748484 <= X1 <= 1.000000007525152)
    @variable(model, 0.9999999849496968 <= X3 <= 1.000000015050303)
    @variable(model, 0.9999999841971816 <= X2 <= 1.000000015802819)
    @constraint(model, E1, - X0 - 2*X1 + X3 + 100*SQR(X2) - 200*X2*X3 + 100*SQR(X3) == -1)
    @constraint(model, E2, - X3 + SQR(X1) == 0)
    @constraint(model, E3, objvar == X0)
    @objective(model, Min, objvar)
    optimize!(model)
    return model
end
