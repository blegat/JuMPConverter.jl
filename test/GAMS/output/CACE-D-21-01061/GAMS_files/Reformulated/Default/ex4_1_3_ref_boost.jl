using JuMP
function build_model(; _kwargs...)
    model = Model()
    @variable(model, objvar)
    @variable(model, -3307.172825489248 <= X0 <= 2615.461798429621)
    @variable(model, 5.989551007613608 <= X1 <= 7.387615276079095)
    @variable(model, 35.87472127280518 <= X2 <= 54.5768594673572)
    @variable(model, 1286.995626401461 <= X3 <= 2978.633589319658)
    @constraint(model, E1, - X0 + 8.9248e-05*X1 - 0.0218343*X2 - 1.6995*X3 + 0.998266*X1*X2 + 0.2*X1*X3 == 0)
    @constraint(model, E2, - X2 + SQR(X1) == 0)
    @constraint(model, E3, - X3 + SQR(X2) == 0)
    @constraint(model, E4, objvar == X0)
    @objective(model, Min, objvar)
    optimize!(model)
    return model
end
