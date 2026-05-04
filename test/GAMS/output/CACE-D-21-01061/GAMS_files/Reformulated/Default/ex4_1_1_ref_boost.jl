using JuMP
function build_model(; _kwargs...)
    model = Model()
    @variable(model, objvar)
    @variable(model, -181.3716202599764 <= X0 <= 263.4306990353814)
    @variable(model, -1.612180987671979 <= X1 <= 2.282499225537449)
    @variable(model, 0 <= X2 <= 5.209802714579054)
    @variable(model, -4.190263999703826 <= X3 <= 11.89137066122959)
    @constraint(model, E1, - X0 - X1 - 3.95*X2 + 7.1*X3 + 0.4875*X1*X3 - 2.08*X2*X3 + SQR(X3) == -0.1)
    @constraint(model, E2, - X2 + SQR(X1) == 0)
    @constraint(model, E3, - X3 + X1*X2 == 0)
    @constraint(model, E4, objvar == X0)
    @objective(model, Min, objvar)
    optimize!(model)
    return model
end
