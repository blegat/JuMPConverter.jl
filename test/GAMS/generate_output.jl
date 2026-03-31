# Run this script to regenerate all JuMP output files from GAMS input files.
# After running, use `git diff test/GAMS/output` to check for regressions.
#
# Usage:
#   julia --project test/GAMS/generate_output.jl

using JuMPConverter
import JuliaFormatter

const INPUT_DIR = joinpath(@__DIR__, "input")
const OUTPUT_DIR = joinpath(@__DIR__, "output")

function generate(input_dir, output_dir)
    for entry in readdir(input_dir)
        input_path = joinpath(input_dir, entry)
        if isdir(input_path)
            sub_output = joinpath(output_dir, entry)
            generate(input_path, sub_output)
        elseif endswith(entry, ".gms")
            mkpath(output_dir)
            output_path = joinpath(output_dir, replace(entry, ".gms" => ".jl"))
            model = JuMPConverter.GAMS.read_model(input_path)
            open(output_path, "w") do io
                println(io, model)
            end
            JuliaFormatter.format_file(output_path)
            println("  ", relpath(output_path, joinpath(@__DIR__, "..")))
        end
    end
end

println("Generating GAMS → JuMP output files...")
generate(INPUT_DIR, OUTPUT_DIR)
println("Done. Check with: git diff test/GAMS/output")
