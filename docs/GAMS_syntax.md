# GAMS Scalar Model Syntax Reference

Reference for the subset of GAMS syntax relevant to converting `.gms` files to JuMP.
Based on the [GAMS documentation](https://www.gams.com/latest/docs/).

## General Rules

- **Case insensitive**: `Variables`, `VARIABLES`, `variables` are all equivalent.
- **Semicolons**: Statement terminator. Can be omitted before a new GAMS keyword or at end of file.
- **Free-form layout**: Statements can span multiple lines with no continuation character.
- **Identifiers**: Start with a letter, followed by letters, digits, or underscores (max 63 chars).

## Comments

| Syntax | Scope |
|--------|-------|
| `*` in column 1 | Entire line is a comment |
| `$ontext` / `$offtext` | Block comment (`$` must be in column 1) |

## Compiler Directives

Directives start with `$` in column 1. Common ones in benchmark files:

- `$offdigit` — suppresses precision warnings for numeric literals

These are metadata for the GAMS compiler and can be ignored during conversion.

## Variable Declarations

```gams
Variables        x, y, z ;          -- free variables (default: -INF to +INF)
Free Variables   obj ;              -- same as Variables
Positive Variables  x1, x2 ;       -- lower bound = 0
Negative Variables  x1 ;           -- upper bound = 0
Binary Variables    b1, b2 ;       -- {0, 1}
Integer Variables   n1 ;           -- non-negative integers
```

All keywords are case-insensitive. Both singular and plural forms are accepted
(`Variable` and `Variables`).

Variables can be declared in multiple statements; later type declarations
(e.g. `Positive Variables`) refine the bounds of already-declared variables.

## Variable Attributes (Bounds and Initial Values)

Set after declaration using dot-suffixes:

```gams
x.lo = -1 ;      -- lower bound
x.up = 1.5 ;     -- upper bound
x.fx = 3.0 ;     -- fix variable (sets lo = up = value)
x.l  = 0.5 ;     -- initial level (starting point for solver)
```

Multiple bound statements can appear on a single line separated by `;`:
```gams
x1.lo = 0; x1.up = 3; x2.lo = 0; x2.up = 4;
```

## Equation Declarations

```gams
Equations  obj, c1, c2, c3 ;
```

Just names the equations. The actual definitions follow separately.

## Equation Definitions

Use the `..` operator to define the mathematical relationship:

```gams
obj..   z =e= 3*x + 4*y ;
c1..    x + y =l= 10 ;
c2..    x - y =g= 0 ;
```

The constraint name and `..` can be separated by whitespace or tabs:
```gams
con1	..	expression =G= rhs ;
```

### Constraint Type Operators

| GAMS | Meaning | JuMP |
|------|---------|------|
| `=e=` / `=E=` | Equality | `==` |
| `=l=` / `=L=` | Less-or-equal | `<=` |
| `=g=` / `=G=` | Greater-or-equal | `>=` |

## Expressions

### Arithmetic Operators

`+`, `-`, `*`, `/` — standard meaning.

### Exponentiation

Two equivalent forms:
```gams
x**2            -- infix operator
power(x, 2)    -- function form
```

Both map to `x^2` in JuMP/Julia.

### Built-in Functions

| GAMS | Julia/JuMP |
|------|-----------|
| `power(x, n)` | `x^n` |
| `sqr(x)` | `x^2` |
| `sqrt(x)` | `sqrt(x)` |
| `abs(x)` | `abs(x)` |
| `exp(x)` | `exp(x)` |
| `log(x)` | `log(x)` |
| `sin(x)` / `cos(x)` | `sin(x)` / `cos(x)` |

### Scientific Notation

Standard floating-point literals: `1e-7`, `3.14e+2`, etc.
These are valid Julia syntax and need no conversion.

## Model Statement

```gams
Model transport /all/ ;              -- include all equations
Model mymodel /eq1, eq2, eq3/ ;      -- include specific equations
Model test/all/;                     -- spaces around / are optional
```

The `/all/` form is the most common in benchmark files.
Ignored during conversion (all defined equations are included).

## Solve Statement

```gams
Solve transport using LP minimizing z ;
Solve test using NLP minimizing obj ;
Solve m using MINLP minimizing x598 ;
```

General form: `Solve <model> using <type> minimizing|maximizing <variable> ;`

The model type (`LP`, `NLP`, `MIP`, `MINLP`, `QCP`, etc.) informs which
solver to use but does not change the JuMP formulation.

## Display Statement

```gams
Display x1.l, x2.l ;
display x.l, y.l;
```

Post-solve output directive. Ignored during conversion.

## Patterns in the CACE-D-21-01061 Benchmark

The benchmark files use a consistent subset of GAMS features:

1. **Variable declarations**: `Variables`, `Free Variable(s)`, `Positive Variables`, `Binary Variables`
2. **Bound setting**: `x.lo`, `x.up`, `x.fx` — always scalar (no indexed variables)
3. **Equation definitions**: Using `..` with `=e=`/`=E=`, `=l=`/`=L=`, `=g=`/`=G=`
4. **Expressions**: Products of variables, `power(x,n)`, `**(n)` exponentiation, scientific notation
5. **Comments**: `*` line comments, `$offdigit` directive
6. **Model/Solve/Display**: Standard boilerplate, always present
7. **No sets, parameters, tables, or indexed equations** — all scalar models
