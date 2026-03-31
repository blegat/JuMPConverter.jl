using JuMP
model = Model()
@variable(model, objvar)
@variable(model, 0 <= X1 <= 0)
@variable(model, 1 <= X8 <= 2000)
@variable(model, 1 <= X11 <= 3278.688524590164)
@variable(model, 0 <= X12 <= 2000)
@variable(model, 0 <= X2 <= 0)
@variable(model, 2.075999999999993 <= X16 <= 3.630000000000003)
@variable(model, 145 <= X17 <= 152)
@variable(model, 0 <= X3 <= 0)
@variable(model, 92.66666666666666 <= X14 <= 95)
@variable(model, -19617.7406820047 <= X0 <= 18554.162)
@variable(model, 1 <= X9 <= 16000)
@variable(model, 0.01352173646167191 <= X10 <= 120)
@variable(model, 0 <= X4 <= 0)
@variable(model, 85 <= X13 <= 93)
@variable(model, 5.689006106442661 <= X15 <= 12)
@variable(model, 0 <= X5 <= 0)
@variable(model, 85 <= X25 <= 304918.0327868853)
@variable(model, 0 <= X6 <= 0)
@variable(model, 0 <= X7 <= 5398.864126847506)
@variable(model, 32.36479047914188 <= X26 <= 144)
@constraint(model, E1, - X1 + X8 - 1.22*X11 + X12 == -0)
@constraint(model, E2, - X2 + X16 + 0.222*X17 == 35.82)
@constraint(model, E3, - X3 + 3*X14 - X17 == 133)
@constraint(
    model,
    E4,
    - X0 + 5.04*X8 + 0.035*X9 + 10*X10 + 3.36*X12 - 0.063*X11*X14 == 0
)
@constraint(
    model,
    E5,
    - X4 - 0.325*X13 + X14 - 1.098*X15 + 0.038*SQR(X15) == 57.425
)
@constraint(model, E6, - X5 - 98000*X10 + 1000*X10*X13 + X16*X25 == 0)
@constraint(model, E7, - X6 + X9 + X12 - X8*X15 == 0)
@constraint(
    model,
    E8,
    - X7 + 1.12*X8 - X11 + 0.13167*X8*X15 - 0.00667*X8*X26 == 0
)
@constraint(model, E9, - X25 + X11*X13 == 0)
@constraint(model, E10, - X26 + SQR(X15) == 0)
@constraint(model, E11, - 2*X15 + SQR(X15) >= -1)
@constraint(model, E12, 2*X15 + SQR(X15) >= -1)
@constraint(model, E13, objvar == X0)
@objective(model, Min, objvar)
optimize!(model)
