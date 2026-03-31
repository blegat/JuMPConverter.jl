include(joinpath(dirname(@__DIR__), "utils.jl"))

test_output(JuMPConverter.GAMS.read_model, @__DIR__)
