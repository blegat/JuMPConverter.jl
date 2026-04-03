using JuMP
model = Model()
@variable(model, 0 <= xx[w in 1..W, h in 1..H] <= 1)
@variable(model, 0 <= y[s in 1..S, w in 0..W] <= 1)
@variable(model, mu[s in 1..S] >= 0)
@variable(model, eta[w in 1..W] >= 0)
@constraint(model, simplex[s in 1..S], sum{w in 0..W}(y[s, w]) == 1)
@constraint(
    model,
    testgeq[x in 1..X],
    sum{h in 1..H}(polyX[x, 3+h]*xx[round(polyX[x, 1]), h]) >= polyX[x, 3]
)
@constraint(
    model,
    testeq[x in 1..X],
    sum{h in 1..H}(polyX[x, 3+h]*xx[round(polyX[x, 1]), h]) == polyX[x, 3]
)
@constraint(
    model,
    KKT1[s in 1..S, w in 1..W],
    0 <=
    sum{h in 1..H}(E[s, w, h]*xx[w, h]) + mu[s] - R[s, w] +
    2.0 / beta[s] * (y[s, w]-y[s, 0]) ⟂
    y[s, w] >=
    0
)
@constraint(model, KKT2[s in 1..S], 0 <= mu[s] ⟂ y[s, 0] >= 0)
@constraint(
    model,
    coupl[w in 1..W],
    eta[w] + sum{s in 1..S}(y[s, w]) >= S*alpha[w]
)
@objective(
    model,
    Max,
    sum{s in 1..S,w in 1..W}(rho[s]*(R[s, w]-C[s, w])*y[s, w]) -
    sum{s in 1..S,w in 1..W}(rho[s] * 2.0 / beta[s] * y[s, w]^2) +
    sum{s in 1..S}(rho[s] * (2.0 / beta[s] * y[s, 0] - mu[s])) -
    10*sum{w in 1..W}(eta[w])
)
optimize!(model)
