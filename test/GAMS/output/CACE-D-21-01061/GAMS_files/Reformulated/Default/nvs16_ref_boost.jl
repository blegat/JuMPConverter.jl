using JuMP
function build_model()
    model = Model()
    @variable(model, objvar)
    @variable(model, 0 <= X0 <= 2.410250046221872e+18)
    @variable(model, -0 <= X3 <= 39600)
    @variable(model, -0 <= X5 <= 1552478400)
    @variable(model, 0 <= X4 <= 39204)
    @variable(model, 2 <= Y1 <= 200, Int)
    @variable(model, Y2 <= 198, Int)
    @constraint(model, E1, - X0 - 12.75*Y1 + 3*X3 + 5.25*X5 + 3*SQR(Y1) - 2*Y1*X3 + 4.5*Y1*X4 - 2*Y1*X5 - SQR(X3) + X3*X5 + SQR(X5) == -14.2031)
    @constraint(model, E2, - X3 + Y1*Y2 == 0)
    @constraint(model, E3, - X4 + SQR(Y2) == 0)
    @constraint(model, E4, - X5 + X3*X4 == 0)
    @constraint(model, E5, objvar == X0)
    @objective(model, Min, objvar)
    optimize!(model)
    return model
end
