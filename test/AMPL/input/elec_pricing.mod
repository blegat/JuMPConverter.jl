param S integer;
param W integer;
param H integer;
param X integer;

param rho   {s in 1..S} default 0;
param beta  {s in 1..S} default 0;
param alpha {w in 1..W} default 0;
param E     {s in 1..S, w in 1..W, h in 1..H} default 0;
param C     {s in 1..S, w in 1..W} default 0;
param R     {s in 1..S, w in 1..W} default 0;
param polyX {x in 1..X, k in 1..3+H} default 0;

var xx     {w in 1..W, h in 1..H} >=0, <=1;
var y     {s in 1..S, w in 0..W} >=0, <=1;
var mu    {s in 1..S} >=0;
var eta   {w in 1..W} >=0;

maximize profit:    sum{s in 1..S, w in 1..W}(rho[s]*(R[s,w]-C[s,w])*y[s,w])
                    - sum{s in 1..S, w in 1..W}(rho[s] * 2./beta[s] * y[s,w]^2)
                    + sum{s in 1..S}(rho[s] * (2./beta[s] * y[s,0] - mu[s]))
                    - 10*sum{w in 1..W}(eta[w]);

subject to

simplex {s in 1..S}:                    sum{w in 0..W}(y[s,w]) == 1 ;
testgeq {x in 1..X: polyX[x,2] == 1}:   sum{h in 1..H}(polyX[x,3+h]*xx[round(polyX[x,1]),h]) >= polyX[x,3];
testeq  {x in 1..X: polyX[x,2] == 0}:   sum{h in 1..H}(polyX[x,3+h]*xx[round(polyX[x,1]),h]) == polyX[x,3];

KKT1    {s in 1..S, w in 1..W}:         0 <= sum{h in 1..H}(E[s,w,h]*xx[w,h]) + mu[s] - R[s,w] + 2./beta[s] * (y[s,w]-y[s,0])
                                                    complements y[s,w] >= 0;
KKT2    {s in 1..S}:                    0 <= mu[s]  complements y[s,0] >= 0;

coupl   {w in 1..W}:                    eta[w] + sum{s in 1..S}(y[s,w]) >= S*alpha[w];