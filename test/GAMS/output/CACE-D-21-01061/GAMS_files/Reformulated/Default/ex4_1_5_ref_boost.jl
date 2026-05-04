using JuMP
function build_model()
    model = Model()
    @variable(model, objvar)
    @variable(model, -91.5572487341573 <= X0 <= 214.8151646840097)
    @variable(model, 0 <= X3 <= 7.853651850336604)
    @variable(model, -2.800151997408758 <= X1 <= 2.802436770087169)
    @variable(model, -9.568555208196335 <= X2 <= 5)
    @variable(model, -21.95557517312448 <= X4 <= 22.00936272484643)
    @constraint(model, E1, - X0 + 2*X3 - X1*X2 - 1.05*X1*X4 + SQR(X2) + 0.166667*SQR(X4) == 0)
    @constraint(model, E2, - X3 + SQR(X1) == 0)
    @constraint(model, E3, - X4 + X1*X3 == 0)
    @constraint(model, E4, objvar == X0)
    @objective(model, Min, objvar)
    optimize!(model)
    return model
end
