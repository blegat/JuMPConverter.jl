using JuMP
model = Model()
@variable(model, 0.00001 <= x1 <= 2000)
@variable(model, 0.00001 <= x2 <= 16000)
@variable(model, 0.00001 <= x3 <= 120)
@variable(model, 0.00001 <= x4 <= 5000)
@variable(model, 0.00001 <= x5 <= 2000)
@variable(model, 85 <= x6 <= 93)
@variable(model, 90 <= x7 <= 95)
@variable(model, 3 <= x8 <= 12)
@variable(model, 1.2 <= x9 <= 4)
@variable(model, 145 <= x10 <= 162)
@variable(model, 0.00000714285 <= x11 <= 9.99880014398)
@variable(model, 0.0005 <= x12 <= 100000)
@variable(model, obj)
@constraint(model, ob, 5.04*x1+0.035*x2+10*x3+3.36*x5 - 0.063*x4*x7 == obj)
@constraint(model, c1, 35.82-0.222*x10-0.9*x9 >= 0)
@constraint(model, c2, -133+3*x7-0.99*x10 >= 0)
@constraint(model, c3, -(35.82-0.222*x10-0.9*x9)+0.211111*x9 >= 0)
@constraint(model, c4, -(-133+3*x7-0.99*x10)+0.020101*x10 >= 0)
@constraint(model, c5, 1.12*x1+0.13167*x1*x8-0.00667*x1*x8*x8 - 0.99*x4 >= 0)
@constraint(model, c6, 57.425 + 1.098*x8-0.038*x8*x8+0.325*x6-0.99*x7 >= 0)
@constraint(
    model,
    c7,
    -(1.12*x1+0.13167*x1*x8-0.00667*x1*x8*x8 - 0.99*x4)+0.020101*x4 >= 0
)
@constraint(
    model,
    c8,
    -(57.425 + 1.098*x8-0.038*x8*x8+0.325*x6-0.99*x7)+0.020101*x7 >= 0
)
@constraint(model, c9, 1.22*x4-x1-x5 == 0)
@constraint(model, c10, 98000*x3*x11 - x6 == 0)
@constraint(model, c11, (x2+x5)*x12-x8 == 0)
@constraint(model, c12, (x4*x9+1000*x3)*x11 == 1)
@constraint(model, c13, x1*x12 == 1)
@objective(model, Min, obj)
optimize!(model)
