using JuMP
function build_model()
    model = Model()
    @variable(model, objvar)
    @variable(model, -18.00000007612766 <= X2 <= -17.99999992387234)
    @variable(model, 0.9999999930793042 <= X3 <= 1.000000006920696)
    @variable(model, 0.9999999861586084 <= X4 <= 1.000000013841392)
    @variable(model, 0 <= X0 <= 7.711260997396986e-15)
    @variable(model, 0.9999999861586084 <= X8 <= 1.000000013841392)
    @variable(model, 0 <= X1 <= 0)
    @constraint(model, E1, - X2 + 3*X3 + 4*X4 == 25)
    @constraint(model, E2, - X0 - 2*X3 + X8 + 10*SQR(X4) - 20*X4*X8 + 10*SQR(X8) == -1)
    @constraint(model, E3, - X1 + X3 - X3*X4 == 0)
    @constraint(model, E4, - X8 + SQR(X3) == 0)
    @constraint(model, E5, objvar == X0)
    @objective(model, Min, objvar)
    return model
end
