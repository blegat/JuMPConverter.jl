using JuMP
model = Model()
@variable(model, objvar)
@variable(model, 0 <= X1 <= 0)
@variable(model, -0 <= X0 <= 5.093420182218165e-15)
@variable(model, 0.9999999286317984 <= X2 <= 1.000000071368202)
@variable(model, 0.9999998572636019 <= X4 <= 1.000000142736408)
@variable(model, 0.9999998501267816 <= X3 <= 1.000000149873228)
@constraint(
    model,
    E1,
    - X1 - X0 - 2*X2 + X4 + 100*SQR(X3) - 200*X3*X4 + 100*SQR(X4) == -1
)
@constraint(model, E2, - X4 + SQR(X2) == 0)
@constraint(model, E3, - 2*X2 + SQR(X2) >= -1)
@constraint(model, E4, 2*X2 + SQR(X2) >= -1)
@constraint(model, E5, - 2*X3 + SQR(X3) >= -1)
@constraint(model, E6, 2*X3 + SQR(X3) >= -1)
@constraint(model, E7, - 2*X4 + SQR(X4) >= -1)
@constraint(model, E8, 2*X4 + SQR(X4) >= -1)
@constraint(model, E9, SQR(X3) - 2*X3*X4 + SQR(X4) >= 0)
@constraint(model, E10, SQR(X3) + 2*X3*X4 + SQR(X4) >= 0)
@constraint(model, E11, objvar == X0)
@objective(model, Min, objvar)
optimize!(model)
