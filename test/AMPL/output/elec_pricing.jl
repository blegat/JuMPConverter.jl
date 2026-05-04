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
    @variable(model, 0 <= xx <= 1)
    @variable(model, 0 <= y <= 1)
    @variable(model, mu >= 0)
    @variable(model, eta >= 0)
    @constraint(model, simplex, sum(y[s, w] for w in 0..W) == 1)
    @constraint(
        model,
        testgeq,
        sum(polyX[x, 3+h] * xx[round(polyX[x, 1]), h] for h in 1..H) >=
        polyX[x, 3]
    )
    @constraint(
        model,
        testeq,
        sum(polyX[x, 3+h] * xx[round(polyX[x, 1]), h] for h in 1..H) ==
        polyX[x, 3]
    )
    @constraint(
        model,
        KKT1,
        sum(E[s, w, h] * xx[w, h] for h in 1..H) + mu[s] - R[s, w] +
        2.0 / beta[s] * (y[s, w] - y[s, 0]) ⟂ y[s, w]
    )
    @constraint(model, KKT2, mu[s] ⟂ y[s, 0])
    @constraint(
        model,
        coupl,
        eta[w] + sum(y[s, w] for s in 1..S) >= S * alpha[w]
    )
    @objective(
        model,
        Max,
        sum(rho[s] * (R[s, w] - C[s, w]) * y[s, w] for s in 1..S, w in 1..W) -
        sum(rho[s] * 2.0 / beta[s] * y[s, w] ^ 2 for s in 1..S, w in 1..W) +
        sum(rho[s] * (2.0 / beta[s] * y[s, 0] - mu[s]) for s in 1..S) -
        10 * sum(eta[w] for w in 1..W)
    )
    optimize!(model)
    return model
end
