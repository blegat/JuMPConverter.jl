using JuMP
model = Model()
@variable(model, 78 <= x1 <= 125)
@variable(model, 33 <= x2 <= 45)
@variable(model, 27 <= x3 <= 45)
@variable(model, 27 <= x4 <= 45)
@variable(model, 27 <= x5 <= 45)
@variable(model, obj)
@constraint(
    model,
    ob,
    5.3578547*x3*x3 + 0.8356891*x1*x5 + 37.293239*x1 - 40792.141 == obj
)
@constraint(
    model,
    c1,
    85.334407 + 0.0056858*x2*x5 + 0.0006262*x1*x4 - 0.0022053*x3*x5 >= 0
)
@constraint(
    model,
    c2,
    85.334407 + 0.0056858*x2*x5 + 0.0006262*x1*x4 - 0.0022053*x3*x5 <= 92
)
@constraint(
    model,
    c3,
    80.51249 + 0.0071317*x2*x5 + 0.0029955*x1*x2 + 0.0021813*x3*x3 >= 90
)
@constraint(
    model,
    c4,
    80.51249 + 0.0071317*x2*x5 + 0.0029955*x1*x2 + 0.0021813*x3*x3 <= 110
)
@constraint(
    model,
    c5,
    9.300961 + 0.0047026*x3*x5 + 0.0012547*x1*x3 + 0.0019085*x3*x4 >= 20
)
@constraint(
    model,
    c6,
    9.300961 + 0.0047026*x3*x5 + 0.0012547*x1*x3 + 0.0019085*x3*x4 <= 25
)
@objective(model, Min, obj)
optimize!(model)
