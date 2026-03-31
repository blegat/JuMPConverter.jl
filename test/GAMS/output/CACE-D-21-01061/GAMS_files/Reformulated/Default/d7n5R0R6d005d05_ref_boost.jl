using JuMP
model = Model()
@variable(model, objvar)
@variable(model, 0 <= X5 <= 21.34233917499943)
@variable(model, 0.08 <= X6 <= 2.71)
@variable(model, 0.87 <= X7 <= 2.830066911057418)
@variable(model, 0.42 <= X8 <= 2.2)
@variable(model, 0.06 <= X9 <= 2.15)
@variable(model, 0.8636805266027429 <= X10 <= 2.78)
@variable(model, -4566.67423813292 <= X0 <= 61627.72607557032)
@variable(model, 0.002016 <= X35 <= 12.8183)
@variable(model, 0.006399999999999999 <= X20 <= 7.3441)
@variable(model, 0.0002159999999999999 <= X42 <= 9.938375000000002)
@variable(model, 8.294399999999995e-08 <= X58 <= 156.9251026506251)
@variable(model, 4.665599999999997e-08 <= X60 <= 98.77129764062504)
@variable(model, 9.667434914344968e-06 <= X61 <= 165.1366353025001)
@variable(model, 0.003666544703999998 <= X56 <= 471.1133339734581)
@variable(model, 0.002062431395999999 <= X59 <= 296.5266521823382)
@variable(model, 0.1764 <= X28 <= 4.840000000000002)
@variable(model, 0.5564325287630993 <= X55 <= 59.72816656)
@variable(model, 4.064255999999997e-06 <= X57 <= 164.3088148900001)
@variable(model, 0.4150675351883989 <= X62 <= 461.603162442304)
@variable(model, 0.0048 <= X23 <= 5.8265)
@variable(model, 0.021924 <= X38 <= 13.38621648930159)
@variable(model, 0.0696 <= X21 <= 7.669481328965604)
@variable(model, 0.04541399999999999 <= X37 <= 17.21994925028347)
@variable(model, 0.002724839999999999 <= X51 <= 37.02289088810946)
@variable(model, 1.295999999999999e-05 <= X54 <= 21.36750625000001)
@variable(model, 0.0336 <= X22 <= 5.962000000000001)
@variable(model, 0.3155888644206422 <= X39 <= 17.30868922802717)
@variable(model, 0.7459440520327911 <= X31 <= 7.7284)
@variable(model, 0.3653999999999999 <= X25 <= 6.226147204326321)
@variable(model, 0.1335171599999999 <= X50 <= 38.76490900994047)
@variable(model, 0.5646050529836195 <= X52 <= 61.89890966785616)
@variable(model, 0.7514020581443862 <= X27 <= 7.867586012739623)
@variable(model, 0.02176474927038911 <= X41 <= 13.1494)
@variable(model, 0.03111695999999999 <= X53 <= 23.42560000000002)
@variable(model, 0.004774041933009863 <= X49 <= 56.75814244)
@variable(model, 0.0252 <= X29 <= 4.73)
@variable(model, 0.003109249895769874 <= X43 <= 12.85055)
@variable(model, 0.02923199999999999 <= X33 <= 16.87285892372433)
@variable(model, 2.303999999999999e-05 <= X48 <= 33.94810225000001)
@variable(model, 0.06011216465155089 <= X34 <= 21.32115809452438)
@variable(model, 0.04508412348866317 <= X40 <= 16.91530992739019)
@variable(model, 4.095999999999999e-05 <= X45 <= 53.93580481000001)
@variable(model, 0.004844159999999998 <= X46 <= 58.82094385535201)
@variable(model, 0.00112896 <= X47 <= 35.54544400000002)
@variable(model, 0 <= X1 <= 33.22117000000001)
@variable(model, -0 <= X2 <= 139.2834856417999)
@variable(model, -0 <= X3 <= 507.5754753583495)
@variable(model, -0 <= X4 <= 2739.650113124583)
@variable(model, 0.6442573516758648 <= X44 <= 21.484952)
@variable(model, 0.0522 <= X26 <= 6.084643858773449)
@variable(model, 0.003599999999999999 <= X30 <= 4.6225)
@variable(model, 0.06055199999999999 <= X32 <= 21.70514533407823)
@variable(model, 0.000288 <= X36 <= 12.526975)
@variable(model, 0.06909444212821943 <= X24 <= 7.533799999999999)
@constraint(
    model,
    E1,
    - X5 + 1.76*X6 + 2.08*X7 + 0.83*X8 + 4.86*X9 + 9.94*X10 == 29.222
)
@constraint(
    model,
    E2,
    - X0 +
    8.15*X6 +
    1.45*X7 +
    9.42*X8 +
    3.58*X9 +
    0.67*X10 +
    2.85*X35 +
    1.92*X6*X20 +
    4.98*X6*X42 +
    0.19*X6*X58 - 7.92*X6*X60 +
    7.15*X6*X61 +
    6.07*X7*X56 +
    0.43*X7*X59 +
    6.7*X8*X28 +
    6.75*X8*X55 +
    6.65*X8*X57 +
    0.37*X8*X62 +
    0.79*X9*X10 +
    0.74*X10*X59 +
    1.22*X20*X23 +
    4.73*X20*X38 +
    1.98*X21*X37 +
    2.42*X21*X51 +
    1.51*X21*X54 +
    7.6*X22*X39 +
    7.8*X23*X31 - 8.42*X25*X50 +
    1.7*X25*X52 +
    3.65*X27*X41 +
    9.57*X27*X53 - 8.82*X28*X42 +
    9.67*X28*X49 +
    5.11*X29*X43 +
    1.27*X33*X48 +
    9.6*X34*X40 +
    4.26*X34*X41 +
    5.4*X34*X45 +
    3.82*X34*X49 +
    10*X37*X43 +
    1.03*X38*X51 +
    1.57*X39*X45 +
    8.51*X39*X46 +
    4.71*X40*X47 +
    5.85*X41*X52 == 0
)
@constraint(
    model,
    E3,
    - X1 + 8.42*X6 - 6.62*X7 + 1.13*X8 + 0.17*X9 + 2.11*X10 + 2.91*X9*X10 ==
    9.948
)
@constraint(
    model,
    E4,
    - X2 + 5.57*X6 + 2.11*X7 + 0.32*X8 + 7.74*X9 + 2.15*X10 - 6.89*X35 +
    1.93*X6*X20 +
    7.22*X8*X28 - 6.41*X9*X10 == 20.049
)
@constraint(
    model,
    E5,
    - X3 + 7.31*X6 + 0.33*X7 + 9.61*X8 + 0.41*X9 + 1.37*X10 - 1.92*X35 +
    0.44*X6*X20 +
    7.45*X6*X42 +
    2.56*X8*X28 +
    2.6*X9*X10 - 4.79*X20*X23 + 5.94*X23*X31 == 58.679
)
@constraint(
    model,
    E6,
    - X4 - 3.52*X6 + 3.56*X7 + 6.62*X8 + 0.44*X9 + 3.1*X10 - 3.1*X35 +
    2.51*X6*X20 - 5.17*X6*X42 +
    0.18*X8*X28 +
    3.75*X8*X55 +
    4.04*X9*X10 +
    3.88*X20*X23 +
    3.67*X20*X38 +
    3.68*X21*X37 +
    3.32*X22*X39 +
    3.54*X23*X31 +
    1.81*X27*X41 +
    8.8*X28*X42 +
    3.51*X29*X43 == 201.781
)
@constraint(model, E7, - X31 + SQR(X10) == 0)
@constraint(model, E8, - X44 + X10*X31 == 0)
@constraint(model, E9, - X62 + SQR(X44) == 0)
@constraint(model, E10, - X29 + X8*X9 == 0)
@constraint(model, E11, - X41 + X10*X29 == 0)
@constraint(model, E12, - X27 + X7*X10 == 0)
@constraint(model, E13, - X52 + SQR(X27) == 0)
@constraint(model, E14, - X38 + X7*X29 == 0)
@constraint(model, E15, - X26 + X7*X9 == 0)
@constraint(model, E16, - X51 + SQR(X26) == 0)
@constraint(model, E17, - X37 + X7*X26 == 0)
@constraint(model, E18, - X59 + SQR(X37) == 0)
@constraint(model, E19, - X30 + SQR(X9) == 0)
@constraint(model, E20, - X43 + X10*X30 == 0)
@constraint(model, E21, - X61 + SQR(X43) == 0)
@constraint(model, E22, - X42 + X9*X30 == 0)
@constraint(model, E23, - X60 + SQR(X42) == 0)
@constraint(model, E24, - X35 + X6*X29 == 0)
@constraint(model, E25, - X57 + SQR(X35) == 0)
@constraint(model, E26, - X40 + X9*X27 == 0)
@constraint(model, E27, - X22 + X6*X8 == 0)
@constraint(model, E28, - X47 + SQR(X22) == 0)
@constraint(model, E29, - X39 + X8*X27 == 0)
@constraint(model, E30, - X21 + X6*X7 == 0)
@constraint(model, E31, - X46 + SQR(X21) == 0)
@constraint(model, E32, - X32 + X7*X21 == 0)
@constraint(model, E33, - X56 + SQR(X32) == 0)
@constraint(model, E34, - X36 + X6*X30 == 0)
@constraint(model, E35, - X58 + SQR(X36) == 0)
@constraint(model, E36, - X34 + X6*X27 == 0)
@constraint(model, E37, - X24 + X6*X10 == 0)
@constraint(model, E38, - X49 + SQR(X24) == 0)
@constraint(model, E39, - X33 + X7*X22 == 0)
@constraint(model, E40, - X48 + X6*X36 == 0)
@constraint(model, E41, - X20 + SQR(X6) == 0)
@constraint(model, E42, - X45 + SQR(X20) == 0)
@constraint(model, E43, - X28 + SQR(X8) == 0)
@constraint(model, E44, - X53 + SQR(X28) == 0)
@constraint(model, E45, - X25 + X7*X8 == 0)
@constraint(model, E46, - X50 + SQR(X25) == 0)
@constraint(model, E47, - X54 + X9*X42 == 0)
@constraint(model, E48, - X55 + X10*X44 == 0)
@constraint(model, E49, - X23 + X6*X9 == 0)
@constraint(model, E50, objvar == X0)
@objective(model, Min, objvar)
optimize!(model)
