# Example: Parse the quad_b1_S5.dat file
dat_file = joinpath(
    @__DIR__,
    "..",
    "..",
    "optimTarif",
    "run_tests",
    "results",
    "quad_b1_S5.dat",
)

if isfile(dat_file)
    data = read_ampl_dat(dat_file)

    println("Parsed parameters:")
    for key in sort(collect(keys(data)))
        val = data[key]
        if isa(val, Number)
            println("  $key = $val")
        elseif isa(val, AbstractArray)
            println("  $key: $(typeof(val)) with size $(size(val))")
        else
            println("  $key: $(typeof(val))")
        end
    end
else
    println("File not found: $dat_file")
end
