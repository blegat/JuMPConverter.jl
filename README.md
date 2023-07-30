# JuMPConverter.jl

[![Build Status](https://github.com/blegat/JuMPConverter.jl/workflows/CI/badge.svg?branch=master)](https://github.com/blegat/JuMPConverter.jl/actions?query=workflow%3ACI)
[![codecov](https://codecov.io/gh/blegat/JuMPConverter.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/blegat/JuMPConverter.jl)

[JuMPConverter.jl](https://github.com/blegat/JuMPConverter.jl) is a converter
for GAMS™ models in `.gmx` to [JuMP](https://github.com/jump-dev/JuMP.jl/)
models in `.jl`.

## License

`JuMPConverter.jl` is licensed under the [MIT License](https://github.com/blegat/JuMPConverter.jl/blob/master/LICENSE.md).

## Installation

Install JuMPConverter as follows:
```julia
import Pkg
Pkg.add("https://github.com/blegat/JuMPConverter.jl")
```

## Use with JuMP

To use JuMPConverter to convert a file `file.gms` to a file `file.jl` do:

```julia
using JuMPConverter
convert_to("file.gms", "file.jl")
```

To print the JuMP model to the terminal, simply do

```julia
using JuMPConverter
convert_to("file.gms")
```
