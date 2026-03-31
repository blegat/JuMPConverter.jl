using JuMP
model = Model()
@variable(model, objvar)
@variable(model, 0 <= X1 <= 2.22452713218)
@variable(model, 1.561636519800009 <= X22 <= 4)
@variable(model, 145 <= X23 <= 153.5353535353536)
@variable(model, 0 <= X2 <= 8.450000000000017)
@variable(model, 92.18333333333331 <= X20 <= 95)
@variable(model, 0 <= X3 <= 2.709292484848493)
@variable(model, 0 <= X4 <= 11.53621414141426)
@variable(model, 0 <= X9 <= 0)
@variable(model, 3.969999097825247e-05 <= X14 <= 2000)
@variable(model, 4.073769752315776e-05 <= X17 <= 3278.688524590164)
@variable(model, 1e-05 <= X18 <= 2000)
@variable(model, -19622.94971818317 <= X0 <= 18559.99976341379)
@variable(model, 1e-05 <= X15 <= 16000)
@variable(model, 8.674510204083993e-05 <= X16 <= 120)
@variable(model, 0 <= X5 <= 3311.806517046729)
@variable(model, 3.784958721110538 <= X21 <= 12)
@variable(model, 14.32591252051071 <= X43 <= 144)
@variable(model, 0 <= X6 <= 9.020115324220631)
@variable(model, 85 <= X19 <= 93)
@variable(model, 0 <= X7 <= 3311.806517046729)
@variable(model, 0 <= X8 <= 12.22571032422063)
@variable(model, 0 <= X10 <= 0)
@variable(model, 7.51231527093596e-06 <= X24 <= 9.99880014398)
@variable(model, 0 <= X11 <= 0)
@variable(model, 0.0005 <= X25 <= 25188.92260070782)
@variable(model, -0 <= X12 <= 0)
@variable(model, 6.36174761847295e-05 <= X42 <= 13114.75409836066)
@variable(model, -0 <= X13 <= 0)
@constraint(model, E1, - X1 - 0.9*X22 - 0.222*X23 == -35.82)
@constraint(model, E2, - X2 + 3*X20 - 0.99*X23 == 133)
@constraint(model, E3, - X3 + 1.11111*X22 + 0.222*X23 == 35.82)
@constraint(model, E4, - X4 - 3*X20 + 1.0101*X23 == -133)
@constraint(model, E5, - X9 - X14 + 1.22*X17 - X18 == -0)
@constraint(
    model,
    E6,
    - X0 + 5.04*X14 + 0.035*X15 + 10*X16 + 3.36*X18 - 0.063*X17*X20 == 0
)
@constraint(
    model,
    E7,
    - X5 + 1.12*X14 - 0.99*X17 + 0.13167*X14*X21 - 0.00667*X14*X43 == 0
)
@constraint(
    model,
    E8,
    - X6 + 0.325*X19 - 0.99*X20 + 1.098*X21 - 0.038*X43 == -57.425
)
@constraint(
    model,
    E9,
    - X7 - 1.12*X14 + 1.0101*X17 - 0.13167*X14*X21 + 0.00667*X14*X43 == 0
)
@constraint(
    model,
    E10,
    - X8 - 0.325*X19 + 1.0101*X20 - 1.098*X21 + 0.038*X43 == 57.425
)
@constraint(model, E11, - X10 - X19 + 98000*X16*X24 == 0)
@constraint(model, E12, - X11 - X21 + X15*X25 + X18*X25 == 0)
@constraint(model, E13, - X12 + 1000*X16*X24 + X24*X42 == 1)
@constraint(model, E14, - X13 + X14*X25 == 1)
@constraint(model, E15, - X43 + SQR(X21) == 0)
@constraint(model, E16, - X42 + X17*X22 == 0)
@constraint(model, E17, - 2*X21 + SQR(X21) >= -1)
@constraint(model, E18, 2*X21 + SQR(X21) >= -1)
@constraint(model, E19, objvar == X0)
@objective(model, Min, objvar)
optimize!(model)
