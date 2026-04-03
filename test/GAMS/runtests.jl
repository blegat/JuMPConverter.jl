include(joinpath(dirname(@__DIR__), "utils.jl"))

# Ensure the CACE submodule is initialized (not an empty directory)
let cace_dir = joinpath(@__DIR__, "input", "CACE-D-21-01061", "GAMS_files")
    if !isdir(cace_dir)
        @warn "CACE submodule not initialized. Run `git submodule update --init`."
    end
end

test_output(JuMPConverter.GAMS.read_model, @__DIR__)
