import JuMPConverter
include(joinpath(dirname(@__DIR__), "utils.jl"))

test_io(JuMPConverter.AMPL.read_model, @__DIR__)

include(joinpath(@__DIR__, "mod_tests.jl"))
include(joinpath(@__DIR__, "dat_tests.jl"))
