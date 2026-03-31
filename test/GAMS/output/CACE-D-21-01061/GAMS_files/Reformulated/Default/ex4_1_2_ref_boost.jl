using JuMP
model = Model()
@variable(model, objvar)
@variable(model, -1498.541607778208 <= X0 <= 606.6101927138715)
@variable(model, 1.020117723138492 <= X1 <= 1.134935137659556)
@variable(model, 1.04064016906126 <= X2 <= 1.288077766694316)
@variable(model, 1.061575479869228 <= X3 <= 1.461884717459428)
@variable(model, 1.104718086842402 <= X4 <= 1.883021202029692)
@variable(model, 1.126942499459581 <= X5 <= 2.137106927141432)
@variable(model, 1.220402051396736 <= X6 <= 3.545768847293347)
@variable(model, 1.244953761984383 <= X7 <= 4.024217654811842)
@variable(model, 1.269999397088208 <= X8 <= 4.567226018035896)
@variable(model, 1.431216294866747 <= X9 <= 9.760650360965093)
@variable(model, 1.460009108038174 <= X10 <= 11.07770506106872)
@variable(model, 1.489381167053362 <= X11 <= 12.57247671843599)
@variable(model, 1.519344125019825 <= X12 <= 14.26894559515972)
@variable(model, 1.549909869479067 <= X13 <= 16.19432773329932)
@variable(model, 1.581090527122863 <= X14 <= 18.37951157529604)
@variable(model, 1.612898468604412 <= X15 <= 20.85955349982402)
@variable(model, 1.645346313446293 <= X16 <= 23.67424022283966)
@variable(model, 2.131626595554423 <= X17 <= 122.7155494200275)
@variable(model, 2.218256260773233 <= X18 <= 158.0671708356151)
@variable(model, 2.308406570232257 <= X19 <= 203.602808397628)
@variable(model, 2.499847254957652 <= X20 <= 337.8064457464411)
@constraint(
    model,
    E1,
    - X0 - 500*X1 + 2.5*X2 + 1.66667*X3 + X4 + 0.833333*X5 + X6 - 43.6364*X7 +
    0.416667*X8 +
    0.277778*X9 +
    0.263158*X10 +
    0.25*X11 +
    0.238095*X12 +
    0.227273*X13 +
    0.217391*X14 +
    0.208333*X15 +
    0.2*X16 +
    0.131579*X17 +
    0.125*X18 +
    0.119048*X19 +
    0.108696*X20 +
    1.25*X1*X3 +
    0.714286*X1*X5 +
    0.384615*X1*X8 +
    0.192308*X1*X16 +
    0.128205*X1*X17 +
    0.121951*X1*X18 +
    0.116279*X1*X19 +
    0.106383*X1*X20 +
    0.625*X2*X5 +
    0.357143*X2*X8 +
    0.185185*X2*X16 +
    0.555556*X3*X5 +
    0.333333*X3*X8 +
    0.178571*X3*X16 +
    0.3125*X4*X7 +
    0.294118*X4*X8 +
    0.344828*X4*X15 +
    0.666667*X4*X16 - 15.4839*X5*X16 +
    0.15625*X6*X13 +
    0.151515*X6*X14 +
    0.147059*X6*X15 +
    0.142857*X6*X16 +
    0.138889*X7*X16 +
    0.135135*X8*X16 +
    0.113636*SQR(X13) +
    0.111111*X13*X14 +
    0.208333*SQR(X15) +
    0.408163*X15*X16 +
    0.8*SQR(X16) == 0
)
@constraint(model, E2, - X2 + SQR(X1) == 0)
@constraint(model, E3, - X3 + X1*X2 == 0)
@constraint(model, E4, - X5 + SQR(X3) == 0)
@constraint(model, E5, - X8 + SQR(X5) == 0)
@constraint(model, E6, - X15 + SQR(X8) == 0)
@constraint(model, E7, - X16 + X1*X15 == 0)
@constraint(model, E8, - X4 + X2*X3 == 0)
@constraint(model, E9, - X6 + SQR(X4) == 0)
@constraint(model, E10, - X7 + X1*X6 == 0)
@constraint(model, E11, - X13 + SQR(X7) == 0)
@constraint(model, E12, - X14 + X1*X13 == 0)
@constraint(model, E13, - X20 + SQR(X14) == 0)
@constraint(model, E14, - X12 + X6*X7 == 0)
@constraint(model, E15, - X19 + SQR(X12) == 0)
@constraint(model, E16, - X11 + SQR(X6) == 0)
@constraint(model, E17, - X18 + SQR(X11) == 0)
@constraint(model, E18, - X9 + X5*X8 == 0)
@constraint(model, E19, - X10 + X1*X9 == 0)
@constraint(model, E20, - X17 + SQR(X10) == 0)
@constraint(model, E21, objvar == X0)
@objective(model, Min, objvar)
optimize!(model)
