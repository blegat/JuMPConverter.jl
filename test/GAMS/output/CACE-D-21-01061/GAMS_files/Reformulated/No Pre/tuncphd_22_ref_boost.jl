using JuMP
model = Model()
@variable(model, objvar)
@variable(model, -32217.43103710001 <= X0 <= -20580.07917)
@variable(model, 78 <= X7 <= 125)
@variable(model, 27 <= X11 <= 45)
@variable(model, 27 <= X9 <= 45)
@variable(model, 87.25349949999999 <= X1 <= 97.06166660000002)
@variable(model, 27 <= X10 <= 45)
@variable(model, 33 <= X8 <= 45)
@variable(model, -4.746500500000002 <= X2 <= 0)
@variable(model, 6.167419399999997 <= X3 <= 26.22100250000001)
@variable(model, -13.83258060000001 <= X4 <= 0)
@variable(model, 0 <= X5 <= 9.746126000000004)
@variable(model, -8.237148900000003 <= X6 <= 0)
@constraint(
    model,
    E1,
    - X0 + 37.2932*X7 + 0.835689*X7*X11 + 5.35785*SQR(X9) == 40792.1
)
@constraint(
    model,
    E2,
    - X1 + 0.0006262*X7*X10 + 0.0056858*X8*X11 - 0.0022053*X9*X11 == -85.3344
)
@constraint(
    model,
    E3,
    - X2 + 0.0006262*X7*X10 + 0.0056858*X8*X11 - 0.0022053*X9*X11 == 6.66559
)
@constraint(
    model,
    E4,
    - X3 + 0.0029955*X7*X8 + 0.0071317*X8*X11 + 0.0021813*SQR(X9) == 9.48751
)
@constraint(
    model,
    E5,
    - X4 + 0.0029955*X7*X8 + 0.0071317*X8*X11 + 0.0021813*SQR(X9) == 29.4875
)
@constraint(
    model,
    E6,
    - X5 + 0.0012547*X7*X9 + 0.0019085*X9*X10 + 0.0047026*X9*X11 == 10.699
)
@constraint(
    model,
    E7,
    - X6 + 0.0012547*X7*X9 + 0.0019085*X9*X10 + 0.0047026*X9*X11 == 15.699
)
@constraint(model, E8, objvar == X0)
@objective(model, Min, objvar)
optimize!(model)
