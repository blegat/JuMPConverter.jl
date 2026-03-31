using JuMP
model = Model()
@variable(model, objvar)
@variable(model, 0 <= X4 <= 0)
@variable(model, 0.26 <= X7 <= 2.118497024858152)
@variable(model, 0.6441719536737235 <= X8 <= 2.81)
@variable(model, 0.28 <= X9 <= 2.78)
@variable(model, 0 <= X5 <= 37.99202768643615)
@variable(model, 0.39 <= X10 <= 2.19)
@variable(model, 0.62 <= X11 <= 2.94)
@variable(model, 0.52 <= X12 <= 2.62)
@variable(model, 0 <= X6 <= 20.75777202661986)
@variable(model, -14295.45367343675 <= X0 <= 72475.04665878841)
@variable(model, 0.125736 <= X70 <= 16.869132)
@variable(model, 0.01760304 <= X79 <= 37.91963074501974)
@variable(model, 0.08099560476711927 <= X85 <= 47.40226092000001)
@variable(model, 0.1612 <= X44 <= 6.228381253082969)
@variable(model, 0.2704 <= X59 <= 6.864400000000001)
@variable(model, 0.1521 <= X54 <= 4.7961)
@variable(model, 0.006146560000000001 <= X86 <= 59.72816656)
@variable(model, 0.05846723999999998 <= X89 <= 41.45556996000001)
@variable(model, 0.0703435773411706 <= X66 <= 17.107842)
@variable(model, 0.02438577347827247 <= X78 <= 43.35910065402173)
@variable(model, 0.1595096652678915 <= X83 <= 68.25072996000002)
@variable(model, 0.05815069060203436 <= X84 <= 60.17273304000001)
@variable(model, 0.10394176 <= X92 <= 59.33312784000002)
@variable(model, 0.14776336 <= X91 <= 74.71182096000003)
@variable(model, 0.06531903610251555 <= X61 <= 13.03701884127459)
@variable(model, 0.01028196 <= X73 <= 21.52503897718476)
@variable(model, 0.02907534530101718 <= X77 <= 48.65486867283354)
@variable(model, 0.07311615999999999 <= X93 <= 47.11998736000001)
@variable(model, 0.037856 <= X65 <= 15.43028493025684)
@variable(model, 0.06759999999999999 <= X40 <= 4.488029644332844)
@variable(model, 0.1306380722050311 <= X68 <= 16.123218)
@variable(model, 0.1674847079551681 <= X41 <= 5.952976639851409)
@variable(model, 0.07840000000000001 <= X50 <= 7.7284)
@variable(model, 0.02805112739882794 <= X72 <= 35.43793087461658)
@variable(model, 0.0728 <= X42 <= 5.889421729105664)
@variable(model, 0.018928 <= X60 <= 12.47672241124531)
@variable(model, 0.01827904 <= X75 <= 30.80763069055838)
@variable(model, 0.1014 <= X43 <= 4.639508484439355)
@variable(model, 0.02598543999999999 <= X74 <= 38.79273303375538)
@variable(model, 0.01476384 <= X80 <= 33.79232399726249)
@variable(model, 0.1721897317026006 <= X81 <= 62.34839521000001)
@variable(model, 0.1352 <= X45 <= 5.55046220512836)
@variable(model, 0.02119936 <= X88 <= 53.05082896)
@variable(model, 0.4149575058998217 <= X46 <= 7.896100000000001)
@variable(model, 0.0870920481366874 <= X62 <= 15.59679879641069)
@variable(model, 0.105456 <= X71 <= 15.033036)
@variable(model, 0.01828933010870435 <= X76 <= 36.24291237874336)
@variable(model, 0.1803681470286426 <= X47 <= 7.8118)
@variable(model, 0.1736 <= X52 <= 8.1732)
@variable(model, 0.3844 <= X57 <= 8.643600000000001)
@variable(model, 0.03253266846254602 <= X82 <= 61.02421924000001)
@variable(model, 0.2512270619327521 <= X48 <= 6.1539)
@variable(model, 0.01192464 <= X87 <= 37.06617924)
@variable(model, 0.3349694159103362 <= X49 <= 7.362200000000001)
@variable(model, 0.2076810378644084 <= X69 <= 21.644868)
@variable(model, 0.028392 <= X63 <= 12.89783358674141)
@variable(model, 0.045136 <= X64 <= 17.31489988357065)
@variable(model, 0.1092 <= X51 <= 6.0882)
@variable(model, 0.2418 <= X55 <= 6.4386)
@variable(model, 0.04112783999999999 <= X90 <= 32.92234884000001)
@variable(model, 0.1456 <= X53 <= 7.2836)
@variable(model, 0.2028 <= X56 <= 5.737800000000001)
@variable(model, 0.3224 <= X58 <= 7.702800000000001)
@variable(model, 0.09379143645489413 <= X67 <= 20.466916)
@variable(model, -0 <= X1 <= 173.6292701540026)
@variable(model, -0 <= X2 <= 2615.242443531097)
@variable(model, -0 <= X3 <= 20417.07299476743)
@constraint(model, E1, - X4 + 9.33*X7 + 7.83*X8 + 2.12*X9 == 26.505)
@constraint(
    model,
    E2,
    - X5 + 7.5*X7 + 4*X8 + 4.44*X9 + 6.45*X10 + 7.51*X11 - 5.69*X12 == 34.726
)
@constraint(
    model,
    E3,
    - X6 + 2.68*X7 + 8.06*X8 + 0.49*X9 + 1.26*X10 + 5.32*X11 + 0.11*X12 ==
    27.619
)
@constraint(
    model,
    E4,
    - X0 +
    5.52*X7 +
    5.92*X8 +
    0.8*X9 +
    4.55*X10 +
    6.05*X11 +
    2.24*X12 +
    3.2*X70 +
    9.4*X79 - 5.91*X85 +
    2.65*X7*X44 +
    6.94*X7*X59 +
    1.04*X7*X70 - 1.78*X8*X54 +
    9.5*X8*X86 +
    6.92*X8*X89 +
    9.86*X9*X66 +
    0.04*X9*X78 +
    9.18*X9*X79 +
    6.42*X9*X83 +
    3.21*X9*X84 +
    2.99*X9*X86 +
    6.86*X9*X92 +
    6.13*X10*X54 +
    6.46*X10*X86 +
    9.94*X10*X91 +
    2.26*X11*X61 +
    0.74*X11*X73 +
    8.41*X11*X77 +
    8.79*X11*X84 +
    7.23*X11*X91 +
    1.48*X11*X93 +
    2.97*X12*X65 +
    4.93*X40*X61 +
    0.83*X40*X68 +
    3.79*X40*X70 +
    1.29*X40*X77 +
    8.47*X41*X50 +
    1.24*X41*X68 +
    9.7*X41*X72 +
    8.92*X41*X73 - 3.78*X42*X60 + 8.75*X42*X75 - 2.59*X42*X79 +
    2.19*X42*X92 +
    4.38*X43*X74 +
    7.71*X43*X75 +
    0.88*X43*X80 +
    5.9*X43*X81 +
    1.08*X44*X72 - 3.85*X44*X73 +
    5.7*X44*X74 +
    0.45*X44*X81 +
    6.3*X44*X85 +
    1.95*X44*X86 +
    1.53*X44*X93 +
    8.5*X45*X88 +
    1.02*X46*X62 +
    6.95*X46*X68 +
    5.76*X46*X71 +
    4.3*X46*X76 +
    3.1*X46*X85 +
    1.82*X47*X52 +
    6.57*X47*X57 - 7.18*X47*X72 +
    1.93*X47*X82 +
    4.81*X47*X84 - 4.12*X47*X88 - 7.23*X48*X87 +
    5.74*X49*X69 +
    1.79*X49*X74 - 2.3*X50*X63 +
    2.27*X50*X64 +
    6.08*X50*X79 +
    2.75*X50*X84 - 8.54*X50*X85 +
    3.86*X51*X55 +
    2.78*X51*X72 +
    0.73*X51*X86 +
    1.59*X51*X90 +
    8.53*X52*X74 +
    6.65*X52*X91 +
    5.67*X52*X92 +
    4.27*X53*X82 +
    8.04*X54*X55 +
    6.69*X54*X66 +
    0.52*X54*X79 +
    2.05*X54*X80 - 7.43*X56*X81 +
    4.57*X57*X64 +
    9.28*X57*X65 +
    9.29*X57*X79 +
    6.78*X58*X73 - 8.61*X59*X69 +
    9.15*X59*X78 +
    1.7*SQR(X60) +
    6.03*SQR(X65) +
    4.88*SQR(X67) +
    0.38*SQR(X71) == 0
)
@constraint(
    model,
    E5,
    - X1 +
    9.57*X7 +
    6.78*X8 +
    8.1*X9 +
    3.27*X10 +
    3.24*X11 +
    9.04*X12 +
    1.22*X70 +
    5.7*X7*X44 +
    1.49*X7*X59 +
    1.63*X8*X54 +
    2.18*X10*X54 == 90.91
)
@constraint(
    model,
    E6,
    - X2 - 6.65*X7 + 9.08*X8 + 0.48*X9 + 1.78*X10 + 9.6*X11 - 2.86*X12 +
    1.45*X70 +
    0.01*X79 +
    1.07*X85 +
    7.51*X7*X44 +
    0.49*X7*X59 +
    9.76*X7*X70 +
    7.34*X8*X54 +
    3.15*X9*X66 +
    8.3*X10*X54 +
    6.51*X11*X61 +
    6.73*X12*X65 +
    4.56*X41*X50 +
    9.45*X47*X52 +
    1.83*X47*X57 +
    8.61*X51*X55 +
    8.7*X54*X55 == 371.477
)
@constraint(
    model,
    E7,
    - X3 +
    3.43*X7 +
    9.56*X8 +
    1.85*X9 +
    0.52*X10 +
    6.74*X11 +
    5.61*X12 +
    2.39*X70 +
    1.05*X79 +
    9.29*X85 +
    7.85*X7*X44 +
    4.63*X7*X59 +
    4.85*X7*X70 +
    2.1*X8*X54 +
    6.74*X8*X86 +
    4.27*X8*X89 +
    9.34*X9*X66 +
    6.16*X9*X78 +
    7.35*X9*X79 +
    5.47*X9*X83 +
    8.08*X9*X84 +
    6.66*X9*X86 +
    0.66*X9*X92 +
    8.3*X10*X54 +
    6.9*X10*X86 +
    2.28*X10*X91 +
    7.83*X11*X61 +
    3.37*X11*X73 +
    7.69*X11*X77 +
    5.31*X11*X84 +
    7.12*X11*X91 +
    1.9*X11*X93 +
    3*X12*X65 +
    0.89*X40*X61 +
    5.13*X40*X68 +
    8.29*X40*X70 +
    0.24*X41*X50 - 5.09*X41*X68 +
    9.01*X42*X60 +
    1.61*X46*X62 +
    8.3*X46*X68 +
    0.1*X46*X71 +
    3.57*X47*X52 +
    6.18*X47*X57 +
    8.27*X49*X69 - 0.62*X50*X63 +
    4.1*X50*X64 +
    4.48*X51*X55 +
    0.01*X54*X55 +
    3.83*X54*X66 - 8.77*X57*X64 +
    5.58*X57*X65 +
    7.41*X59*X69 == 1446.92
)
@constraint(model, E8, - X59 + SQR(X12) == 0)
@constraint(model, E9, - X71 + X10*X59 == 0)
@constraint(model, E10, - X52 + X9*X11 == 0)
@constraint(model, E11, - X58 + X11*X12 == 0)
@constraint(model, E12, - X92 + SQR(X58) == 0)
@constraint(model, E13, - X57 + SQR(X11) == 0)
@constraint(model, E14, - X91 + SQR(X57) == 0)
@constraint(model, E15, - X51 + X9*X10 == 0)
@constraint(model, E16, - X90 + X10*X71 == 0)
@constraint(model, E17, - X50 + SQR(X9) == 0)
@constraint(model, E18, - X86 + SQR(X50) == 0)
@constraint(model, E19, - X48 + X8*X10 == 0)
@constraint(model, E20, - X85 + X48*X58 == 0)
@constraint(model, E21, - X87 + SQR(X51) == 0)
@constraint(model, E22, - X47 + X8*X9 == 0)
@constraint(model, E23, - X88 + X50*X59 == 0)
@constraint(model, E24, - X84 + X47*X58 == 0)
@constraint(model, E25, - X67 + X12*X47 == 0)
@constraint(model, E26, - X53 + X9*X12 == 0)
@constraint(model, E27, - X82 + SQR(X47) == 0)
@constraint(model, E28, - X46 + SQR(X8) == 0)
@constraint(model, E29, - X56 + X10*X12 == 0)
@constraint(model, E30, - X81 + SQR(X46) == 0)
@constraint(model, E31, - X44 + X7*X11 == 0)
@constraint(model, E32, - X93 + SQR(X59) == 0)
@constraint(model, E33, - X42 + X7*X9 == 0)
@constraint(model, E34, - X79 + X44*X51 == 0)
@constraint(model, E35, - X80 + X42*X56 == 0)
@constraint(model, E36, - X54 + SQR(X10) == 0)
@constraint(model, E37, - X45 + X7*X12 == 0)
@constraint(model, E38, - X78 + X7*X67 == 0)
@constraint(model, E39, - X76 + X42*X48 == 0)
@constraint(model, E40, - X43 + X7*X10 == 0)
@constraint(model, E41, - X73 + SQR(X43) == 0)
@constraint(model, E42, - X74 + SQR(X44) == 0)
@constraint(model, E43, - X65 + X7*X53 == 0)
@constraint(model, E44, - X49 + X8*X12 == 0)
@constraint(model, E45, - X41 + X7*X8 == 0)
@constraint(model, E46, - X72 + SQR(X41) == 0)
@constraint(model, E47, - X75 + SQR(X45) == 0)
@constraint(model, E48, - X77 + X41*X52 == 0)
@constraint(model, E49, - X40 + SQR(X7) == 0)
@constraint(model, E50, - X60 + X7*X42 == 0)
@constraint(model, E51, - X69 + X8*X58 == 0)
@constraint(model, E52, - X89 + X54*X57 == 0)
@constraint(model, E53, - X66 + X8*X51 == 0)
@constraint(model, E54, - X83 + X46*X57 == 0)
@constraint(model, E55, - X68 + X8*X56 == 0)
@constraint(model, E56, - X64 + X7*X52 == 0)
@constraint(model, E57, - X63 + X7*X51 == 0)
@constraint(model, E58, - X62 + X7*X49 == 0)
@constraint(model, E59, - X70 + X10*X58 == 0)
@constraint(model, E60, - X61 + X7*X48 == 0)
@constraint(model, E61, - X55 + X10*X11 == 0)
@constraint(model, E62, objvar == X0)
@objective(model, Min, objvar)
optimize!(model)
