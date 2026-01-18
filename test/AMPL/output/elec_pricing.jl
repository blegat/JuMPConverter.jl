using JuMP
model = Model()
@variable(model, 0 <= xx <= 1)
@variable(model, 0 <= y <= 1)
@variable(model, mu >= 0)
@variable(model, eta >= 0)
@constraint(model, simplex, sum{w in 0..W}(y[s, w]) == 1)
@constraint(
    model,
    testgeq,
    sum{h in 1..H}(polyX[x, 3+h]*xx[round(polyX[x, 1]), h]) >= polyX[x, 3]
)
@constraint(
    model,
    testeq,
    sum{h in 1..H}(polyX[x, 3+h]*xx[round(polyX[x, 1]), h]) == polyX[x, 3]
)
@constraint(
    model,
    KKT1,
    0 <=
    sum{h in 1..H}(E[s, w, h]*xx[w, h]) + mu[s] - R[s, w] +
    2.0 / beta[s] * (y[s, w]-y[s, 0]) ⟂
    y[s, w] >=
    0
)
@constraint(model, KKT2, 0 <= mu[s] ⟂ y[s, 0] >= 0)
@constraint(model, coupl, eta[w] + sum{s in 1..S}(y[s, w]) >= S*alpha[w])
@objective(
    model,
    Max,
    sum{s in 1..S,w in 1..W}(rho[s]*(R[s, w]-C[s, w])*y[s, w]) -
    sum{s in 1..S,w in 1..W}(rho[s] * 2.0 / beta[s] * y[s, w]^2) +
    sum{s in 1..S}(rho[s] * (2.0 / beta[s] * y[s, 0] - mu[s])) -
    10*sum{w in 1..W}(eta[w])
)
optimize!(model)
