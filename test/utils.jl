using Test
import JuMPConverter

function content(f)
    return open(io -> read(io, String), f)
end

function test_files(a, b)
    process = run(Cmd(`diff --color=always $a $b`, ignorestatus = true))
    @test process.exitcode == 0
    #@test content(a) == content(b)
end

name(f) = split(f, ".")[1]

function test_io(reader, input_dir, output_dir)
    tmp = Base.Filesystem.tempname()
    @info("Temporary file is $tmp")
    @testset "$(name(f))" for f in readdir(input_dir)
        base_name = name(f)
        model = reader(joinpath(input_dir, f))
        open(tmp, "w") do io
            println(io, model)
        end
        test_files(tmp, joinpath(output_dir, base_name * ".jl"))
    end
end

function test_io(reader, root_dir)
    input_dir = joinpath(root_dir, "input")
    output_dir = joinpath(root_dir, "output")
    test_io(reader, input_dir, output_dir)
end
