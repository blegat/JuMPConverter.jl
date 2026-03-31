include(joinpath(dirname(@__DIR__), "utils.jl"))

test_io(JuMPConverter.GAMS.read_model, @__DIR__)

# Test all CACE-D-21-01061 benchmark files parse successfully
cace_dir = joinpath(@__DIR__, "CACE-D-21-01061", "GAMS_files", "Original")
if isdir(cace_dir)
    @testset "CACE: $(f)" for f in readdir(cace_dir)
        endswith(f, ".gms") || continue
        path = joinpath(cace_dir, f)
        model = JuMPConverter.GAMS.read_model(path)
        # Verify it produces valid Julia code
        buf = IOBuffer()
        println(buf, model)
        code = String(take!(buf))
        @test !isempty(code)
        # Verify it parses as valid Julia
        expr = Meta.parseall(code)
        @test expr.head == :toplevel
    end
end
