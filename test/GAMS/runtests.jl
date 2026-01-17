include(joinpath(dirname(@__DIR__), "utils.jl"))

test_io(JuMPConverter.GAMS.read_model, @__DIR__)
