module TestElecPricing

using Test
import JuMP

import JuMPConverter

function runtests()
    for name in names(@__MODULE__; all = true)
        if startswith("$(name)", "test_")
            @testset "$(name)" begin
                getfield(@__MODULE__, name)()
            end
        end
    end
    return
end

function test_scalar_parameters()
    data = JuMPConverter.AMPL.parse_ampl_dat("param S := 5; param W := 4;")
    @test data["S"] == 5
    @test data["S"] isa Int
    @test data["W"] == 4
    @test data["W"] isa Int
    return
end

function test_table()
    text = """
param 
:        C          R       :=
1    1    84.812151    120.964401
1    2    100.553059    135.362834
1    3    79.851577    115.524285
1    4    102.740615    126.833369
"""
    data = JuMPConverter.AMPL.parse_ampl_dat(text)
    @test haskey(data, "C")
    @test haskey(data, "R")
    @test isa(data["C"], Matrix)
    @test isa(data["R"], Matrix)
    @test eltype(data["C"]) == Float64
    @test eltype(data["R"]) == Float64
    @test size(data["C"]) == (1, 4)
    @test size(data["R"]) == (1, 4)
end

function test_1d_array()
    data = JuMPConverter.AMPL.parse_ampl_dat("""
param rho :=
1 0.323232
2 0.161616
3 0.080808;
    """)
    @test length(data["rho"]) >= 3
    @test data["rho"][1] ≈ 0.323232
    @test eltype(data["rho"]) == Float64
    return
end

function test_multi_column_table_1d()
    data = JuMPConverter.AMPL.parse_ampl_dat("""
param
:      rho       beta   alpha    :=
1   0.323232    0.66667    0
2   0.161616    0.66667    0
3   0.080808    0.66667    0
;""")
    @test haskey(data, "rho")
    @test haskey(data, "beta")
    @test haskey(data, "alpha")
    @test isa(data["rho"], Vector)
    @test isa(data["beta"], Vector)
    @test isa(data["alpha"], Vector)
    @test eltype(data["rho"]) == Float64
    @test eltype(data["beta"]) == Float64
    @test eltype(data["alpha"]) == Float64
    @test length(data["rho"]) >= 3
    @test data["rho"][1] ≈ 0.323232
    return
end

function test_multi_column_table_2d()
    data = JuMPConverter.AMPL.parse_ampl_dat("""
param
:        C          R        polyX       :=
1 1    80.2636   120.964401    1.945917
1 2    94.0192   135.362834    1.039845
2 1    78.77673   130.3699    1.840248
2 2    100.944157   155.100142    0.987113
;
""")
    @test haskey(data, "C")
    @test haskey(data, "R")
    @test haskey(data, "polyX")
    @test isa(data["C"], Matrix)
    @test isa(data["R"], Matrix)
    @test isa(data["polyX"], Matrix)
    @test eltype(data["C"]) == Float64
    @test eltype(data["R"]) == Float64
    @test eltype(data["polyX"]) == Float64
    @test size(data["C"]) == (2, 2)
    @test size(data["R"]) == (2, 2)
    @test size(data["polyX"]) == (2, 2)
    @test data["C"][1, 1] ≈ 80.2636
    @test data["C"][1, 2] ≈ 94.0192
    @test data["C"][2, 1] ≈ 78.77673
    @test data["C"][2, 2] ≈ 100.944157
    @test data["R"][1, 1] ≈ 120.964401
    @test data["R"][1, 2] ≈ 135.362834
    @test data["R"][2, 1] ≈ 130.3699
    @test data["R"][2, 2] ≈ 155.100142
    return
end

function test_example_file()
    example_file = joinpath(@__DIR__, "..", "examples", "example1.dat")
    data = JuMPConverter.AMPL.read_ampl_dat(example_file)
    @test haskey(data, "S")
    @test haskey(data, "W")
    @test haskey(data, "H")
    @test haskey(data, "X")
    @test data["S"] == 5
    @test data["W"] == 4
    @test data["H"] == 3
    @test data["X"] == 4
    @test haskey(data, "rho")
    @test haskey(data, "beta")
    @test haskey(data, "alpha")
    @test haskey(data, "E")
    @test haskey(data, "C")
    @test haskey(data, "R")
    @test haskey(data, "polyX")
    @test isa(data["rho"], Vector)
    @test isa(data["E"], Array)
    @test ndims(data["E"]) == 3
    @test isa(
        data["C"],
        JuMP.Containers.SparseAxisArray{Float64,2,NTuple{2,Int}},
    )
    @test eltype(data["rho"]) == Float64
    @test eltype(data["beta"]) == Float64
    @test isa(
        data["alpha"],
        JuMP.Containers.SparseAxisArray{Float64,1,Tuple{Int}},
    )
    @test eltype(data["E"]) == Union{Float64,Missing}
    for k in ["C", "R", "polyX"]
        @test isa(
            data[k],
            JuMP.Containers.SparseAxisArray{Float64,2,NTuple{2,Int}},
        )
    end
    return
end

end  # module

TestElecPricing.runtests()
