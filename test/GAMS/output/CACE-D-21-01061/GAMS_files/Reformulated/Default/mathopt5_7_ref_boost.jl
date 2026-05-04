using JuMP
function build_model()
    model = Model()
    @variable(model, objvar)
    @variable(model, -31.08237679973927 <= X0 <= 23.8883555473821)
    @variable(model, 5.992692147443035 <= X1 <= 7.315596553755234)
    @variable(model, 35.9123591740254 <= X2 <= 53.51795293731546)
    @variable(model, 1289.697541444207 <= X3 <= 2864.171286600712)
    @constraint(model, E1, - X0 - 8.9248e-07*X1 - 0.000218343*X2 - 0.016995*X3 + 0.00998266*X1*X2 + 0.002*X1*X3 == 0)
    @constraint(model, E2, - X2 + SQR(X1) == 0)
    @constraint(model, E3, - X3 + SQR(X2) == 0)
    @constraint(model, E4, objvar == X0)
    @objective(model, Min, objvar)
    return model
end
