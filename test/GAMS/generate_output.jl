# Regenerate all JuMP output files from GAMS input files.
# After running, use `git diff test/GAMS/output` to check for regressions.
#
# Usage:
#   julia --project test/GAMS/generate_output.jl [output_dir]
#
# If output_dir is not given, defaults to test/GAMS/output.

using JuMPConverter

const INPUT_DIR = joinpath(@__DIR__, "input")

function _output_dir()
    if !isempty(ARGS)
        return ARGS[1]
    end
    return joinpath(@__DIR__, "output")
end

function generate(input_dir, output_dir)
    for entry in sort(readdir(input_dir))
        input_path = joinpath(input_dir, entry)
        if isdir(input_path)
            generate(input_path, joinpath(output_dir, entry))
        elseif endswith(entry, ".gms")
            mkpath(output_dir)
            output_path = joinpath(output_dir, replace(entry, ".gms" => ".jl"))
            model = JuMPConverter.GAMS.read_model(input_path)
            open(output_path, "w") do io
                println(io, model)
            end
        end
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    output_dir = _output_dir()
    println("Generating GAMS → JuMP output files into $output_dir ...")
    generate(INPUT_DIR, output_dir)
    println("Done. Check with: git diff test/GAMS/output")
end
