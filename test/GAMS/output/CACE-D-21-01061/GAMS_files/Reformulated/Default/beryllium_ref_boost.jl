using JuMP
model = Model()
@variable(model, objvar)
@variable(model, -93.22085828301277 <= X0 <= 54.71515455065227)
@variable(model, 0 <= X8 <= 1.168644571637226)
@variable(model, -1.081038654090235 <= X9 <= 1.16864456565199)
@variable(model, 0 <= X11 <= 1.168644571637226)
@variable(model, -1.081038654090235 <= X13 <= 1.16864456565199)
@variable(model, 0 <= X14 <= 1.168644559666754)
@variable(model, 0 <= X16 <= 1.168644559666754)
@variable(model, -1.081038654090235 <= X10 <= 1.16864456565199)
@variable(model, -1.081038654090235 <= X12 <= 1.16864456565199)
@variable(model, -1.081038648553674 <= X15 <= 1.168644559666754)
@variable(model, 0 <= X1 <= 0)
@variable(model, 0 <= X2 <= 0)
@variable(model, 0 <= X3 <= 0)
@variable(model, -1 <= X4 <= 1.081038654090235)
@variable(model, -1 <= X5 <= 1.081038654090235)
@variable(model, -1 <= X7 <= 1.081038648553674)
@variable(model, -1 <= X6 <= 1.081038648553674)
@constraint(
    model,
    E1,
    - X0 - 15.7343*X8 - 7.72905*X9 - 15.7343*X11 - 7.72905*X13 - 4.20432*X14 -
    4.20432*X16 +
    2.29883*SQR(X8) +
    1.56815*X8*X9 +
    4.59766*X8*X11 +
    1.56815*X8*X13 +
    1.46013*SQR(X9) +
    1.56815*X9*X11 - 1.32949*X9*X13 +
    0.572165*X9*X14 +
    0.572165*X9*X16 +
    2.12488*SQR(X10) +
    2.29883*SQR(X11) +
    1.56815*X11*X13 +
    2.12488*SQR(X12) +
    1.46013*SQR(X13) +
    0.572165*X13*X14 +
    0.572165*X13*X16 +
    0.417683*SQR(X14) +
    0.835366*SQR(X15) +
    0.417683*SQR(X16) == 0
)
@constraint(model, E2, - X1 + X8 + 0.519034*X9 + X14 == 1)
@constraint(model, E3, - X2 + X11 + 0.519034*X13 + X16 == 1)
@constraint(model, E4, - X3 + 0.259517*X10 + 0.259517*X12 + X15 + X4*X5 == 0)
@constraint(model, E5, - X16 + SQR(X7) == 0)
@constraint(model, E6, - X15 + X6*X7 == 0)
@constraint(model, E7, - X14 + SQR(X6) == 0)
@constraint(model, E8, - X13 + X5*X7 == 0)
@constraint(model, E9, - X12 + X5*X6 == 0)
@constraint(model, E10, - X11 + SQR(X5) == 0)
@constraint(model, E11, - X9 + X4*X6 == 0)
@constraint(model, E12, - X10 + X4*X7 == 0)
@constraint(model, E13, - X8 + SQR(X4) == 0)
@constraint(model, E14, objvar == X0)
@objective(model, Min, objvar)
optimize!(model)
