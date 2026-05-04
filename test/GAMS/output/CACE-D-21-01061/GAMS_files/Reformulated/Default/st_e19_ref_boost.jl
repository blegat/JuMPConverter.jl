using JuMP
function build_model(; _kwargs...)
    model = Model()
    @variable(model, objvar)
    @variable(model, -12.02902418374221 <= X1 <= 0)
    @variable(model, -4.572905930176966 <= X3 <= 4.029024183742213)
    @variable(model, 0 <= X4 <= 10)
    @variable(model, -502.5103033717146 <= X0 <= 533.9861013528124)
    @variable(model, 0 <= X7 <= 20.91146864624767)
    @variable(model, -26.96951701373209 <= X2 <= 0)
    @constraint(model, E1, - X1 - X3 + X4 == 8)
    @constraint(model, E2, - X0 + 24*X3 - 14*X7 - SQR(X4) + SQR(X7) == 0)
    @constraint(model, E3, - X2 - 2*X3 + X4 - X7 == -2)
    @constraint(model, E4, - X7 + SQR(X3) == 0)
    @constraint(model, E5, objvar == X0)
    @objective(model, Min, objvar)
    optimize!(model)
    return model
end
