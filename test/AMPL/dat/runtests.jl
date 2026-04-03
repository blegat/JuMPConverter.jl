for file in readdir(@__DIR__)
    if endswith(file, ".jl") && file != "runtests.jl"
        include(file)
    end
end
