# JuMPConverter.jl

[![Build Status](https://github.com/blegat/JuMPConverter.jl/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/blegat/JuMPConverter.jl/actions?query=workflow%3ACI)
[![codecov](https://codecov.io/gh/blegat/JuMPConverter.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/blegat/JuMPConverter.jl)

> [!NOTE]
> There is a [GSOC proposal](https://github.com/jump-dev/GSOC) to improve this package.

[JuMPConverter.jl](https://github.com/blegat/JuMPConverter.jl) is a converter
for AMPL™ models in `.mod` or GAMS™ models in `.gmx` to [JuMP](https://github.com/jump-dev/JuMP.jl/)
models in `.jl`.

## License

`JuMPConverter.jl` is licensed under the [MIT License](https://github.com/blegat/JuMPConverter.jl/blob/main/LICENSE.md).

## Installation

Install JuMPConverter as follows:
```julia
import Pkg
Pkg.add("https://github.com/blegat/JuMPConverter.jl")
```

## Use with JuMP

### AMPL™ converter

To read an AMPL™ model `file.mod`, do
```julia
using JuMPConverter
model = JuMPConverter.AMPL.read_model("file.mof")
```

### Loading data from a `.dat` file or a CSV directory

AMPL keeps the model structure (`.mod`) and the data (`.dat`) in
separate files. The emitted Julia file is self-contained: it defines
the keyword-argument `build_model(; S, W, ...)` plus a
`build_model(path::String)` dispatcher that picks between a `.dat`
file and a directory of CSVs based on `isdir(path)`. Once the `.jl`
file is generated, the `.mod` is no longer needed at runtime:

```julia
using JuMPConverter
model = JuMPConverter.AMPL.read_model("file.mod")
open("file.jl", "w") do io
    println(io, model)
end

include("file.jl")

# Load straight from the .dat
jump_model = build_model("file.dat")
```

You can also export a `.dat` to a directory of CSVs (one file per
parameter or set) and pass that directory back to `build_model`:

```julia
JuMPConverter.AMPL.dat_to_csv("file.dat", model, "data/")
jump_model = build_model("data/")
```

The CSV directory loader reads each kwarg's CSV when present, so any
file you delete falls back to the kwarg's `.mod` default. CSV shape:
scalars and sets are single-column; 1D parameters are `index, value`;
2D parameters are labeled matrices (column headers from the second
axis); 3+D parameters use long form (`i1, i2, ..., value`).

If you already have a data dictionary (or want to override individual
parameters), call the kwarg form directly. `JuMPConverter.AMPL.read_dat`
returns a `Dict{Symbol,Any}` mapping each parameter or set name to a
scalar, `Vector`, `Array`, `JuMP.Containers.DenseAxisArray`, or
`JuMP.Containers.SparseAxisArray`:

```julia
data = JuMPConverter.AMPL.read_dat("file.dat", model)  # or pass a DatSchema
jump_model = build_model(; data...)
```

### GAMS™ converter

To read a GAMS™ model `file.gms`, do:
```julia
using JuMPConverter
model = JuMPConverter.GAMS.read_model("file.gms")
```

To print the JuMP model to the terminal, simply do
```julia
println(io, model)
```

To save the JuMP model in a file `file.jl`, do
```julia
open("file.jl", "w") do io
    println(io, model)
end
```
