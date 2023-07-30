using Test
import JuMPConverter
root = dirname(dirname(pathof(JuMPConverter)))
tmp = Base.Filesystem.tempname()
input_dir = joinpath(root, "test", "input")
output_dir = joinpath(root, "test", "output")

function content(f)
    return open(io -> read(io, String), f)
end

function test_files(a, b)
    @test content(a) == content(b)
end

name(f) = split(f, ".")[1]

@testset "$f" for f in name.(readdir(input_dir))
    JuMPConverter.convert_to(joinpath(input_dir, f * ".gms"), tmp)
    test_files(tmp, joinpath(output_dir, f * ".jl"))
end
