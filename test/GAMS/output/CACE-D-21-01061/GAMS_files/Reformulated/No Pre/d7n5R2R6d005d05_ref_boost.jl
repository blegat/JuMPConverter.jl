using JuMP
model = Model()
@variable(model, objvar)
@variable(model, 0 <= X3 <= 0)
@variable(model, 0.28 <= X8 <= 2.41)
@variable(model, 1.706864111498257 <= X12 <= 1.803344947735192)
@variable(model, 0 <= X4 <= 0)
@variable(model, 1.647847251128311 <= X11 <= 1.75248686948998)
@variable(model, 0 <= X5 <= 21.37183676542806)
@variable(model, 1.100230699192335 <= X9 <= 2.62)
@variable(model, 0.83 <= X10 <= 2.54)
@variable(model, 0 <= X6 <= 6.635276286509374)
@variable(model, 0 <= X7 <= 9.724685772279779)
@variable(model, 804.7656699603151 <= X0 <= 48427.88326403893)
@variable(model, 7.911007527675614 <= X80 <= 9.987738436338908)
@variable(model, 3.526674774447103 <= X77 <= 22.32339261678351)
@variable(model, 2.264423252522869 <= X85 <= 136.012731117624)
@variable(model, 0.0004818903040000001 <= X82 <= 195.9305941454412)
@variable(model, 0.6202229901697681 <= X84 <= 58.00978361210004)
@variable(model, 1.382643650408553 <= X88 <= 135.3606656534047)
@variable(model, 0.3269403733689997 <= X86 <= 268.5358665400962)
@variable(model, 1.288683515648612 <= X87 <= 127.8334211407353)
@variable(model, 3.28701299538811 <= X76 <= 21.0820154872627)
@variable(model, 0.06537922449213621 <= X83 <= 257.2196251726241)
@variable(model, 21.48155429495209 <= X89 <= 30.67444443762394)
@variable(model, 3.094565343991282 <= X66 <= 8.280086456215589)
@variable(model, 0.3080645957738538 <= X47 <= 6.314200000000001)
@variable(model, 0.4613972303159271 <= X49 <= 4.223493355470852)
@variable(model, 0.3829597011622194 <= X61 <= 10.72767312289597)
@variable(model, 0.477921951219512 <= X50 <= 4.346061324041813)
@variable(model, 0.2284093914574656 <= X74 <= 18.88824903233208)
@variable(model, 1.210507591445254 <= X51 <= 6.864400000000001)
@variable(model, 8.487812712471651 <= X81 <= 10.57584871820442)
@variable(model, 0.9131914803296379 <= X52 <= 6.654800000000001)
@variable(model, 1.46532862894659 <= X75 <= 47.11998736000001)
@variable(model, 1.813012133271068 <= X53 <= 4.591515598063748)
@variable(model, 0.006146560000000001 <= X72 <= 33.73402561000002)
@variable(model, 0.6888999999999998 <= X54 <= 6.451600000000001)
@variable(model, 2.334500607371035 <= X70 <= 8.027259388850227)
@variable(model, 1.367713218436498 <= X55 <= 4.45131664850455)
@variable(model, 1.416697212543553 <= X56 <= 4.580496167247388)
@variable(model, 2.007030992028673 <= X79 <= 20.98094513816801)
@variable(model, 2.81265133418197 <= X58 <= 3.160338342067018)
@variable(model, 0.2556936144922986 <= X60 <= 16.03806800000001)
@variable(model, 1.175858686411149 <= X69 <= 11.63446026480837)
@variable(model, 0.05400975999999999 <= X73 <= 37.47153796000002)
@variable(model, 1.870639447885923 <= X78 <= 19.81421990525378)
@variable(model, 0.7579489286735993 <= X63 <= 16.903192)
@variable(model, 1.504800070614987 <= X64 <= 11.66244961908192)
@variable(model, 1.558693764700626 <= X65 <= 12.00089995818816)
@variable(model, -0 <= X1 <= 73.36238901464318)
@variable(model, -0 <= X2 <= 923.3389741267603)
@variable(model, 2.71540056305113 <= X57 <= 3.07121022773479)
@variable(model, 4.634819769414134 <= X71 <= 5.538451447618182)
@variable(model, 2.913385095120735 <= X59 <= 3.252053000522042)
@variable(model, 1.135201971302293 <= X68 <= 11.30634428720156)
@variable(model, 0.5717869999999998 <= X67 <= 16.38706400000001)
@variable(model, 0.7875423735709516 <= X62 <= 7.616415404381514)
@variable(model, 0.2324 <= X48 <= 6.121400000000001)
@variable(model, 0.07840000000000001 <= X46 <= 5.808100000000001)
@constraint(model, E1, - X3 + 0.13*X8 + 2.87*X12 == 5.212)
@constraint(model, E2, - X4 + 7.45*X11 - 8.08*X12 == -1.515)
@constraint(
    model,
    E3,
    - X5 - 7.4*X8 + 9.61*X9 + 3.78*X10 + 4.65*X11 + 3.4*X12 == 25.616
)
@constraint(
    model,
    E4,
    - X6 + 0.66*X8 + 3.97*X9 + 1.69*X10 - 4.63*X11 + 3.65*X12 == 8.602
)
@constraint(
    model,
    E5,
    - X7 + 1.28*X8 + 4.79*X9 + 3.6*X10 + 1.13*X11 + 6.51*X12 == 28.774
)
@constraint(
    model,
    E6,
    - X0 +
    0.04*X8 +
    5.06*X9 +
    6.81*X10 +
    5.18*X11 +
    0.04*X12 +
    9.77*X80 +
    2.14*X8*X77 +
    0.68*X8*X85 +
    8.14*X9*X82 +
    2.63*X9*X84 +
    7.56*X9*X88 +
    6.62*X10*X82 +
    8.72*X10*X86 +
    2.77*X10*X87 +
    7.85*X11*X76 +
    6.91*X11*X83 +
    7.18*X11*X89 +
    8.81*X12*X66 +
    0.92*X47*X77 +
    0.96*X49*X61 +
    3.55*X50*X74 +
    7.94*X51*X81 - 1.37*X52*X75 +
    9.03*X52*X76 +
    6.04*X52*X81 +
    5.54*X53*X72 +
    2.28*X54*X70 +
    9.68*X54*X81 +
    5.5*X55*X74 +
    2.47*X55*X80 +
    0.23*X56*X79 +
    6.68*X58*X75 +
    2.42*X58*X81 +
    7.75*X60*X69 +
    8.87*X60*X72 +
    2.36*X61*X73 +
    2.93*X61*X76 +
    7.25*X61*X78 +
    10*SQR(X63) +
    9.48*X64*X72 +
    9.84*X65*X74 +
    9.66*X66*X80 +
    2.18*X70*X75 +
    8.87*X70*X81 == 0
)
@constraint(
    model,
    E7,
    - X1 +
    2.19*X8 +
    3.87*X9 +
    7.24*X10 +
    7.42*X11 +
    7.41*X12 +
    4.04*X80 +
    8.47*X12*X66 == 153.634
)
@constraint(
    model,
    E8,
    - X2 - 5.38*X8 +
    8.55*X9 +
    4.63*X10 +
    4.02*X11 +
    8.14*X12 +
    4.81*X80 +
    9*X8*X77 +
    4.51*X11*X76 +
    4.04*X12*X66 +
    8.88*X49*X61 - 3.85*X54*X70 == 286.372
)
@constraint(model, E9, - X57 + SQR(X11) == 0)
@constraint(model, E10, - X71 + X12*X57 == 0)
@constraint(model, E11, - X89 + SQR(X71) == 0)
@constraint(model, E12, - X55 + X10*X11 == 0)
@constraint(model, E13, - X70 + X12*X55 == 0)
@constraint(model, E14, - X59 + SQR(X12) == 0)
@constraint(model, E15, - X81 + SQR(X59) == 0)
@constraint(model, E16, - X68 + X10*X55 == 0)
@constraint(model, E17, - X87 + SQR(X68) == 0)
@constraint(model, E18, - X54 + SQR(X10) == 0)
@constraint(model, E19, - X67 + X10*X54 == 0)
@constraint(model, E20, - X86 + SQR(X67) == 0)
@constraint(model, E21, - X53 + X9*X11 == 0)
@constraint(model, E22, - X66 + X12*X53 == 0)
@constraint(model, E23, - X80 + X12*X71 == 0)
@constraint(model, E24, - X69 + X12*X54 == 0)
@constraint(model, E25, - X88 + SQR(X69) == 0)
@constraint(model, E26, - X51 + SQR(X9) == 0)
@constraint(model, E27, - X75 + SQR(X51) == 0)
@constraint(model, E28, - X61 + X8*X55 == 0)
@constraint(model, E29, - X78 + X11*X68 == 0)
@constraint(model, E30, - X76 + X51*X57 == 0)
@constraint(model, E31, - X85 + X51*X78 == 0)
@constraint(model, E32, - X49 + X8*X11 == 0)
@constraint(model, E33, - X62 + X12*X49 == 0)
@constraint(model, E34, - X84 + SQR(X62) == 0)
@constraint(model, E35, - X52 + X9*X10 == 0)
@constraint(model, E36, - X65 + X12*X52 == 0)
@constraint(model, E37, - X50 + X8*X12 == 0)
@constraint(model, E38, - X74 + SQR(X50) == 0)
@constraint(model, E39, - X60 + X8*X52 == 0)
@constraint(model, E40, - X83 + SQR(X60) == 0)
@constraint(model, E41, - X48 + X8*X10 == 0)
@constraint(model, E42, - X73 + SQR(X48) == 0)
@constraint(model, E43, - X64 + X9*X55 == 0)
@constraint(model, E44, - X46 + SQR(X8) == 0)
@constraint(model, E45, - X72 + SQR(X46) == 0)
@constraint(model, E46, - X82 + X46*X72 == 0)
@constraint(model, E47, - X58 + X11*X12 == 0)
@constraint(model, E48, - X56 + X10*X12 == 0)
@constraint(model, E49, - X79 + X12*X69 == 0)
@constraint(model, E50, - X63 + X9*X54 == 0)
@constraint(model, E51, - X47 + X8*X9 == 0)
@constraint(model, E52, - X77 + X51*X59 == 0)
@constraint(model, E53, objvar == X0)
@objective(model, Min, objvar)
optimize!(model)
