using JuMP
model = Model()
@variable(model, objvar)
@variable(model, 0 <= X5 <= 0)
@variable(model, 1.35254440310671 <= X9 <= 1.864424623097413)
@variable(model, 0.91 <= X10 <= 2.533894251722512)
@variable(model, 0.8100000000000001 <= X11 <= 2.222935418512717)
@variable(model, 1.292770851647575 <= X12 <= 2.48)
@variable(model, 0.9745781972677103 <= X13 <= 2.6)
@variable(model, 1.281449451730913 <= X14 <= 1.722938720531004)
@variable(model, 0 <= X6 <= 0)
@variable(model, 0 <= X7 <= 0)
@variable(model, 0 <= X8 <= 27.71787410246049)
@variable(model, -2557.965870365947 <= X0 <= 15924.61728769911)
@variable(model, 1.733217283802807 <= X64 <= 3.212289374645955)
@variable(model, 0.8868661595136164 <= X67 <= 6.588125054478532)
@variable(model, 1.383967486839513 <= X89 <= 39.48938173334276)
@variable(model, 0.9286769234687841 <= X91 <= 36.31954178247456)
@variable(model, 1.403905999880274 <= X80 <= 7.140711825412563)
@variable(model, 1.07739014072573 <= X93 <= 14.66875833473444)
@variable(model, 1.829376362375285 <= X59 <= 3.47607917521193)
@variable(model, 1.230815406827106 <= X60 <= 4.724254835236446)
@variable(model, 1.166119001075131 <= X68 <= 4.365744520023649)
@variable(model, 1.671256474869597 <= X72 <= 6.1504)
@variable(model, 0.94980266258958 <= X75 <= 6.760000000000001)
@variable(model, 0.6231655269250234 <= X92 <= 33.40414707417739)
@variable(model, 1.095560966516435 <= X61 <= 4.144495529830463)
@variable(model, 1.814928755098363 <= X87 <= 17.70896532702316)
@variable(model, 1.559683012207073 <= X98 <= 20.06718056260588)
@variable(model, 1.748529979895422 <= X62 <= 4.623773065281584)
@variable(model, 2.696534110770035 <= X99 <= 8.812098134961735)
@variable(model, 1.318160286104268 <= X63 <= 4.847504020053274)
@variable(model, 1.248872696557609 <= X76 <= 4.47964067338061)
@variable(model, 1.514906565682973 <= X83 <= 22.31858374825493)
@variable(model, 1.35983352466846 <= X90 <= 19.05972521411653)
@variable(model, 0.9021250978622555 <= X97 <= 45.69760000000002)
@variable(model, 0.7371 <= X65 <= 5.632683278919751)
@variable(model, 2.744391477897488 <= X96 <= 18.25757209056971)
@variable(model, 1.176421474999293 <= X66 <= 6.28405774427183)
@variable(model, 1.200253831354424 <= X84 <= 17.17684319678469)
@variable(model, 3.057357090593085 <= X85 <= 21.37927735922346)
@variable(model, 2.793098204793552 <= X94 <= 37.82742016000001)
@variable(model, 1.587363849701219 <= X95 <= 41.57670400000001)
@variable(model, 0.54331641 <= X88 <= 31.72712092062216)
@variable(model, 0.7183615892060292 <= X81 <= 14.64497652519136)
@variable(model, 0.6561 <= X69 <= 4.94144187487831)
@variable(model, 0.7894083397868453 <= X70 <= 5.779632088133067)
@variable(model, 1.416309283715292 <= X79 <= 10.27834891397955)
@variable(model, 1.037974055902039 <= X71 <= 3.829981505795353)
@variable(model, 1.65662049905749 <= X74 <= 4.272888026916889)
@variable(model, 3.34661787521743 <= X82 <= 12.08312643234205)
@variable(model, 3.004042152872781 <= X86 <= 10.3188030264633)
@variable(model, 1.259906286078937 <= X73 <= 6.448)
@variable(model, 1.642112697341457 <= X77 <= 2.968517834705012)
@variable(model, 0.8874043828783121 <= X78 <= 9.212945905127768)
@variable(model, 0 <= X1 <= 53.90354022629217)
@variable(model, 0 <= X2 <= 34.80751214081467)
@variable(model, -0 <= X3 <= 651.8705538219239)
@variable(model, -0 <= X4 <= 1645.362778817975)
@constraint(
    model,
    E1,
    - X5 + 8.99*X9 + 6.15*X10 + 0.11*X11 + 2.4*X12 + 0.78*X13 + 9.31*X14 ==
    44.2605
)
@constraint(
    model,
    E2,
    - X6 + 8.58*X9 + 4.37*X10 + 6.66*X11 + 8.75*X12 + 4.47*X13 + 0.53*X14 ==
    54.3081
)
@constraint(
    model,
    E3,
    - X7 + 5.8*X9 + 6.69*X10 + 4.03*X11 + 5.48*X12 + 4.16*X13 + 9.53*X14 ==
    57.4284
)
@constraint(
    model,
    E4,
    - X8 - 7.6*X9 + 8.56*X10 + 1.3*X11 + 8.96*X12 + 9.79*X13 + 1.62*X14 ==
    37.0487
)
@constraint(
    model,
    E5,
    - X0 + 0.19*X9 + 2.94*X10 - 2*X11 +
    2.54*X12 +
    1.96*X13 +
    6.12*X14 +
    4.14*X64 +
    8.23*X67 +
    1.63*X89 +
    4.47*X12*X91 +
    4.56*X14*X80 +
    2.66*X14*X93 +
    4.2*X59*X80 +
    1.95*X60*X68 +
    2.28*X60*X72 +
    9.47*X60*X75 +
    7.51*X60*X92 - 2.79*X60*X93 +
    5.68*X61*X87 +
    2.17*X61*X98 +
    3.37*X62*X99 +
    9.75*X63*X76 +
    8.77*X63*X83 +
    3.99*X64*X90 +
    3.5*X64*X92 - 5.06*X64*X97 +
    1.28*X65*X89 +
    0.79*X65*X93 +
    9.01*X65*X96 +
    0.64*X65*X99 +
    7.17*X66*X84 +
    5.1*X66*X85 +
    0.01*X66*X94 +
    2.52*X66*X95 +
    0.33*X67*X88 +
    5.88*X68*X81 +
    3.82*X68*X95 +
    4.24*X69*X70 +
    5.71*X69*X79 +
    7.81*X71*X74 +
    2.92*X71*X82 +
    7.57*X71*X86 +
    0.97*X72*X87 +
    7.72*X73*X85 +
    7.08*X73*X87 +
    2.44*X74*X77 +
    8.28*X75*X91 +
    3.22*X76*X83 +
    8.8*X77*X81 - 7.79*X77*X87 + 9.16*SQR(X78) - 7.36*SQR(X81) == 0
)
@constraint(
    model,
    E6,
    - X1 +
    7.74*X9 +
    7.47*X10 +
    3.42*X11 +
    0.13*X12 +
    0.66*X13 +
    5.54*X14 +
    8.12*X64 +
    8.59*X67 == 81.317
)
@constraint(
    model,
    E7,
    - X2 +
    1.44*X9 +
    4.53*X10 +
    8.39*X11 +
    7.97*X12 +
    2.43*X13 +
    7.32*X14 +
    4.92*X64 - 7.37*X67 == 45.97
)
@constraint(
    model,
    E8,
    - X3 +
    1.4*X9 +
    8.03*X10 +
    2.12*X11 +
    1.81*X12 +
    2.22*X13 +
    8.02*X14 +
    1.9*X64 +
    6.4*X67 +
    6.94*X89 +
    6.62*X14*X80 +
    1.74*X60*X68 +
    8.08*X60*X72 - 3.71*X60*X75 +
    2.96*X63*X76 +
    0.85*X69*X70 +
    5*X71*X74 +
    4.46*X74*X77 == 296.92
)
@constraint(
    model,
    E9,
    - X4 +
    5.98*X9 +
    2.97*X10 +
    3.88*X11 +
    6.07*X12 +
    0.2*X13 +
    4.92*X14 +
    4.62*X64 +
    0.76*X67 +
    9.85*X89 +
    5.76*X12*X91 +
    2.8*X14*X80 +
    0.86*X14*X93 +
    4.91*X59*X80 +
    5.47*X60*X68 +
    1.7*X60*X72 +
    2.83*X60*X75 +
    1.98*X63*X76 +
    5.4*X68*X81 +
    0.08*X69*X70 +
    1.7*X69*X79 +
    2.21*X71*X74 - 3.98*X74*X77 + 5.25*X77*X81 == 494.73
)
@constraint(model, E10, - X68 + X10*X14 == 0)
@constraint(model, E11, - X73 + X12*X13 == 0)
@constraint(model, E12, - X95 + SQR(X73) == 0)
@constraint(model, E13, - X66 + X10*X12 == 0)
@constraint(model, E14, - X72 + SQR(X12) == 0)
@constraint(model, E15, - X94 + SQR(X72) == 0)
@constraint(model, E16, - X65 + X10*X11 == 0)
@constraint(model, E17, - X77 + SQR(X14) == 0)
@constraint(model, E18, - X99 + SQR(X77) == 0)
@constraint(model, E19, - X91 + X65*X73 == 0)
@constraint(model, E20, - X75 + SQR(X13) == 0)
@constraint(model, E21, - X96 + X72*X77 == 0)
@constraint(model, E22, - X71 + X11*X14 == 0)
@constraint(model, E23, - X93 + SQR(X71) == 0)
@constraint(model, E24, - X81 + X13*X65 == 0)
@constraint(model, E25, - X89 + SQR(X66) == 0)
@constraint(model, E26, - X67 + X10*X13 == 0)
@constraint(model, E27, - X88 + SQR(X65) == 0)
@constraint(model, E28, - X64 + X9*X14 == 0)
@constraint(model, E29, - X97 + SQR(X75) == 0)
@constraint(model, E30, - X62 + X9*X12 == 0)
@constraint(model, E31, - X61 + X9*X11 == 0)
@constraint(model, E32, - X98 + X75*X77 == 0)
@constraint(model, E33, - X87 + X62*X71 == 0)
@constraint(model, E34, - X70 + X11*X13 == 0)
@constraint(model, E35, - X92 + SQR(X70) == 0)
@constraint(model, E36, - X60 + X9*X10 == 0)
@constraint(model, E37, - X90 + SQR(X68) == 0)
@constraint(model, E38, - X85 + SQR(X62) == 0)
@constraint(model, E39, - X86 + SQR(X64) == 0)
@constraint(model, E40, - X78 + X11*X61 == 0)
@constraint(model, E41, - X84 + X9*X78 == 0)
@constraint(model, E42, - X76 + X13*X14 == 0)
@constraint(model, E43, - X83 + SQR(X60) == 0)
@constraint(model, E44, - X63 + X9*X13 == 0)
@constraint(model, E45, - X59 + SQR(X9) == 0)
@constraint(model, E46, - X82 + SQR(X59) == 0)
@constraint(model, E47, - X79 + X11*X62 == 0)
@constraint(model, E48, - X69 + SQR(X11) == 0)
@constraint(model, E49, - X80 + X9*X71 == 0)
@constraint(model, E50, - X74 + X12*X14 == 0)
@constraint(model, E51, objvar == X0)
@objective(model, Min, objvar)
optimize!(model)
