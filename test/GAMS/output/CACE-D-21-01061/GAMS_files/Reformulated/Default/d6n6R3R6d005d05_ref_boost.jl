using JuMP
model = Model()
@variable(model, objvar)
@variable(model, 0 <= X5 <= 0)
@variable(model, 0.7498779198799009 <= X9 <= 2.47)
@variable(model, 0.8618147147058749 <= X10 <= 2.507726531018846)
@variable(model, 0.24 <= X12 <= 2.501366513588153)
@variable(model, 0 <= X6 <= 0)
@variable(model, 0.6441018466219635 <= X13 <= 1.618064416694768)
@variable(model, 0 <= X7 <= 0)
@variable(model, 0.7732891520785232 <= X14 <= 2.88)
@variable(model, 0 <= X8 <= 25.39461878366708)
@variable(model, 1.287103647326649 <= X11 <= 2.88)
@variable(model, -4770.899346315389 <= X0 <= 31986.5332193398)
@variable(model, 0.3089048753583957 <= X52 <= 7.203935559133882)
@variable(model, 0.04278093710305354 <= X73 <= 39.3473068758674)
@variable(model, 0.1855893964988456 <= X57 <= 7.203935559133882)
@variable(model, 0.3162002900913752 <= X66 <= 37.22098081000001)
@variable(model, 0.8290258360369589 <= X53 <= 4.660025520080933)
@variable(model, 0.4176465921032371 <= X67 <= 38.36668318481141)
@variable(model, 0.4997426193928417 <= X61 <= 17.83896345105567)
@variable(model, 0.02389635007613702 <= X79 <= 16.38122131046782)
@variable(model, 0.0344434240928057 <= X80 <= 51.89668754015359)
@variable(model, 0.5798724608263353 <= X45 <= 7.113600000000001)
@variable(model, 0.5623168947234071 <= X41 <= 6.100900000000001)
@variable(model, 0.4148671888218233 <= X58 <= 2.618132456573782)
@variable(model, 0.1332231478051283 <= X64 <= 10.14970251832423)
@variable(model, 0.6462558255855316 <= X42 <= 6.19408453161655)
@variable(model, 0.09542222202018596 <= X76 <= 51.89668754015359)
@variable(model, 0.965170605727141 <= X43 <= 7.113600000000001)
@variable(model, 0.1551013981405276 <= X60 <= 15.49367562972)
@variable(model, 0.03238945313606824 <= X68 <= 38.17232120632272)
@variable(model, 0.1799707007711762 <= X44 <= 6.17837528856274)
@variable(model, 0.05759999999999999 <= X55 <= 6.256834435300154)
@variable(model, 0.4980769708265091 <= X59 <= 4.660025520080933)
@variable(model, 0.7427246024835685 <= X46 <= 6.288692354375814)
@variable(model, 1.109244862617707 <= X47 <= 7.222252409334276)
@variable(model, 0.6664319699837004 <= X50 <= 7.222252409334276)
@variable(model, 0.08963926147763153 <= X70 <= 28.79138651733977)
@variable(model, 0.9953032880783989 <= X54 <= 8.2944)
@variable(model, 0.9906286352596719 <= X77 <= 68.79707136)
@variable(model, 0.2068355315294099 <= X48 <= 6.272743169927124)
@variable(model, 0.5550964491880346 <= X49 <= 4.057663066643004)
@variable(model, 1.230424165243775 <= X72 <= 52.16092986413475)
@variable(model, 2.744442170401014 <= X75 <= 68.79707136)
@variable(model, 0.003317759999999999 <= X78 <= 39.1479771507578)
@variable(model, 0.1545844431892712 <= X56 <= 4.047372148748842)
@variable(model, 0.6216681694540904 <= X63 <= 11.51026303459991)
@variable(model, 0.4441315706163557 <= X74 <= 52.16092986413475)
@variable(model, 0.1791254302353253 <= X69 <= 51.24591599345479)
@variable(model, 0.5516398351343749 <= X71 <= 39.54765152798483)
@variable(model, 1.242274606923874 <= X62 <= 20.487168)
@variable(model, 0.357538647975308 <= X65 <= 6.565560223071619)
@variable(model, 0 <= X1 <= 38.46843212182433)
@variable(model, -0 <= X2 <= 384.6400412673821)
@variable(model, -0 <= X3 <= 2036.193837923104)
@variable(model, -0 <= X4 <= 6721.467614933777)
@variable(model, 1.656635798961562 <= X51 <= 8.2944)
@constraint(model, E1, - X5 + 8.83*X9 - 1.95*X10 + 7.62*X12 == 21.477)
@constraint(model, E2, - X6 + 6.58*X9 + 7.59*X12 + 6.2*X13 == 27.913)
@constraint(model, E3, - X7 + 7.31*X9 + 8.79*X10 - 5.62*X14 == 15.651)
@constraint(
    model,
    E4,
    - X8 + 1.74*X9 + 1.09*X10 + 8.69*X11 + 4.88*X12 + 7.58*X13 + 3.72*X14 ==
    41.849
)
@constraint(
    model,
    E5,
    - X0 + 0.82*X9 + 0.14*X10 + 0.96*X11 + 1.11*X12 + 2.23*X13 - 1.5*X14 +
    7.01*X52 +
    1.8*X73 +
    7.48*X9*X57 +
    9.72*X9*X66 +
    2.8*X10*X53 - 2.5*X11*X67 - 4.94*X12*X57 +
    4.78*X13*X61 +
    6.83*X13*X79 +
    1.42*X13*X80 +
    5.41*X14*X45 +
    7.92*X41*X58 +
    5.09*X41*X64 +
    7.42*X42*X76 +
    1.99*X43*X60 +
    9.23*X43*X68 +
    0.74*X44*X55 +
    4.92*X45*X59 +
    8.04*X45*X68 +
    1.8*X46*X47 +
    5.62*X46*X50 +
    8.07*X46*X60 - 8.78*X46*X70 +
    7.45*X47*X54 +
    3.34*X47*X77 +
    4.19*X48*X55 +
    9.29*X49*X61 +
    6*X49*X68 +
    8.49*X49*X72 +
    4.43*X49*X75 +
    9.18*X50*X78 +
    7.15*X52*X55 +
    9.26*X52*X68 +
    2.99*X53*X73 +
    0.09*X53*X78 +
    0.69*X55*X56 +
    1.81*X55*X63 - 6.61*X55*X64 +
    3.95*X56*X74 +
    4.73*X58*X69 +
    3.35*X59*X67 +
    8.07*X59*X71 - 6.48*X59*X77 +
    5.35*SQR(X61) +
    6.82*SQR(X62) - 8.88*SQR(X65) == 0
)
@constraint(
    model,
    E6,
    - X1 +
    0.48*X9 +
    6.87*X10 +
    7.81*X11 +
    2.31*X12 +
    8.03*X13 +
    5.85*X14 +
    2.22*X52 == 54.05
)
@constraint(
    model,
    E7,
    - X2 +
    5.47*X9 +
    5.35*X10 +
    4.83*X11 +
    0.65*X12 +
    5.14*X13 +
    8.66*X14 +
    9.32*X52 +
    7.62*X9*X57 +
    6.61*X10*X53 - 9.03*X12*X57 + 7.69*X14*X45 == 128.199
)
@constraint(
    model,
    E8,
    - X3 +
    8.14*X9 +
    6.31*X10 +
    1.69*X11 +
    0.9*X12 +
    4.75*X13 +
    4.62*X14 +
    2.96*X52 +
    2.18*X73 +
    3.36*X9*X57 +
    1.61*X10*X53 +
    9.96*X12*X57 +
    5.36*X13*X61 +
    5.87*X14*X45 +
    1.82*X41*X58 +
    7.7*X44*X55 +
    7.95*X45*X59 +
    5.47*X46*X47 - 3.34*X46*X50 +
    4.31*X47*X54 +
    5.21*X48*X55 +
    8.26*X52*X55 +
    1.82*X55*X56 == 386.119
)
@constraint(
    model,
    E9,
    - X4 + 6.26*X9 + 3.02*X10 + 0.23*X11 + 0.74*X12 + 9.81*X13 - 2.35*X14 +
    5.56*X52 +
    2.77*X73 +
    1.58*X9*X57 +
    5.78*X9*X66 +
    9.97*X10*X53 +
    2.46*X11*X67 +
    2.63*X12*X57 +
    2.01*X13*X61 +
    5.68*X13*X79 +
    7.57*X13*X80 +
    9.93*X14*X45 +
    7.84*X41*X58 +
    6.65*X41*X64 +
    5.77*X43*X60 +
    8.91*X44*X55 +
    8.91*X45*X59 +
    7.54*X46*X47 +
    4.59*X46*X50 +
    8.02*X46*X60 +
    9.33*X47*X54 +
    8.1*X48*X55 +
    6.49*X49*X61 +
    3.23*X52*X55 +
    1.19*X55*X56 +
    8.74*X55*X63 +
    2.42*X55*X64 == 960.624
)
@constraint(model, E10, - X53 + X11*X13 == 0)
@constraint(model, E11, - X55 + SQR(X12) == 0)
@constraint(model, E12, - X78 + SQR(X55) == 0)
@constraint(model, E13, - X59 + X13*X14 == 0)
@constraint(model, E14, - X54 + X11*X14 == 0)
@constraint(model, E15, - X77 + SQR(X54) == 0)
@constraint(model, E16, - X50 + X10*X14 == 0)
@constraint(model, E17, - X47 + X10*X11 == 0)
@constraint(model, E18, - X49 + X10*X13 == 0)
@constraint(model, E19, - X51 + SQR(X11) == 0)
@constraint(model, E20, - X75 + SQR(X51) == 0)
@constraint(model, E21, - X65 + X13*X49 == 0)
@constraint(model, E22, - X56 + X12*X13 == 0)
@constraint(model, E23, - X74 + SQR(X50) == 0)
@constraint(model, E24, - X48 + X10*X12 == 0)
@constraint(model, E25, - X73 + SQR(X48) == 0)
@constraint(model, E26, - X72 + SQR(X47) == 0)
@constraint(model, E27, - X46 + SQR(X10) == 0)
@constraint(model, E28, - X71 + SQR(X46) == 0)
@constraint(model, E29, - X44 + X9*X12 == 0)
@constraint(model, E30, - X69 + X44*X54 == 0)
@constraint(model, E31, - X58 + SQR(X13) == 0)
@constraint(model, E32, - X42 + X9*X10 == 0)
@constraint(model, E33, - X76 + X51*X55 == 0)
@constraint(model, E34, - X70 + X44*X59 == 0)
@constraint(model, E35, - X52 + X11*X12 == 0)
@constraint(model, E36, - X68 + SQR(X44) == 0)
@constraint(model, E37, - X62 + X9*X51 == 0)
@constraint(model, E38, - X61 + X9*X50 == 0)
@constraint(model, E39, - X67 + SQR(X42) == 0)
@constraint(model, E40, - X45 + X9*X14 == 0)
@constraint(model, E41, - X43 + X9*X11 == 0)
@constraint(model, E42, - X57 + X12*X14 == 0)
@constraint(model, E43, - X80 + SQR(X57) == 0)
@constraint(model, E44, - X79 + X55*X58 == 0)
@constraint(model, E45, - X64 + X10*X56 == 0)
@constraint(model, E46, - X63 + X9*X53 == 0)
@constraint(model, E47, - X60 + X9*X48 == 0)
@constraint(model, E48, - X41 + SQR(X9) == 0)
@constraint(model, E49, - X66 + SQR(X41) == 0)
@constraint(model, E50, objvar == X0)
@objective(model, Min, objvar)
optimize!(model)
