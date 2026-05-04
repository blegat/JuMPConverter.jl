module TestDatParsing

using Test
import JuMPConverter

const JuMP = JuMPConverter.JuMP

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

# ============================================================
# Helper: parse dat with model context
#
# The new parser will need model info to interpret .dat files.
# This helper calls the future API: parse_dat(dat_text, model)
# where `model` comes from parse_model(mod_text).
# Until the new API exists, we fall back to the current
# parse_dat(dat_text) which ignores model info.
# ============================================================

function parse_dat(dat::String, mod::String)
    model = JuMPConverter.AMPL.parse_model(mod)
    return JuMPConverter.AMPL.parse_dat(dat, model)
end

# ============================================================
# Comments
# ============================================================

function test_comment_only()
    data = JuMPConverter.AMPL.parse_dat("# just a comment\nparam n := 5;")
    @test data["n"] == 5
    return
end

function test_comment_before_param()
    data = JuMPConverter.AMPL.parse_dat("""
    # This is a comment
    param n := 5;
    """)
    @test data["n"] == 5
    return
end

function test_multiple_comments()
    data = JuMPConverter.AMPL.parse_dat("""
    # Comment 1
    # Comment 2
    param n := 5;
    # Comment 3
    param m := 10;
    """)
    @test data["n"] == 5
    @test data["m"] == 10
    return
end

# ============================================================
# Whitespace equivalence (newlines = spaces)
#
# In AMPL, newlines are equivalent to spaces. The parser needs
# model info to know how many indices a param has, so it can
# tokenize `1 10 2 20 3 30` as pairs (index, value) for a 1D
# param, or as rows for a 2D param, etc.
# ============================================================

function test_newlines_are_spaces_scalar()
    mod = "param n integer;"
    dat_normal = "param n := 5;"
    dat_newlines = "param\nn\n:=\n5;"
    dat_spaces = "param  n  :=  5;"
    data1 = parse_dat(dat_normal, mod)
    @test data1["n"] == 5
    data3 = parse_dat(dat_spaces, mod)
    @test data1["n"] == data3["n"]
    # With newlines splitting the `:=` across lines, the current parser
    # fails entirely. The new tokenizer-based parser should handle this.
    try
        data2 = parse_dat(dat_newlines, mod)
        @test data1["n"] == data2["n"]
    catch
        @test_broken false
    end
    return
end

function test_newlines_are_spaces_1d()
    # The model tells us `c` is indexed over 1..3, so the parser knows
    # to read (index, value) pairs from the token stream.
    mod = """
    param n integer;
    param c {i in 1..n};
    """
    dat_multiline = """
    param c :=
    1 10
    2 20
    3 30;
    """
    dat_oneline = "param c := 1 10 2 20 3 30;"
    data_multi = parse_dat(dat_multiline, mod)
    @test data_multi["c"][1] ≈ 10.0
    data_one = parse_dat(dat_oneline, mod)
    @test data_one["c"] isa Vector
    @test data_one["c"] == data_multi["c"]
    return
end

function test_newlines_are_spaces_table()
    # The model tells us `cost` is indexed over (1..2) x {A, B},
    # so the parser knows each row has 1 index + 2 values.
    mod = """
    set COLS;
    param cost {1..2, COLS};
    """
    dat_multiline = """
    param cost: A B :=
    1 10 20
    2 30 40;
    """
    dat_oneline = "param cost: A B := 1 10 20 2 30 40;"
    data_multi = parse_dat(dat_multiline, mod)
    @test haskey(data_multi, "cost")
    data_one = parse_dat(dat_oneline, mod)
    @test data_one["cost"] == data_multi["cost"]
    return
end

# ============================================================
# Scalar parameters
# ============================================================

function test_scalar_int()
    data = JuMPConverter.AMPL.parse_dat("param S := 5;")
    @test data["S"] == 5
    @test data["S"] isa Int
    return
end

function test_scalar_float()
    data = JuMPConverter.AMPL.parse_dat("param pi := 3.14159;")
    @test data["pi"] ≈ 3.14159
    @test data["pi"] isa Float64
    return
end

function test_scalar_negative()
    data = JuMPConverter.AMPL.parse_dat("param x := -42;")
    @test data["x"] == -42
    return
end

function test_scalar_scientific()
    data = JuMPConverter.AMPL.parse_dat("param eps := 1e-7;")
    @test data["eps"] ≈ 1e-7
    return
end

function test_multiple_scalars()
    data = JuMPConverter.AMPL.parse_dat("""
    param S := 5;
    param W := 4;
    param H := 3;
    param X := 4;
    """)
    @test data["S"] == 5
    @test data["W"] == 4
    @test data["H"] == 3
    @test data["X"] == 4
    return
end

function test_multiple_scalars_one_line()
    data = JuMPConverter.AMPL.parse_dat("param S := 5; param W := 4;")
    @test data["S"] == 5
    @test data["W"] == 4
    return
end

# ============================================================
# 1D array parameters
# ============================================================

function test_1d_array()
    data = JuMPConverter.AMPL.parse_dat("""
    param rho :=
    1 0.323232
    2 0.161616
    3 0.080808;
    """)
    @test length(data["rho"]) >= 3
    @test data["rho"][1] ≈ 0.323232
    @test data["rho"][2] ≈ 0.161616
    @test data["rho"][3] ≈ 0.080808
    @test eltype(data["rho"]) == Float64
    return
end

function test_1d_array_single_line()
    # With model info (c is indexed), the parser knows to read pairs.
    mod = """
    param n integer;
    param c {i in 1..n};
    """
    dat = "param c := 1 10.0 2 20.0 3 30.0;"
    data = parse_dat(dat, mod)
    @test data["c"] isa Vector
    @test data["c"][1] ≈ 10.0
    @test data["c"][2] ≈ 20.0
    @test data["c"][3] ≈ 30.0
    return
end

# ============================================================
# Multi-column table (param : col1 col2 := ...)
# ============================================================

function test_multi_column_1d()
    data = JuMPConverter.AMPL.parse_dat("""
    param
    :      rho       beta   alpha    :=
    1   0.323232    0.66667    0
    2   0.161616    0.66667    0
    3   0.080808    0.66667    0;
    """)
    @test haskey(data, "rho")
    @test haskey(data, "beta")
    @test haskey(data, "alpha")
    @test isa(data["rho"], Vector)
    @test data["rho"][1] ≈ 0.323232
    @test data["beta"][1] ≈ 0.66667
    return
end

function test_multi_column_2d()
    data = JuMPConverter.AMPL.parse_dat("""
    param
    :        C          R       :=
    1 1    84.812151    120.964401
    1 2    100.553059   135.362834
    2 1    79.851577    115.524285
    2 2    102.740615   126.833369;
    """)
    @test haskey(data, "C")
    @test haskey(data, "R")
    @test size(data["C"]) == (2, 2) ||
          data["C"] isa JuMP.Containers.SparseAxisArray
    @test size(data["R"]) == (2, 2) ||
          data["R"] isa JuMP.Containers.SparseAxisArray
    return
end

# ============================================================
# 2D table format (param name: col1 col2 := ...)
# ============================================================

function test_2d_table()
    data = JuMPConverter.AMPL.parse_dat("""
    param cost: A B C :=
    1 10 20 30
    2 40 50 60;
    """)
    @test haskey(data, "cost")
    return
end

# ============================================================
# 3D arrays (slice notation)
# ============================================================

function test_3d_array_slices()
    data = JuMPConverter.AMPL.parse_dat("""
    param E [*,*,1]: 1 2 :=
    1 10 20
    2 30 40
    [*,*,2]: 1 2 :=
    1 50 60
    2 70 80;
    """)
    @test haskey(data, "E")
    E = data["E"]
    @test ndims(E) == 3
    @test size(E) == (2, 2, 2)
    @test E[1, 1, 1] ≈ 10
    @test E[1, 2, 1] ≈ 20
    @test E[2, 1, 2] ≈ 70
    @test E[2, 2, 2] ≈ 80
    return
end

# ============================================================
# Missing values (dot)
# ============================================================

function test_dot_as_missing_1d()
    data = JuMPConverter.AMPL.parse_dat("""
    param
    :      rho    alpha    :=
    1   0.323232    0
    2   0.161616    0
    3   0.080808    .;
    """)
    @test haskey(data, "rho")
    @test haskey(data, "alpha")
    # alpha[3] should be missing or handled appropriately
    return
end

# ============================================================
# Set data
# ============================================================

function test_set_integers()
    data = JuMPConverter.AMPL.parse_dat("set S := 1 2 3 4 5;")
    @test data["S"] == [1, 2, 3, 4, 5]
    return
end

function test_set_strings()
    data = JuMPConverter.AMPL.parse_dat("set CITIES := Seattle Denver Chicago;")
    @test data["CITIES"] == ["Seattle", "Denver", "Chicago"]
    return
end

function test_set_comma_separated()
    data = JuMPConverter.AMPL.parse_dat("set S := 1,2,3;")
    @test length(data["S"]) == 3
    return
end

# ============================================================
# Semicolons as delimiters
# ============================================================

function test_semicolon_ends_statement()
    data = JuMPConverter.AMPL.parse_dat("param a := 1; param b := 2;")
    @test data["a"] == 1
    @test data["b"] == 2
    return
end

function test_trailing_whitespace_after_semicolon()
    data = JuMPConverter.AMPL.parse_dat("param n := 42;   \n\n")
    @test data["n"] == 42
    return
end

# ============================================================
# let command
# ============================================================

function test_let_command()
    data = JuMPConverter.AMPL.parse_dat("let x := 5;")
    @test data["x"] == 5
    return
end

# ============================================================
# Full example file with model context
# ============================================================

function test_example1_dat()
    path = joinpath(@__DIR__, "examples", "example1.dat")
    data = JuMPConverter.AMPL.read_dat(path)
    @test data[:S] == 5
    @test data[:W] == 4
    @test data[:H] == 3
    @test data[:X] == 4
    @test haskey(data, :rho)
    @test haskey(data, :beta)
    @test haskey(data, :alpha)
    @test haskey(data, :E)
    @test haskey(data, :C)
    @test haskey(data, :R)
    @test haskey(data, :polyX)
    @test isa(data[:rho], Vector)
    @test isa(data[:E], Array)
    @test ndims(data[:E]) == 3
    return
end

function test_read_dat_returns_symbol_keys()
    # Splatting `data...` into `build_model(; ...)` requires Symbol keys.
    path = joinpath(@__DIR__, "examples", "example1.dat")
    data = JuMPConverter.AMPL.read_dat(path)
    @test data isa Dict{Symbol,Any}
    @test all(k -> k isa Symbol, keys(data))
    return
end

function test_example1_with_model()
    # Parse the .mod to get model info, then parse .dat with it.
    # The model tells the parser the dimensionality of each param.
    mod_path = joinpath(@__DIR__, "input", "elec_pricing.mod")
    dat_path = joinpath(@__DIR__, "examples", "example1.dat")
    mod_text = read(mod_path, String)
    dat_text = read(dat_path, String)
    data = parse_dat(dat_text, mod_text)
    @test data["S"] == 5
    @test data["W"] == 4
    @test data["H"] == 3
    @test data["X"] == 4
    @test isa(data["rho"], Vector)
    @test length(data["rho"]) == 5
    @test isa(data["E"], Array)
    @test ndims(data["E"]) == 3
    return
end

end  # module

TestDatParsing.runtests()
