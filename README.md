# JuMPConverter.jl

[![Build Status](https://github.com/blegat/JuMPConverter.jl/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/blegat/JuMPConverter.jl/actions?query=workflow%3ACI)
[![codecov](https://codecov.io/gh/blegat/JuMPConverter.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/blegat/JuMPConverter.jl)

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

To read a AMPL™ model `file.gms`, do:
```julia
using JuMPConverter
model = JuMPConverter.GAMS.read_model("file.gms")
open("file.jl", "w") do io
    println(io, model)
end
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
