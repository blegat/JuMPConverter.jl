using JuMP
function build_model(; _kwargs...)
    model = Model()
    @variable(model, objvar)
    @variable(model, 0 <= X0 <= 46867.37308124411)
    @variable(model, -0.5457311166000651 <= X1 <= 2.465510507419179)
    @variable(model, 0 <= X2 <= 6.078742062194377)
    @variable(model, 0 <= X3 <= 36.95110505869115)
    @variable(model, 0 <= X4 <= 224.6162365648293)
    @constraint(model, E1, - X0 - 60*X1 + 208*X2 + 596*X3 + 241*X4 - 438*X1*X2 - 508*X1*X3 - 52*X1*X4 + 4*SQR(X3) == -9)
    @constraint(model, E2, - X2 + SQR(X1) == 0)
    @constraint(model, E3, - X3 + SQR(X2) == 0)
    @constraint(model, E4, - X4 + X2*X3 == 0)
    @constraint(model, E5, objvar == X0)
    @objective(model, Min, objvar)
    optimize!(model)
    return model
end
