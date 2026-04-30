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

To read an AMPL™ model `file.mod`, do
```julia
using JuMPConverter
model = JuMPConverter.AMPL.read_model("file.mof")
```

### Loading data from a `.dat` file

AMPL keeps the model structure (`.mod`) and the data (`.dat`) in
separate files. The emitted Julia file defines a `build_model` function
whose keyword arguments are the AMPL parameters declared in the `.mod`,
plus a trailing `_kwargs...` to absorb any extras. To populate the
model, parse the data with `read_dat` (passing the model so each
parameter's dimensionality is resolved correctly) and splat the
resulting dictionary into `build_model`:

```julia
using JuMPConverter
model = JuMPConverter.AMPL.read_model("file.mod")
open("file.jl", "w") do io
    println(io, model)
end

# In file.jl: `function build_model(; S, W, ..., _kwargs...) ... end`
include("file.jl")

data = JuMPConverter.AMPL.read_dat("file.dat", model)
jump_model = build_model(; data...)
```

`data` is a `Dict{String,Any}` mapping each parameter or set name to a
scalar, `Vector`, `Array`, `JuMP.Containers.DenseAxisArray`, or
`JuMP.Containers.SparseAxisArray` depending on the declaration.

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
