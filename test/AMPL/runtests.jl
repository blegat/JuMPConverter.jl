include(joinpath(dirname(@__DIR__), "utils.jl"))

test_io(JuMPConverter.AMPL.read_model, @__DIR__)
