using JuMP
model = Model()
@variable(model, objvar)
@variable(model, 0 <= X5 <= 0)
@variable(model, 0.11 <= X10 <= 2.14)
@variable(model, 0.61 <= X11 <= 2.35)
@variable(model, 0.84 <= X12 <= 2.22)
@variable(model, 0.25 <= X13 <= 2.82)
@variable(model, 0.2 <= X14 <= 2.04)
@variable(model, 0.41 <= X15 <= 2.51)
@variable(model, 0.44 <= X16 <= 2.92)
@variable(model, 0.43 <= X17 <= 2.1)
@variable(model, 0 <= X6 <= 0)
@variable(model, 0 <= X7 <= 0)
@variable(model, 0 <= X8 <= 0)
@variable(model, 0 <= X9 <= 48.12670000000001)
@variable(model, -457.1344646836264 <= X0 <= 15960.58413796846)
@variable(model, 0.7055999999999999 <= X104 <= 4.928400000000002)
@variable(model, 0.019844 <= X122 <= 15.684488)
@variable(model, 0.220332 <= X125 <= 10.9557)
@variable(model, 0.044075 <= X137 <= 14.86422)
@variable(model, 0.1384584099999999 <= X139 <= 30.49800625000001)
@variable(model, 0.01848 <= X121 <= 9.691632000000002)
@variable(model, 0.05245999999999999 <= X128 <= 10.0674)
@variable(model, 0.00390625 <= X141 <= 63.24066576)
@variable(model, 0.04509999999999999 <= X136 <= 20.668344)
@variable(model, 0.13660416 <= X140 <= 42.02150976000002)
@variable(model, 0.0025 <= X142 <= 33.09470784000001)
@variable(model, 0.01155625 <= X143 <= 35.07008400000001)
@variable(model, 0.0121 <= X93 <= 4.579600000000001)
@variable(model, 0.1936 <= X116 <= 8.526400000000001)
@variable(model, 0.0215 <= X135 <= 12.08088)
@variable(model, 0.03579663999999999 <= X145 <= 37.60142400000002)
@variable(model, 0.1849 <= X118 <= 4.410000000000001)
@variable(model, 0.3720999999999999 <= X99 <= 5.522500000000001)
@variable(model, 0.1525 <= X101 <= 6.627000000000001)
@variable(model, 0.006723999999999998 <= X144 <= 26.21849616)
@variable(model, 0.06709999999999999 <= X94 <= 5.029000000000001)
@variable(model, 0.04509999999999999 <= X97 <= 5.3714)
@variable(model, 0.0484 <= X98 <= 6.248800000000001)
@variable(model, 0.3443999999999999 <= X107 <= 5.5722)
@variable(model, 0.08599999999999999 <= X114 <= 4.284000000000001)
@variable(model, 0.115412 <= X130 <= 14.4102)
@variable(model, 0.07223999999999998 <= X132 <= 9.510480000000005)
@variable(model, 0.07757199999999999 <= X138 <= 15.39132)
@variable(model, 0.05 <= X109 <= 5.752800000000001)
@variable(model, 0.02952399999999999 <= X119 <= 14.68468)
@variable(model, 0.022 <= X96 <= 4.365600000000001)
@variable(model, 0.0924 <= X131 <= 18.280368)
@variable(model, 0.0625 <= X108 <= 7.9524)
@variable(model, 0.5124 <= X100 <= 5.217000000000001)
@variable(model, 0.0205 <= X134 <= 14.439528)
@variable(model, 0.2500999999999999 <= X103 <= 5.8985)
@variable(model, 0.1025 <= X110 <= 7.0782)
@variable(model, 0.0231 <= X120 <= 13.397256)
@variable(model, 0.05002 <= X126 <= 12.03294)
@variable(model, 0.107543 <= X129 <= 12.38685)
@variable(model, 0.1681 <= X115 <= 6.3001)
@variable(model, 0.1075 <= X111 <= 5.922000000000001)
@variable(model, 0.1515359999999999 <= X133 <= 16.270824)
@variable(model, 0.04 <= X112 <= 4.161600000000001)
@variable(model, 0.019393 <= X123 <= 11.27994)
@variable(model, 0.05368 <= X127 <= 13.99848)
@variable(model, 0.210084 <= X124 <= 13.09467)
@variable(model, 0.1892 <= X117 <= 6.132000000000001)
@variable(model, 0 <= X1 <= 43.88312800000002)
@variable(model, -0 <= X2 <= 421.8723269200008)
@variable(model, -0 <= X3 <= 2674.708253448106)
@variable(model, -0 <= X4 <= 13270.5300053987)
@variable(model, 0.21 <= X105 <= 6.260400000000001)
@variable(model, 0.08199999999999999 <= X113 <= 5.1204)
@variable(model, 0.122 <= X102 <= 4.794)
@variable(model, 0.0924 <= X95 <= 4.750800000000001)
@variable(model, 0.168 <= X106 <= 4.528800000000001)
@constraint(
    model,
    E1,
    - X5 +
    5.92*X10 +
    5.03*X11 +
    3.46*X12 +
    3.47*X13 +
    7.57*X14 +
    3.91*X15 +
    3.52*X16 +
    7.05*X17 == 53.744
)
@constraint(
    model,
    E2,
    - X6 +
    6.29*X10 +
    6.98*X11 +
    4.73*X12 +
    7.87*X13 +
    8.45*X14 +
    3.77*X15 +
    4.45*X16 +
    8.89*X17 == 70.414
)
@constraint(
    model,
    E3,
    - X7 +
    9.64*X10 +
    5.04*X11 +
    6.42*X12 +
    2.65*X13 +
    7.36*X14 +
    5.2*X15 +
    0.31*X16 - 0.19*X17 == 48.31
)
@constraint(
    model,
    E4,
    - X8 +
    1.95*X10 +
    1.22*X11 +
    6.14*X12 +
    9.38*X13 +
    8.85*X14 +
    5.28*X15 +
    7.92*X16 +
    2.04*X17 == 61.299
)
@constraint(
    model,
    E5,
    - X9 +
    4.55*X10 +
    6.76*X11 +
    0.62*X12 +
    6*X13 +
    9.08*X14 +
    7.09*X15 +
    8.86*X16 +
    3.24*X17 == 64.787
)
@constraint(
    model,
    E6,
    - X0 + 5.16*X10 + 0.41*X11 + 0.89*X12 + 0.42*X13 + 9.8*X14 + 5.99*X15 -
    3.05*X16 +
    1.01*X17 +
    5.39*X104 +
    7.24*X122 +
    5.7*X125 +
    4.07*X137 +
    8.76*X139 +
    5.35*X10*X121 +
    5.01*X10*X122 +
    3.98*X10*X128 - 0.23*X10*X141 +
    6.62*X11*X136 +
    6.4*X11*X140 +
    1.09*X12*X121 +
    8.46*X12*X142 +
    0.87*X12*X143 +
    4.7*X13*X93 +
    9.21*X13*X125 +
    3.43*X13*X139 +
    9.45*X14*X116 +
    8.23*X14*X135 +
    8.05*X14*X145 +
    6.74*X15*X118 +
    3.57*X15*X121 +
    6.21*X16*X99 +
    6.81*X16*X101 +
    1.33*X16*X144 +
    8.8*X17*X94 - 5.79*X17*X118 +
    9.22*X93*X97 +
    9.73*X93*X98 +
    4.65*X93*X107 +
    4.96*X93*X114 +
    5.17*X93*X130 +
    1.23*X93*X132 +
    1.11*X93*X138 +
    1.15*X94*X109 +
    6.75*X94*X119 +
    2.91*X96*X131 +
    9.56*X97*X108 +
    5.62*X99*X128 +
    0.54*X99*X136 +
    6.33*X100*X134 +
    2.4*X103*X110 +
    0.91*X103*X120 - 3.73*X104*X126 +
    8.69*X104*X137 +
    6.4*X107*X129 +
    2.25*X108*X115 +
    2.18*X108*X119 +
    5.95*X108*X128 +
    2.43*X111*X120 +
    9.05*X111*X133 +
    7.45*X112*X121 +
    9.98*X112*X123 +
    0.82*X112*X127 +
    5.85*X112*X131 +
    0.34*X115*X120 +
    4.96*X115*X122 +
    9.58*X115*X133 +
    0.44*X116*X124 +
    5.3*X116*X135 +
    8.81*X117*X125 +
    8.38*X118*X125 - 2.96*X118*X129 + 6.36*X118*X134 == 0
)
@constraint(
    model,
    E7,
    - X1 + 4.23*X10 + 1.51*X11 + 6.17*X12 + 7.58*X13 - 7.8*X14 +
    7.28*X15 +
    0.5*X16 +
    3.86*X17 +
    2.17*X104 == 40.764
)
@constraint(
    model,
    E8,
    - X2 + 5.22*X10 + 4.32*X11 + 9.95*X12 + 9.46*X13 + 6.47*X14 + 5.41*X15 -
    4.13*X16 +
    8.02*X17 +
    0.49*X104 - 0.07*X122 +
    0.86*X125 +
    0.69*X137 +
    8.96*X13*X93 +
    3.03*X14*X116 +
    2.29*X15*X118 +
    4.3*X16*X99 +
    4.96*X16*X101 +
    3.72*X17*X94 +
    4.17*X17*X118 == 149.102
)
@constraint(
    model,
    E9,
    - X3 + 7.99*X10 + 1.65*X11 + 5.52*X12 - 0.1*X13 +
    4.57*X14 +
    7.97*X15 +
    1.03*X16 +
    7.58*X17 +
    0.2*X104 - 2.39*X122 +
    6.09*X125 +
    7.41*X137 +
    6.65*X139 +
    0.04*X10*X121 +
    5.96*X10*X122 +
    4.25*X10*X128 +
    8.64*X11*X136 +
    2.65*X12*X121 +
    6.94*X13*X93 - 3.74*X13*X125 +
    8.54*X14*X116 +
    7.95*X14*X135 +
    2.35*X15*X118 +
    0.92*X15*X121 +
    5.79*X16*X99 - 2.73*X16*X101 +
    5.76*X17*X94 +
    1.85*X17*X118 +
    9.99*X93*X97 +
    8.45*X93*X98 +
    1.97*X93*X107 - 0.59*X93*X114 +
    0.09*X94*X109 +
    0.62*X97*X108 +
    2.78*X101*X115 +
    9.84*X108*X115 == 385.876
)
@constraint(
    model,
    E10,
    - X4 + 2.04*X10 + 3.05*X11 + 4.21*X12 - 9.47*X13 +
    2.93*X14 +
    8.97*X15 +
    8.2*X16 +
    7.55*X17 +
    7.38*X104 +
    2.56*X122 - 0.87*X125 +
    3.44*X137 +
    6.77*X139 +
    9.1*X10*X121 +
    4.24*X10*X122 +
    3.04*X10*X128 +
    0.68*X10*X141 +
    9.04*X11*X136 +
    6.72*X11*X140 +
    8.56*X12*X121 +
    9.48*X12*X142 +
    4.34*X12*X143 +
    3.17*X13*X93 +
    1.25*X13*X125 +
    6.32*X13*X139 +
    5.51*X14*X116 +
    8.35*X14*X135 - 5.65*X14*X145 +
    3.72*X15*X118 +
    8.07*X15*X121 +
    0.19*X16*X99 +
    7.79*X16*X101 +
    4.37*X16*X144 +
    7.88*X17*X94 - 2.96*X17*X118 +
    6.27*X93*X97 +
    4.49*X93*X98 +
    2.28*X93*X107 +
    4.2*X93*X114 +
    6.3*X93*X130 +
    4*X93*X132 +
    5.06*X93*X138 +
    0.58*X94*X109 - 1.84*X94*X119 - 1.76*X96*X131 +
    9.72*X97*X108 +
    4.99*X99*X128 +
    8.37*X99*X136 +
    3.66*X100*X134 +
    6.87*X101*X115 +
    7.48*X101*X135 - 8.43*X103*X120 + 4.02*X104*X126 - 6.23*X104*X137 +
    2.79*X105*X138 +
    7.85*X107*X129 +
    6.27*X108*X115 +
    0.01*X108*X119 +
    1.59*X111*X120 +
    6.18*X112*X121 +
    1.46*X112*X123 +
    3.5*X112*X127 +
    3.2*X112*X131 +
    7.83*X114*X137 +
    1.54*X115*X120 +
    1.94*X115*X122 +
    4.32*X115*X133 - 4.66*X116*X124 +
    6.82*X116*X135 +
    8.93*X117*X125 +
    5.78*X118*X125 +
    1.55*X118*X129 == 1074.31
)
@constraint(model, E11, - X117 + X16*X17 == 0)
@constraint(model, E12, - X145 + SQR(X117) == 0)
@constraint(model, E13, - X113 + X14*X15 == 0)
@constraint(model, E14, - X144 + SQR(X113) == 0)
@constraint(model, E15, - X109 + X13*X14 == 0)
@constraint(model, E16, - X135 + X17*X109 == 0)
@constraint(model, E17, - X116 + SQR(X16) == 0)
@constraint(model, E18, - X134 + X13*X113 == 0)
@constraint(model, E19, - X118 + SQR(X17) == 0)
@constraint(model, E20, - X107 + X12*X15 == 0)
@constraint(model, E21, - X133 + X16*X107 == 0)
@constraint(model, E22, - X115 + SQR(X15) == 0)
@constraint(model, E23, - X111 + X13*X17 == 0)
@constraint(model, E24, - X105 + X12*X13 == 0)
@constraint(model, E25, - X131 + X16*X105 == 0)
@constraint(model, E26, - X112 + SQR(X14) == 0)
@constraint(model, E27, - X143 + SQR(X111) == 0)
@constraint(model, E28, - X142 + SQR(X109) == 0)
@constraint(model, E29, - X137 + X15*X111 == 0)
@constraint(model, E30, - X104 + SQR(X12) == 0)
@constraint(model, E31, - X103 + X11*X15 == 0)
@constraint(model, E32, - X129 + X17*X103 == 0)
@constraint(model, E33, - X102 + X11*X14 == 0)
@constraint(model, E34, - X127 + X16*X102 == 0)
@constraint(model, E35, - X128 + X17*X102 == 0)
@constraint(model, E36, - X108 + SQR(X13) == 0)
@constraint(model, E37, - X100 + X11*X12 == 0)
@constraint(model, E38, - X125 + X17*X100 == 0)
@constraint(model, E39, - X124 + X11*X107 == 0)
@constraint(model, E40, - X140 + X104*X116 == 0)
@constraint(model, E41, - X126 + X11*X113 == 0)
@constraint(model, E42, - X110 + X13*X15 == 0)
@constraint(model, E43, - X136 + X16*X110 == 0)
@constraint(model, E44, - X99 + SQR(X11) == 0)
@constraint(model, E45, - X139 + SQR(X99) == 0)
@constraint(model, E46, - X97 + X10*X15 == 0)
@constraint(model, E47, - X122 + X16*X97 == 0)
@constraint(model, E48, - X123 + X17*X97 == 0)
@constraint(model, E49, - X141 + SQR(X108) == 0)
@constraint(model, E50, - X95 + X10*X12 == 0)
@constraint(model, E51, - X121 + X14*X95 == 0)
@constraint(model, E52, - X120 + X10*X105 == 0)
@constraint(model, E53, - X96 + X10*X14 == 0)
@constraint(model, E54, - X94 + X10*X11 == 0)
@constraint(model, E55, - X119 + X16*X94 == 0)
@constraint(model, E56, - X138 + X15*X117 == 0)
@constraint(model, E57, - X93 + SQR(X10) == 0)
@constraint(model, E58, - X106 + X12*X14 == 0)
@constraint(model, E59, - X132 + X17*X106 == 0)
@constraint(model, E60, - X130 + X11*X117 == 0)
@constraint(model, E61, - X114 + X14*X17 == 0)
@constraint(model, E62, - X98 + X10*X16 == 0)
@constraint(model, E63, - X101 + X11*X13 == 0)
@constraint(model, E64, objvar == X0)
@objective(model, Min, objvar)
optimize!(model)
