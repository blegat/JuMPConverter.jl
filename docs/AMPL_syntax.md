# AMPL Model and Data Syntax Reference

Reference for converting AMPL `.mod` and `.dat` files to JuMP.
Based on the [AMPL Book](https://ampl.com/learn/ampl-book/) and
[AMPL documentation](https://dev.ampl.com/).

## General Rules

- **Case sensitive**: identifiers `cost` and `Cost` are distinct (unlike GAMS).
- **Semicolons**: Statement terminator. Required after every declaration and data
  command.
- **Free-form layout**: Statements can span multiple lines. Newlines, tabs, and
  spaces are interchangeable — any sequence of whitespace is equivalent to a
  single space. This applies to both `.mod` and `.dat` files.
- **Identifiers**: Start with a letter or `_`, followed by letters, digits, or
  underscores.
- **Comments**: `#` starts a line comment (to end of line).

## Relationship Between `.mod` and `.dat`

A `.mod` file declares the *structure* (sets, parameters, variables, objectives,
constraints). A `.dat` file supplies the *values* for sets and parameters
declared in the model.

The data file cannot be fully interpreted without the model: whether a token
sequence like `1 2 3 4` represents a 1D array, a 2×2 table, or set members
depends on the declaration in the `.mod` file (dimensionality, indexing sets,
etc.).

Key implications:
- Parsing `.dat` requires knowing what sets/parameters were declared and their
  dimensions.
- Whitespace (including newlines) carries no structural meaning in `.dat` files —
  line breaks are purely cosmetic.
- Semicolons delimit data commands, not newlines.

## Set Declarations (`.mod`)

```ampl
set CITIES;                              # simple set
set LINKS within {CITIES, CITIES};       # set of pairs, subset constraint
set ROUTES dimen 3;                      # 3-tuples, no parent domain
set WEEKS = 1..52;                       # defined by expression
set YEARS ordered;                       # ordered set
set AREA {PROD};                         # indexed collection of sets
```

### Set Operations

| Operation            | Syntax               |
|----------------------|----------------------|
| Union                | `A union B`          |
| Intersection         | `A inter B`          |
| Difference           | `A diff B`           |
| Symmetric difference | `A symdiff B`        |
| Cartesian product    | `A cross B`          |

### Numeric Ranges

```ampl
1..n           # integers 1 to n
a..b by c      # integers a to b with step c
```

### Membership and Subset

```ampl
i in S             # membership test
S1 within S2       # subset constraint (in declarations)
```

## Parameter Declarations (`.mod`)

```ampl
param T > 0 integer;                              # scalar, restricted
param cost {FOOD} >= 0;                            # indexed, with lower bound check
param demand {DEST, PROD} >= 0;                    # multi-indexed
param rho {s in 1..S} default 0;                   # with default value
param total = sum {i in SET} data[i];              # computed (assignment)
param mininv {p in PROD} default frac * market[p]; # default expression
param name symbolic;                               # string-valued parameter
param name symbolic in SOMESET;                    # string param restricted to set
```

### Check Statements

```ampl
check: sum {i in ORIG} supply[i] = sum {j in DEST} demand[j];
check {p in PROD}: supply[p] >= demand[p];
```

## Variable Declarations (`.mod`)

```ampl
var x;                                    # free (unbounded)
var x >= 0;                               # non-negative
var x >= 0, <= 1;                         # bounded
var Make {p in PROD} >= 0, <= market[p];  # indexed with param bounds
var x binary;                             # binary {0,1}
var n integer, >= 0;                      # non-negative integer
var x := 1.5;                             # with initial value
var x default 0;                          # with default initial value
var Total = sum {i in S} x[i];            # defined variable (substituted)
```

Bounds are given as qualifying phrases separated by commas:
`>= expr`, `<= expr`, `binary`, `integer`, `:= expr`, `default expr`.

## Objectives (`.mod`)

```ampl
minimize Total_Cost: sum {j in FOOD} cost[j] * Buy[j];
maximize Profit: sum {p in PROD} revenue[p] * Make[p];
```

General form: `minimize|maximize name : expression ;`

Indexed objectives (less common):
```ampl
minimize Cost_by_Orig {i in ORIG}: sum {j in DEST} cost[i,j] * Trans[i,j];
```

## Constraints (`.mod`)

```ampl
subject to Supply {i in ORIG}: sum {j in DEST} Trans[i,j] = supply[i];

subject to Demand {j in DEST}:
    sum {i in ORIG} Trans[i,j] >= demand[j];

subject to Budget: sum {j in FOOD} cost[j] * Buy[j] <= budget;
```

The `subject to` keyword is optional — any declaration not recognized as another
type is treated as a constraint.

### Constraint Operators

| Syntax | Meaning        |
|--------|----------------|
| `<=`   | Less-or-equal  |
| `>=`   | Greater-or-equal |
| `=`    | Equality       |

### Double Inequalities

```ampl
subject to Bounds {j in FOOD}: f_min[j] <= Buy[j] <= f_max[j];
```

### Conditional Constraints

```ampl
subject to Time {if avail > 0}: sum {p in PROD} (1/rate[p]) * Make[p] <= avail;
```

### Complementarity Constraints

```ampl
subject to KKT {i in 1..n}: 0 <= x[i] complements y[i] >= 0;
```

## Indexing Expressions

Used in parameters, variables, objectives, constraints, and sum/prod operators.

```ampl
{i in S}                           # iterate over set S
{i in 1..n}                        # iterate over range
{i in S, j in T}                   # Cartesian product
{i in S, j in T : condition}       # with filter condition
{(i,j) in LINKS}                   # iterate over set of pairs
{i in S, j in S : i <> j}          # all distinct pairs
{p in PROD, t in 1..T, a in AREA[p]}  # dependent indexing
```

The condition after `:` filters which index combinations are included.

## Expressions and Operators

### Arithmetic Operators (by precedence, highest first)

| Operator     | Description                                   |
|--------------|-----------------------------------------------|
| `^` or `**`  | Exponentiation (right-associative)            |
| `+`, `-`     | Unary plus/minus                              |
| `*`, `/`     | Multiplication, division                      |
| `div`, `mod` | Integer division, remainder                   |
| `less`       | Positive difference: `max(a - b, 0)`          |
| `+`, `-`     | Addition, subtraction                         |

### Iterated Operators

```ampl
sum {i in S} expr[i]
prod {i in S} expr[i]
min {i in S} expr[i]
max {i in S} expr[i]
```

### Built-in Functions

| AMPL             | Julia/JuMP      |
|------------------|-----------------|
| `abs(x)`         | `abs(x)`        |
| `ceil(x)`        | `ceil(x)`       |
| `floor(x)`       | `floor(x)`      |
| `round(x)`       | `round(x)`      |
| `sqrt(x)`        | `sqrt(x)`       |
| `exp(x)`         | `exp(x)`        |
| `log(x)`         | `log(x)`        |
| `log10(x)`       | `log10(x)`      |
| `sin(x)`, `cos(x)`, `tan(x)` | same |
| `max(a, b, ...)` | `max(a, b, ...)` |
| `min(a, b, ...)` | `min(a, b, ...)` |
| `atan2(y, x)`    | `atan(y, x)`    |

### Logical Operators

| Operator       | Description |
|----------------|-------------|
| `and`, `&&`    | Logical AND |
| `or`, `\|\|`  | Logical OR  |
| `not`, `!`     | Logical NOT |

### Comparison Operators

`<`, `<=`, `=`, `>=`, `>`, `<>` (not equal)

### Conditional Expressions

```ampl
if condition then expr1 else expr2
```

The `else` clause defaults to 0 if omitted.

### Iterated Logical Operators

```ampl
exists {i in S} condition[i]    # true if any
forall {i in S} condition[i]    # true if all
```

### Set-of Operator

```ampl
setof {(i,j,p) in ROUTES} (i,j)    # extract components from tuples
```

## Data Commands (`.dat`)

All data commands terminate with a semicolon. Whitespace (spaces, tabs, newlines)
is interchangeable — any whitespace sequence equals a single space.

### Scalar Parameter

```ampl
param T := 10;
```

### Set Data

```ampl
set CITIES := Seattle Denver Chicago;
set LINKS := (Seattle, Chicago) (Denver, Chicago);
set LINKS := (Seattle,*) Chicago Denver (Denver,*) Chicago;   # slice notation
```

### 1D Parameter (List Format)

```ampl
param cost := bands 200 coils 140 plate 160;

# Equivalent (newlines don't matter):
param cost :=
  bands 200
  coils 140
  plate 160;
```

### 2D Parameter (Table Format)

```ampl
param cost: FRA DET LAN :=
  GARY   39   14   11
  CLEV   27    9   12
  PITT   24   14   17;
```

Column headers are the second index, row labels are the first index.

### Transposed Table

```ampl
param cost (tr): GARY CLEV PITT :=
  FRA   39   27   24
  DET   14    9   14
  LAN   11   12   17;
```

### Slice Notation for Multi-Dimensional

```ampl
param E [*,*,1]: 1 2 3 4 :=
  1   205   197   159   166
  2   218   196   162   164;

param E [*,*,2]: 1 2 3 4 :=
  1   0   0   37   40
  2   0   0   51   55;
```

The `[*,*,h]` template fixes the third index to `h`.

### Combined Set and Parameter

```ampl
param: CITIES: supply demand :=
  Seattle   350   0
  Denver    600   300
  Chicago   0     275;
```

Declares set membership and multiple parameter values simultaneously.

### Missing Values

A dot `.` marks an absent entry in a table. It is distinct from zero —
the parameter has no value for that index combination.

```ampl
param revenue: Q1 Q2 Q3 Q4 :=
  widgets   10   .   15   20
  gadgets   .    5   .    12;
```

### Set Membership in Tables

`+` and `-` indicate membership/non-membership in set tables.

### Default Values

```ampl
param cost default 0 := Seattle Chicago 39 Denver Chicago 27;
```

Unspecified entries receive the default.

### Let Command

```ampl
let x := 5;
let {i in S} y[i] := 0;
```

Assigns values to variables or parameters directly.

### Fix Command

```ampl
fix x := 5;
```

## Patterns in Common AMPL Models

### MacMPEC Benchmark

These complementarity problems typically use:
1. **Scalar and indexed parameters**: `param n;`, `param c {1..n};`
2. **Variables with bounds**: `var x {1..n} >= 0;`
3. **Complementarity constraints**: `0 <= expr complements var >= 0`
4. **Data inline or in `.dat` files** separated by `;`

### Typical Model Structure

```ampl
# Sets
set PRODUCTS;
set RESOURCES;

# Parameters
param supply {RESOURCES} >= 0;
param demand {PRODUCTS} >= 0;
param cost {RESOURCES, PRODUCTS} >= 0;

# Variables
var Ship {RESOURCES, PRODUCTS} >= 0;

# Objective
minimize Total_Cost:
    sum {i in RESOURCES, j in PRODUCTS} cost[i,j] * Ship[i,j];

# Constraints
subject to Supply {i in RESOURCES}:
    sum {j in PRODUCTS} Ship[i,j] <= supply[i];

subject to Demand {j in PRODUCTS}:
    sum {i in RESOURCES} Ship[i,j] >= demand[j];
```
