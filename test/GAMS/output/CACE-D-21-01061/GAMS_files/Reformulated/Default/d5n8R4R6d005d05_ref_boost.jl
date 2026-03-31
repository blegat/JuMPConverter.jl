using JuMP
model = Model()
@variable(model, objvar)
@variable(model, 0 <= X5 <= 0)
@variable(model, 0.19 <= X11 <= 2.35)
@variable(model, 0.36 <= X14 <= 2.4)
@variable(model, 1.356162348895857 <= X15 <= 2.081689464806555)
@variable(model, 0.5600000000000001 <= X16 <= 2.81)
@variable(model, 0 <= X6 <= 0)
@variable(model, 0.12 <= X10 <= 2.55)
@variable(model, 0.59 <= X12 <= 2.3)
@variable(model, 1.306733728043528 <= X13 <= 1.73748420538551)
@variable(model, 0 <= X7 <= 0)
@variable(model, 0.85 <= X17 <= 2.058318405053106)
@variable(model, 0 <= X8 <= 0)
@variable(model, 0 <= X9 <= 24.69412706474178)
@variable(model, -1946.18595604157 <= X0 <= 14517.94994941231)
@variable(model, 0.004515839999999999 <= X108 <= 51.34439025)
@variable(model, 0.102 <= X68 <= 5.248711932885421)
@variable(model, 0.09601629430182668 <= X92 <= 12.20910871109045)
@variable(model, 0.3480999999999999 <= X73 <= 5.29)
@variable(model, 0.3059999999999999 <= X83 <= 4.939964172127456)
@variable(model, 0.013452 <= X89 <= 13.78275)
@variable(model, 0.5943992118338753 <= X112 <= 15.96972371537018)
@variable(model, 3.382569523405248 <= X115 <= 18.77862447345035)
@variable(model, 3.140491103098007 <= X114 <= 13.0819841691799)
@variable(model, 0.00130321 <= X109 <= 30.49800625000001)
@variable(model, 0.01256641 <= X110 <= 29.21402500000001)
@variable(model, 0.0002073599999999999 <= X107 <= 42.28250625)
@variable(model, 0.02608224999999999 <= X111 <= 23.39703579096507)
@variable(model, 0.5767656928740719 <= X116 <= 34.21720473929541)
@variable(model, 0.7224999999999999 <= X88 <= 4.236674656580364)
@variable(model, 2.915737370775141 <= X113 <= 9.113463557708013)
@variable(model, 0.0144 <= X61 <= 6.5025)
@variable(model, 1.772143082004952 <= X79 <= 3.616902565618806)
@variable(model, 0.4882184456025086 <= X81 <= 4.996054715535733)
@variable(model, 0.03671999999999999 <= X94 <= 12.59690863892501)
@variable(model, 0.1383285595873774 <= X96 <= 10.92618833449204)
@variable(model, 0.6455332780744281 <= X106 <= 12.04023106663632)
@variable(model, 0.0228 <= X62 <= 5.992500000000001)
@variable(model, 0.2482794083282703 <= X70 <= 4.083087882655949)
@variable(model, 0.2576708462902129 <= X71 <= 4.891970242295406)
@variable(model, 1.707553036006537 <= X77 <= 3.018851363964117)
@variable(model, 0.4480760400751913 <= X101 <= 13.45395901104477)
@variable(model, 0.2634375195735753 <= X103 <= 11.71759348111988)
@variable(model, 0.1568080473652234 <= X64 <= 4.430584723733051)
@variable(model, 0.3304 <= X76 <= 6.463)
@variable(model, 0.3136 <= X86 <= 7.896100000000001)
@variable(model, 0.0672 <= X67 <= 7.1655)
@variable(model, 0.0361 <= X69 <= 5.522500000000001)
@variable(model, 0.6801154179712724 <= X102 <= 9.854993399737914)
@variable(model, 0.02548799999999999 <= X91 <= 14.076)
@variable(model, 0.2124 <= X74 <= 5.52)
@variable(model, 1.839176316562729 <= X84 <= 4.333431027886603)
@variable(model, 0.2110374970790297 <= X98 <= 8.40429493832006)
@variable(model, 0.3998605207813195 <= X104 <= 8.583109724241762)
@variable(model, 0.06017999999999998 <= X93 <= 12.07203744563647)
@variable(model, 0.4704241420956701 <= X78 <= 4.169962092925224)
@variable(model, 0.118944 <= X100 <= 15.5112)
@variable(model, 0.0911341098458016 <= X95 <= 14.91634586007137)
@variable(model, 1.110723668836999 <= X80 <= 3.576295718434067)
@variable(model, 0.2016 <= X82 <= 6.744000000000001)
@variable(model, 0.008207999999999998 <= X90 <= 14.382)
@variable(model, 0.09276150466447662 <= X99 <= 11.74072858150898)
@variable(model, 0.4149856787621323 <= X105 <= 10.28347137363956)
@variable(model, 0.476 <= X87 <= 5.78387471819923)
@variable(model, 0.3367071855809408 <= X97 <= 8.499721029204196)
@variable(model, 0 <= X1 <= 42.47449961083114)
@variable(model, -0 <= X2 <= 230.9801088299335)
@variable(model, -0 <= X3 <= 2661.752438748217)
@variable(model, -0 <= X4 <= 11549.70579585863)
@variable(model, 0.1627394818675029 <= X66 <= 5.308308135256716)
@variable(model, 0.7594509153816802 <= X85 <= 5.849547396106421)
@variable(model, 0.1615 <= X72 <= 4.837048251874801)
@variable(model, 0.8001357858485558 <= X75 <= 4.787885769055078)
@variable(model, 0.07079999999999999 <= X63 <= 5.864999999999999)
@variable(model, 0.0432 <= X65 <= 6.12)
@constraint(
    model,
    E1,
    - X5 + 2.69*X11 + 1.79*X14 - 8.65*X15 + 0.81*X16 == -6.589
)
@constraint(
    model,
    E2,
    - X6 + 2.4*X10 + 3.94*X12 + 7.91*X13 + 0.11*X15 == 21.176
)
@constraint(
    model,
    E3,
    - X7 + 2.11*X10 + 1.62*X14 + 1.89*X16 + 5.61*X17 == 17.297
)
@constraint(
    model,
    E4,
    - X8 + 0.18*X10 + 9.19*X13 + 5.29*X15 + 2.12*X17 == 26.189
)
@constraint(
    model,
    E5,
    - X9 +
    4.88*X10 +
    2.18*X11 +
    3.54*X12 +
    5.27*X13 +
    5.34*X14 +
    8.17*X15 +
    0.8*X16 +
    4.53*X17 == 51.567
)
@constraint(
    model,
    E6,
    - X0 + 5.17*X10 + 4.42*X11 + 0.65*X12 + 5.08*X13 + 3.03*X14 + 4.17*X15 -
    4.16*X16 +
    4.72*X17 +
    8.19*X108 +
    8.82*X10*X68 +
    9.45*X11*X12 +
    1.01*X11*X92 +
    9.32*X11*X108 +
    5.96*X12*X73 +
    7.73*X12*X83 +
    4.09*X12*X89 +
    2.61*X12*X112 +
    7.58*X12*X115 +
    8.29*X13*X16 +
    0.84*X13*X114 +
    7.67*X14*X109 +
    0.7*X14*X110 - 2.11*X15*X107 +
    1.03*X15*X111 +
    6.84*X15*X116 +
    0.11*X16*X88 +
    3.29*X17*X111 +
    7.82*X17*X113 +
    6.15*X61*X79 +
    7.43*X61*X81 - 2.47*X61*X94 +
    9.25*X61*X96 +
    4.68*X61*X106 +
    8.5*X62*X70 +
    0.34*X62*X71 +
    3.62*X62*X77 +
    7.16*X62*X101 +
    2.21*X62*X103 +
    9.22*X64*X76 +
    5.33*X64*X86 +
    4.85*X64*X106 +
    6.09*X67*X77 +
    8.73*X68*X88 +
    1.46*X69*X71 +
    3.75*X69*X77 - 4.6*X69*X83 - 8.05*X69*X92 +
    7.19*X69*X102 +
    7.25*X70*X91 +
    8.76*X73*X89 +
    8.22*X73*X103 +
    8.44*X74*X84 +
    0.23*X74*X98 +
    0.07*X76*X86 +
    7.97*X76*X104 +
    3.33*X77*X93 +
    7.81*X77*X101 +
    7.11*X78*X100 +
    0.64*X79*X95 +
    8.93*X80*X88 +
    8.2*X82*X86 +
    5.95*X84*X90 +
    1.44*X84*X98 +
    2.16*X84*X99 +
    1.86*X84*X100 +
    3.84*X84*X106 +
    9.94*X86*X95 +
    8.29*X86*X104 - 5.05*X86*X105 + 3.06*X87*X88 - 9.63*X88*X91 +
    3.98*X88*X97 == 0
)
@constraint(
    model,
    E7,
    - X1 +
    3.24*X10 +
    6.36*X11 +
    0.32*X12 +
    0.65*X13 +
    6.93*X14 +
    7.58*X15 +
    0.82*X16 +
    4.06*X17 - 7.72*X11*X12 + 1.96*X13*X16 == 34.375
)
@constraint(
    model,
    E8,
    - X2 +
    7.36*X10 +
    4.89*X11 +
    7*X12 +
    2.6*X13 +
    4.09*X14 +
    7.27*X15 +
    4.52*X16 +
    0.42*X17 +
    7.96*X10*X68 +
    8.13*X11*X12 +
    0.31*X12*X73 - 4.81*X12*X83 +
    4.84*X13*X16 +
    7.46*X16*X88 == 124.239
)
@constraint(
    model,
    E9,
    - X3 +
    3.76*X10 +
    8.5*X11 +
    4.09*X12 +
    9.26*X13 +
    9.21*X14 +
    1.22*X15 +
    8.27*X16 +
    7.9*X17 - 7.21*X108 +
    0.93*X10*X68 +
    5.75*X11*X12 +
    3.13*X11*X92 - 5.06*X12*X73 +
    3.51*X12*X83 +
    3.53*X12*X89 +
    4.54*X13*X16 +
    5.55*X16*X88 +
    7.13*X61*X79 +
    8.18*X61*X81 +
    4.71*X62*X70 +
    4.84*X62*X71 +
    9.49*X62*X77 +
    7.66*X64*X76 - 7.54*X64*X86 +
    0.38*X67*X77 +
    9.26*X68*X88 +
    8.75*X69*X71 +
    6.6*X69*X77 +
    6.17*X69*X83 +
    1.42*X74*X84 +
    6.01*X76*X86 +
    5.35*X80*X88 +
    5.08*X82*X86 +
    8.79*X87*X88 == 547.466
)
@constraint(
    model,
    E10,
    - X4 +
    8.56*X10 +
    3.12*X11 +
    2.74*X12 +
    8.2*X13 +
    4.41*X14 +
    8.98*X15 +
    3.33*X16 +
    0.46*X17 +
    2*X108 +
    1.3*X10*X68 +
    9.43*X11*X12 +
    8.48*X11*X92 +
    3.16*X11*X108 - 1.38*X12*X73 +
    7.5*X12*X83 +
    3.48*X12*X89 +
    9.98*X12*X112 +
    4.61*X12*X115 +
    5.07*X13*X16 +
    9.37*X13*X114 +
    7.65*X14*X109 +
    4.67*X14*X110 - 8.99*X15*X107 +
    8.85*X15*X111 +
    3.5*X15*X116 +
    8.39*X16*X88 - 1.17*X17*X111 - 6.03*X17*X113 +
    7.22*X61*X79 +
    4.27*X61*X81 +
    6.72*X61*X94 - 7.63*X61*X96 +
    4.68*X61*X106 +
    3.81*X62*X70 +
    4.83*X62*X71 +
    8.27*X62*X77 +
    4.61*X62*X101 +
    3.93*X62*X103 +
    9.36*X64*X76 +
    8.63*X64*X86 +
    4.08*X64*X106 +
    1.56*X66*X99 +
    9.31*X67*X77 +
    6.36*X68*X88 +
    7.11*X69*X71 +
    4.2*X69*X77 +
    5.46*X69*X83 +
    2.33*X69*X92 +
    7.43*X69*X102 +
    6.71*X70*X91 +
    9.83*X73*X89 +
    5.29*X73*X103 +
    7.04*X74*X84 +
    1.31*X74*X98 +
    9.79*X74*X103 +
    6.28*X76*X86 +
    4.12*X76*X104 +
    1.35*X77*X93 - 1.67*X77*X101 +
    0.13*X79*X95 +
    10*X80*X88 +
    5.3*X81*X101 - 9.71*X82*X86 - 0.86*X82*X106 +
    7.71*X83*X93 +
    4.3*X84*X98 +
    7.61*X84*X99 +
    3.39*X84*X106 +
    3.01*X86*X95 +
    1.28*X86*X104 +
    1.64*X87*X88 +
    2.65*X88*X97 == 1605.09
)
@constraint(model, E11, - X85 + X15*X16 == 0)
@constraint(model, E12, - X106 + X17*X85 == 0)
@constraint(model, E13, - X84 + SQR(X15) == 0)
@constraint(model, E14, - X116 + SQR(X85) == 0)
@constraint(model, E15, - X81 + X14*X15 == 0)
@constraint(model, E16, - X105 + X17*X81 == 0)
@constraint(model, E17, - X86 + SQR(X16) == 0)
@constraint(model, E18, - X78 + X13*X14 == 0)
@constraint(model, E19, - X104 + X17*X78 == 0)
@constraint(model, E20, - X79 + X13*X15 == 0)
@constraint(model, E21, - X114 + SQR(X79) == 0)
@constraint(model, E22, - X77 + SQR(X13) == 0)
@constraint(model, E23, - X113 + SQR(X77) == 0)
@constraint(model, E24, - X115 + SQR(X84) == 0)
@constraint(model, E25, - X74 + X12*X14 == 0)
@constraint(model, E26, - X100 + X16*X74 == 0)
@constraint(model, E27, - X76 + X12*X16 == 0)
@constraint(model, E28, - X101 + X12*X85 == 0)
@constraint(model, E29, - X103 + X16*X78 == 0)
@constraint(model, E30, - X73 + SQR(X12) == 0)
@constraint(model, E31, - X112 + X73*X77 == 0)
@constraint(model, E32, - X99 + X11*X81 == 0)
@constraint(model, E33, - X97 + X11*X79 == 0)
@constraint(model, E34, - X88 + SQR(X17) == 0)
@constraint(model, E35, - X70 + X11*X13 == 0)
@constraint(model, E36, - X98 + X17*X70 == 0)
@constraint(model, E37, - X72 + X11*X17 == 0)
@constraint(model, E38, - X111 + SQR(X72) == 0)
@constraint(model, E39, - X75 + X12*X15 == 0)
@constraint(model, E40, - X102 + X17*X75 == 0)
@constraint(model, E41, - X69 + SQR(X11) == 0)
@constraint(model, E42, - X110 + X69*X73 == 0)
@constraint(model, E43, - X109 + SQR(X69) == 0)
@constraint(model, E44, - X95 + X10*X85 == 0)
@constraint(model, E45, - X64 + X10*X13 == 0)
@constraint(model, E46, - X91 + X10*X74 == 0)
@constraint(model, E47, - X63 + X10*X12 == 0)
@constraint(model, E48, - X93 + X17*X63 == 0)
@constraint(model, E49, - X62 + X10*X11 == 0)
@constraint(model, E50, - X90 + X14*X62 == 0)
@constraint(model, E51, - X89 + X11*X63 == 0)
@constraint(model, E52, - X92 + X10*X75 == 0)
@constraint(model, E53, - X61 + SQR(X10) == 0)
@constraint(model, E54, - X108 + X61*X86 == 0)
@constraint(model, E55, - X66 + X10*X15 == 0)
@constraint(model, E56, - X96 + X17*X66 == 0)
@constraint(model, E57, - X65 + X10*X14 == 0)
@constraint(model, E58, - X94 + X17*X65 == 0)
@constraint(model, E59, - X107 + SQR(X61) == 0)
@constraint(model, E60, - X87 + X16*X17 == 0)
@constraint(model, E61, - X82 + X14*X16 == 0)
@constraint(model, E62, - X80 + X13*X17 == 0)
@constraint(model, E63, - X83 + X14*X17 == 0)
@constraint(model, E64, - X71 + X11*X15 == 0)
@constraint(model, E65, - X68 + X10*X17 == 0)
@constraint(model, E66, - X67 + X10*X16 == 0)
@constraint(model, E67, objvar == X0)
@objective(model, Min, objvar)
optimize!(model)
