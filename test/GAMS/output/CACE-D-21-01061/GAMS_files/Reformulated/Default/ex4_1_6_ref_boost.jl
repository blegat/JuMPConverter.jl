using JuMP
function build_model()
    model = Model()
    @variable(model, objvar)
    @variable(model, -2414.357098609557 <= X0 <= 2977.135683540217)
    @variable(model, 0 <= X2 <= 13.32755816246811)
    @variable(model, -3.650692833212363 <= X1 <= 3.650692833212363)
    @variable(model, -48.65482106794328 <= X3 <= 48.65482106794328)
    @constraint(model, E1, - X0 + 27*X2 - 15*X1*X3 + SQR(X3) == -250)
    @constraint(model, E2, - X2 + SQR(X1) == 0)
    @constraint(model, E3, - X3 + X1*X2 == 0)
    @constraint(model, E4, objvar == X0)
    @objective(model, Min, objvar)
    return model
end
