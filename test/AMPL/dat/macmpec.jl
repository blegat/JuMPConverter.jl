using Test
import MacMPEC
import JuMPConverter

function _mod_path(p::MacMPEC.Problem)
    return joinpath(
        dirname(dirname(pathof(MacMPEC))),
        "data",
        "problems",
        p.mod_file,
    )
end

@testset "$name" for name in MacMPEC.list()
    problem = MacMPEC.problem(name)
    path = MacMPEC.dat_path(problem)
    isnothing(path) && continue
    model = JuMPConverter.AMPL.read_model(_mod_path(problem))
    data = JuMPConverter.AMPL.read_dat(path, model)
    @test data isa Dict{String}
end
