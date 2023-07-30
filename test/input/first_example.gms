Positive Variables    Xcorn, Xwheat, Xcotton;
Variables             Z;

Equations     obj, land, labor;

obj..  Z =e= 109 * Xcorn + 90 * Xwheat + 115 * Xcotton;
land..             Xcorn +      Xwheat +       Xcotton =l= 100;
labor..        6 * Xcorn +  4 * Xwheat +   8 * Xcotton =l= 500;

Model farmproblem / obj, land, labor /;

solve farmproblem using LP maximizing Z;
