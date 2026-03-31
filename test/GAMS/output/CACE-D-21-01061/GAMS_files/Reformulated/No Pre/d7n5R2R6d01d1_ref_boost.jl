using JuMP
model = Model()
@variable(model, objvar)
@variable(model, 0 <= X7 <= 34.63050000000001)
@variable(model, 0.77 <= X8 <= 2.68)
@variable(model, 0.84 <= X9 <= 2.61)
@variable(model, 0.34 <= X10 <= 2.93)
@variable(model, 0.8100000000000001 <= X11 <= 2.75)
@variable(model, 0.08 <= X12 <= 2.4)
@variable(model, 0 <= X5 <= 0)
@variable(model, 0 <= X6 <= 0)
@variable(model, -12426.20612146906 <= X0 <= 227110.0750237333)
@variable(model, 0.0272 <= X50 <= 7.032000000000001)
@variable(model, 0.6561 <= X51 <= 7.5625)
@variable(model, 0.201586 <= X53 <= 21.04443200000001)
@variable(model, 0.020944 <= X59 <= 18.84576000000001)
@variable(model, 0.054432 <= X65 <= 17.226)
@variable(model, 0.06853924 <= X72 <= 61.66018576000002)
@variable(model, 0.003794559999999999 <= X74 <= 41.37062400000001)
@variable(model, 8.5525504e-05 <= X96 <= 424.5149261376001)
@variable(model, 2.621439999999999e-07 <= X99 <= 191.102976)
@variable(model, 0.5929 <= X39 <= 7.182400000000001)
@variable(model, 0.4183502399999999 <= X71 <= 48.92722704000001)
@variable(model, 0.208422380089 <= X83 <= 370.5175333642242)
@variable(model, 0.04063691539599999 <= X84 <= 442.8681182026243)
@variable(model, 0.007923136144 <= X87 <= 529.3465287310243)
@variable(model, 0.05755392921599998 <= X91 <= 398.3797640592091)
@variable(model, 0.05351634489599999 <= X93 <= 442.2640545056251)
@variable(model, 4.734975999999998e-06 <= X97 <= 284.8263782400001)
@variable(model, 0.05174399999999999 <= X56 <= 16.78752)
@variable(model, 0.5715359999999999 <= X62 <= 18.733275)
@variable(model, 0.022032 <= X67 <= 19.338)
@variable(model, 0.002489610815999999 <= X89 <= 312.8653440000001)
@variable(model, 0.3037376633759999 <= X94 <= 389.593578515625)
@variable(model, 0.0005119999999999999 <= X69 <= 13.824)
@variable(model, 0.3512980316159998 <= X90 <= 316.1135005355611)
@variable(model, 0.002962842623999999 <= X95 <= 296.735076)
@variable(model, 0.006399999999999999 <= X52 <= 5.76)
@variable(model, 0.35153041 <= X70 <= 51.58686976000002)
@variable(model, 0.43046721 <= X81 <= 57.19140625)
@variable(model, 0.2744795924639999 <= X85 <= 370.0121544900001)
@variable(model, 0.002754990144 <= X98 <= 329.4225)
@variable(model, 0.08156735999999999 <= X75 <= 58.48119729000001)
@variable(model, 0.00073984 <= X80 <= 49.44902400000001)
@variable(model, 4.095999999999999e-05 <= X82 <= 33.1776)
@variable(model, 0.002677441535999999 <= X86 <= 281.8208277504001)
@variable(model, 0.0004386511359999999 <= X88 <= 355.1626699776001)
@variable(model, 0.3266533992959998 <= X92 <= 350.935592225625)
@variable(model, 0.6467999999999999 <= X40 <= 6.994800000000001)
@variable(model, 0.6237 <= X42 <= 7.370000000000001)
@variable(model, 0.5511239999999999 <= X64 <= 19.738125)
@variable(model, 0.38900169 <= X73 <= 54.31690000000001)
@variable(model, 0.4629441599999999 <= X76 <= 51.51650625000001)
@variable(model, 0.07584515999999999 <= X79 <= 64.92330625000001)
@variable(model, 0.7055999999999999 <= X44 <= 6.8121)
@variable(model, 0.022848 <= X63 <= 18.35352)
@variable(model, 0.004515839999999998 <= X77 <= 39.237696)
@variable(model, 0.01336336 <= X78 <= 73.70050801000002)
@variable(model, 0.2856 <= X45 <= 7.6473)
@variable(model, 0.6804 <= X46 <= 7.1775)
@variable(model, 0.052488 <= X68 <= 18.15)
@variable(model, 0.0672 <= X47 <= 6.264)
@variable(model, 0.2754 <= X49 <= 8.057500000000001)
@variable(model, 0.219912 <= X54 <= 20.494764)
@variable(model, 0.5239079999999999 <= X55 <= 19.2357)
@variable(model, 0.212058 <= X58 <= 21.5941)
@variable(model, 0.049896 <= X60 <= 17.688)
@variable(model, 0 <= X1 <= 103.8960300000001)
@variable(model, -0 <= X2 <= 562.9022512800008)
@variable(model, -0 <= X3 <= 1404.267708541202)
@variable(model, -0 <= X4 <= 7693.657462770133)
@variable(model, 0.5927039999999998 <= X61 <= 17.779581)
@variable(model, 0.009247999999999999 <= X66 <= 20.60376)
@variable(model, 0.2618 <= X41 <= 7.852400000000001)
@variable(model, 0.08901200000000001 <= X57 <= 23.007532)
@variable(model, 0.0616 <= X43 <= 6.432)
@variable(model, 0.1156 <= X48 <= 8.584900000000001)
@constraint(
    model,
    E1,
    - X7 + 6.56*X8 + 3.59*X9 + 8.01*X10 + 8.29*X11 + 5.84*X12 == 52.603
)
@constraint(
    model,
    E2,
    - X5 + 8.81*X8 + X9 + 7.09*X10 + 4.52*X11 + 3.57*X12 == 40.987
)
@constraint(
    model,
    E3,
    - X6 + 2.2*X8 + 8.16*X9 + 4.05*X10 + 1.68*X11 + 3.66*X12 == 32.022
)
@constraint(
    model,
    E4,
    - X0 + 8.05*X8 + 3.86*X9 + 8.02*X10 + 8.73*X11 + 2.38*X12 - 2.96*X50 +
    5.59*X51 +
    6.2*X53 +
    3.82*X59 +
    2.38*X65 +
    9.97*X72 +
    4.32*X74 +
    2.27*X96 +
    3.49*X99 +
    4.24*X8*X39 +
    5.98*X8*X71 +
    5.36*X8*X83 - 8.09*X8*X84 +
    3.16*X8*X87 +
    9.67*X8*X91 +
    9.1*X8*X93 +
    8.36*X8*X96 +
    1.46*X8*X97 +
    0.94*X9*X56 - 8.24*X9*X62 +
    5.1*X9*X67 +
    5.56*X9*X83 +
    3.89*X9*X89 +
    7.12*X9*X94 +
    7.98*X9*X99 +
    3.06*X10*X69 +
    9.76*X10*X90 +
    2.51*X10*X95 +
    6.62*X10*X99 +
    8.21*X11*X52 +
    2.86*X11*X70 +
    1.76*X11*X72 +
    4.98*X11*X81 +
    6.57*X11*X85 - 1.42*X11*X98 - 2.97*X12*X75 +
    0.56*X12*X80 +
    3.44*X12*X81 +
    9.88*X12*X82 +
    9.15*X12*X86 +
    6.02*X12*X88 +
    9.25*X12*X92 +
    1.54*X12*X94 +
    0.05*X40*X65 +
    4.77*X42*X64 +
    5.6*X42*X73 +
    5.04*X42*X76 +
    8.4*X42*X79 +
    0.88*X44*X63 +
    1.34*X44*X77 +
    0.92*X44*X78 +
    3.88*X45*X71 +
    3.58*X46*X68 +
    2.19*X46*X78 +
    9.05*X47*X80 +
    0.29*X49*X72 +
    4.38*X49*X81 +
    0.27*X50*X68 +
    2.82*X50*X72 +
    8.69*X54*X73 +
    7.96*X54*X74 +
    3.98*X55*X71 +
    8.04*X56*X70 +
    5.78*X56*X74 +
    9.32*X56*X76 +
    2.54*X56*X77 - 0.33*X56*X81 +
    5.51*X58*X75 +
    0.4*X58*X82 +
    5.84*X59*X72 +
    8.37*X59*X81 +
    5.19*X59*X82 +
    9.38*X60*X72 +
    6.23*X60*X82 +
    0.21*X63*X71 +
    2.69*X63*X75 +
    7.62*X65*X80 - 1.22*X67*X68 + 7.19*X67*X80 == 0
)
@constraint(
    model,
    E5,
    - X1 +
    1.38*X8 +
    8.36*X9 +
    1.72*X10 +
    3.61*X11 +
    4.31*X12 +
    8.99*X50 +
    8.98*X51 == 78.062
)
@constraint(
    model,
    E6,
    - X2 +
    2.71*X8 +
    6.27*X9 +
    8.77*X10 +
    4.35*X11 +
    1.84*X12 +
    6.14*X50 +
    3.9*X51 +
    8.84*X53 +
    7.66*X59 +
    6.88*X65 +
    0.65*X8*X39 +
    9.7*X11*X52 == 190.536
)
@constraint(
    model,
    E7,
    - X3 +
    5.25*X8 +
    0.56*X9 +
    6.66*X10 +
    4.13*X11 +
    2.18*X12 +
    2.96*X50 +
    0.12*X51 - 7.36*X53 +
    4.99*X59 +
    4.78*X65 +
    3.41*X72 +
    3.68*X74 +
    0.32*X8*X39 +
    2.68*X9*X56 +
    9.4*X9*X62 +
    7.5*X9*X67 - 9.08*X10*X69 + 2.74*X11*X52 == 211.62
)
@constraint(
    model,
    E8,
    - X4 + 5.66*X8 - 8.61*X9 +
    2.1*X10 +
    1.66*X11 +
    1.72*X12 +
    7.01*X50 +
    7.07*X51 +
    2.78*X53 +
    8.84*X59 +
    3*X65 +
    3.62*X72 - 6.4*X74 - 0.93*X8*X39 +
    5.91*X8*X71 +
    5.75*X9*X56 +
    3.34*X9*X62 +
    2.03*X9*X67 +
    1.85*X10*X69 +
    5.32*X11*X52 +
    2.3*X11*X70 +
    0.29*X11*X72 +
    5.35*X11*X81 +
    7.87*X12*X75 +
    3.85*X12*X80 +
    6.63*X12*X81 +
    8.2*X12*X82 +
    0.18*X40*X65 +
    7.78*X42*X64 +
    0.06*X44*X63 +
    3.53*X46*X68 +
    3.77*X50*X68 == 826.608
)
@constraint(model, E9, - X51 + SQR(X11) == 0)
@constraint(model, E10, - X68 + X12*X51 == 0)
@constraint(model, E11, - X98 + SQR(X68) == 0)
@constraint(model, E12, - X52 + SQR(X12) == 0)
@constraint(model, E13, - X69 + X12*X52 == 0)
@constraint(model, E14, - X99 + SQR(X69) == 0)
@constraint(model, E15, - X49 + X10*X11 == 0)
@constraint(model, E16, - X67 + X12*X49 == 0)
@constraint(model, E17, - X50 + X10*X12 == 0)
@constraint(model, E18, - X80 + SQR(X50) == 0)
@constraint(model, E19, - X46 + X9*X11 == 0)
@constraint(model, E20, - X65 + X12*X46 == 0)
@constraint(model, E21, - X64 + X9*X51 == 0)
@constraint(model, E22, - X94 + SQR(X64) == 0)
@constraint(model, E23, - X95 + SQR(X65) == 0)
@constraint(model, E24, - X63 + X9*X50 == 0)
@constraint(model, E25, - X45 + X9*X10 == 0)
@constraint(model, E26, - X75 + SQR(X45) == 0)
@constraint(model, E27, - X62 + X9*X46 == 0)
@constraint(model, E28, - X92 + SQR(X62) == 0)
@constraint(model, E29, - X44 + SQR(X9) == 0)
@constraint(model, E30, - X61 + X9*X44 == 0)
@constraint(model, E31, - X90 + SQR(X61) == 0)
@constraint(model, E32, - X42 + X8*X11 == 0)
@constraint(model, E33, - X60 + X12*X42 == 0)
@constraint(model, E34, - X82 + X12*X69 == 0)
@constraint(model, E35, - X59 + X8*X50 == 0)
@constraint(model, E36, - X58 + X8*X49 == 0)
@constraint(model, E37, - X81 + SQR(X51) == 0)
@constraint(model, E38, - X97 + X52*X80 == 0)
@constraint(model, E39, - X66 + X10*X50 == 0)
@constraint(model, E40, - X96 + SQR(X66) == 0)
@constraint(model, E41, - X40 + X8*X9 == 0)
@constraint(model, E42, - X56 + X12*X40 == 0)
@constraint(model, E43, - X93 + X51*X75 == 0)
@constraint(model, E44, - X77 + X44*X52 == 0)
@constraint(model, E45, - X76 + X9*X64 == 0)
@constraint(model, E46, - X91 + X44*X75 == 0)
@constraint(model, E47, - X88 + SQR(X59) == 0)
@constraint(model, E48, - X89 + SQR(X60) == 0)
@constraint(model, E49, - X86 + SQR(X56) == 0)
@constraint(model, E50, - X55 + X8*X46 == 0)
@constraint(model, E51, - X85 + SQR(X55) == 0)
@constraint(model, E52, - X71 + SQR(X40) == 0)
@constraint(model, E53, - X41 + X8*X10 == 0)
@constraint(model, E54, - X72 + SQR(X41) == 0)
@constraint(model, E55, - X57 + X10*X41 == 0)
@constraint(model, E56, - X87 + SQR(X57) == 0)
@constraint(model, E57, - X43 + X8*X12 == 0)
@constraint(model, E58, - X74 + SQR(X43) == 0)
@constraint(model, E59, - X54 + X8*X45 == 0)
@constraint(model, E60, - X73 + SQR(X42) == 0)
@constraint(model, E61, - X53 + X8*X41 == 0)
@constraint(model, E62, - X84 + SQR(X53) == 0)
@constraint(model, E63, - X39 + SQR(X8) == 0)
@constraint(model, E64, - X70 + SQR(X39) == 0)
@constraint(model, E65, - X83 + X39*X70 == 0)
@constraint(model, E66, - X47 + X9*X12 == 0)
@constraint(model, E67, - X48 + SQR(X10) == 0)
@constraint(model, E68, - X78 + SQR(X48) == 0)
@constraint(model, E69, - X79 + X48*X51 == 0)
@constraint(model, E70, objvar == X0)
@objective(model, Min, objvar)
optimize!(model)
