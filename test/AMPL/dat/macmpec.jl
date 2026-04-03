using Test
import MacMPEC
import JuMPConverter

@testset "$name" for name in MacMPEC.list()
    if startswith(name, "incid-set") ||
       startswith(name, "nash") ||
       startswith(name, "pack-comp") ||
       startswith(name, "pack-rig")
        continue
    end
    if startswith(name, "flp4")
        break
    end
    if name in ["bem-milanc30-s"]
        continue
    end
    problem = MacMPEC.problem(name)
    path = MacMPEC.dat_path(problem)
    if !isnothing(path)
        data = JuMPConverter.AMPL.read_ampl_dat(path)
        @test data isa Dict{String}
    end
end
