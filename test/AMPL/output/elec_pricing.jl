using JuMP
function build_model(;
    S,
    W,
    H,
    X,
    rho = 0.0,
    beta = 0.0,
    alpha = 0.0,
    E = 0.0,
    C = 0.0,
    R = 0.0,
    polyX = 0.0,
)
    model = Model()
    @variable(model, 0 <= xx[w in 1:W, h in 1:H] <= 1)
    @variable(model, 0 <= y[s in 1:S, w in 0:W] <= 1)
    @variable(model, mu[s in 1:S] >= 0)
    @variable(model, eta[w in 1:W] >= 0)
    @constraint(model, simplex[s in 1:S], sum(y[s, w] for w in 0:W) == 1)
    @constraint(
        model,
        testgeq[x in 1:X; polyX[x, 2] == 1],
        sum(polyX[x, 3+h] * xx[round(polyX[x, 1]), h] for h in 1:H) >=
        polyX[x, 3]
    )
    @constraint(
        model,
        testeq[x in 1:X; polyX[x, 2] == 0],
        sum(polyX[x, 3+h] * xx[round(polyX[x, 1]), h] for h in 1:H) ==
        polyX[x, 3]
    )
    @constraint(
        model,
        KKT1[s in 1:S, w in 1:W],
        sum(E[s, w, h] * xx[w, h] for h in 1:H) + mu[s] - R[s, w] +
        2.0 / beta[s] * (y[s, w] - y[s, 0]) ⟂ y[s, w]
    )
    @constraint(model, KKT2[s in 1:S], mu[s] ⟂ y[s, 0])
    @constraint(
        model,
        coupl[w in 1:W],
        eta[w] + sum(y[s, w] for s in 1:S) >= S * alpha[w]
    )
    @objective(
        model,
        Max,
        sum(rho[s] * (R[s, w] - C[s, w]) * y[s, w] for s in 1:S, w in 1:W) -
        sum(rho[s] * 2.0 / beta[s] * y[s, w] ^ 2 for s in 1:S, w in 1:W) +
        sum(rho[s] * (2.0 / beta[s] * y[s, 0] - mu[s]) for s in 1:S) -
        10 * sum(eta[w] for w in 1:W)
    )
    optimize!(model)
    return model
end
