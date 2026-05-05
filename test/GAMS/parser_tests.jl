module TestGAMSParser

using Test
import JuMPConverter

const G = JuMPConverter.GAMS
const MOI = JuMPConverter.MOI

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
# _preprocess
# ============================================================

function test_preprocess_skips_star_comments_in_column_one()
    out = G._preprocess("* full-line comment\nVariables x")
    @test !occursin("comment", out)
    @test occursin("Variables x", out)
    return
end

function test_preprocess_skips_dollar_directives_in_column_one()
    out = G._preprocess("\$onText\nstuff inside\n\$offText\nVariables x")
    @test !occursin("\$onText", out)
    @test !occursin("\$offText", out)
    return
end

function test_preprocess_keeps_lines_not_starting_with_star_or_dollar()
    out = G._preprocess("Variables x;\nx.lo = 0;")
    @test occursin("Variables x;", out)
    @test occursin("x.lo = 0;", out)
    return
end

# ============================================================
# clean_expression
# ============================================================

function test_clean_expression_no_power_passes_through()
    @test G.clean_expression("a + b * c") == "a + b * c"
    return
end

function test_clean_expression_simple_power()
    @test G.clean_expression("power(x, 2)") == "(x)^(2)"
    return
end

function test_clean_expression_power_nested_parens_in_base()
    @test G.clean_expression("power((a + b), 3)") == "((a + b))^(3)"
    return
end

function test_clean_expression_power_with_whitespace_before_paren()
    @test G.clean_expression("power (x, 4)") == "(x)^(4)"
    return
end

function test_clean_expression_multiple_power_calls()
    @test G.clean_expression("power(a, 2) + power(b, 3)") == "(a)^(2) + (b)^(3)"
    return
end

function test_clean_expression_malformed_power_left_alone()
    # Unclosed parens — `clean_expression` gives up (the malformed
    # break) and returns the input largely unchanged (apart from
    # later replacements).
    @test G.clean_expression("power(x, ") == "power(x, "
    return
end

function test_clean_expression_double_star_to_caret()
    @test G.clean_expression("a ** 2") == "a ^ 2"
    return
end

function test_clean_expression_relops_case_insensitive()
    @test G.clean_expression("a =e= b") == "a == b"
    @test G.clean_expression("a =l= b") == "a <= b"
    @test G.clean_expression("a =g= b") == "a >= b"
    @test G.clean_expression("a =E= b") == "a == b"
    @test G.clean_expression("a =L= b") == "a <= b"
    @test G.clean_expression("a =G= b") == "a >= b"
    return
end

# ============================================================
# parse_variable
# ============================================================

function test_parse_variable_single_name()
    model = JuMPConverter.Model()
    G.parse_variable(model, "x")
    @test haskey(model.variables, "x")
    return
end

function test_parse_variable_comma_separated()
    model = JuMPConverter.Model()
    G.parse_variable(model, "a, b, c")
    @test haskey(model.variables, "a")
    @test haskey(model.variables, "b")
    @test haskey(model.variables, "c")
    return
end

function test_parse_variable_skips_empty_entries()
    # `Variables a,,b` — the empty token between commas is ignored.
    model = JuMPConverter.Model()
    G.parse_variable(model, "a,,b")
    @test haskey(model.variables, "a")
    @test haskey(model.variables, "b")
    @test length(model.variables) == 2
    return
end

function test_parse_variable_with_lower_bound()
    model = JuMPConverter.Model()
    G.parse_variable(model, "x"; lower_bound = "0")
    @test model.variables["x"].lower_bound == "0"
    return
end

function test_parse_variable_binary_and_integer_flags()
    model = JuMPConverter.Model()
    G.parse_variable(model, "b"; binary = true)
    G.parse_variable(model, "i"; integer = true)
    @test model.variables["b"].binary
    @test model.variables["i"].integer
    return
end

# ============================================================
# parse_bound
# ============================================================

function test_parse_bound_lo_on_existing_variable()
    model = JuMPConverter.Model()
    G.parse_variable(model, "x")
    G.parse_bound(model, "x", "lo", "-1")
    @test model.variables["x"].lower_bound == "-1"
    return
end

function test_parse_bound_up_on_existing_variable()
    model = JuMPConverter.Model()
    G.parse_variable(model, "x")
    G.parse_bound(model, "x", "up", "1.5")
    @test model.variables["x"].upper_bound == "1.5"
    return
end

function test_parse_bound_fx_on_existing_variable()
    model = JuMPConverter.Model()
    G.parse_variable(model, "x")
    G.parse_bound(model, "x", "fx", "0.5")
    @test model.variables["x"].fixed_value == "0.5"
    return
end

function test_parse_bound_creates_variable_if_missing()
    # GAMS often sets `x.lo = ...` before declaring `Variable x`.
    model = JuMPConverter.Model()
    G.parse_bound(model, "y", "lo", "0")
    @test haskey(model.variables, "y")
    @test model.variables["y"].lower_bound == "0"
    return
end

function test_parse_bound_unknown_suffix_is_skipped()
    # `.l` is the level (initial value), not a bound — silently ignored.
    model = JuMPConverter.Model()
    G.parse_variable(model, "x")
    G.parse_bound(model, "x", "l", "0.3")
    @test model.variables["x"].lower_bound === nothing
    @test model.variables["x"].upper_bound === nothing
    @test model.variables["x"].fixed_value === nothing
    return
end

# ============================================================
# parse_solve
# ============================================================

function test_parse_solve_minimizing()
    model = JuMPConverter.Model()
    G.parse_solve(model, "solve test using nlp minimizing obj")
    @test model.objective.sense == MOI.MIN_SENSE
    @test model.objective.expression == "obj"
    return
end

function test_parse_solve_maximizing()
    model = JuMPConverter.Model()
    G.parse_solve(model, "solve farm using lp maximizing Z")
    @test model.objective.sense == MOI.MAX_SENSE
    @test model.objective.expression == "Z"
    return
end

function test_parse_solve_short_min_max()
    model = JuMPConverter.Model()
    G.parse_solve(model, "Solve m using LP MIN obj")
    @test model.objective.sense == MOI.MIN_SENSE
    model2 = JuMPConverter.Model()
    G.parse_solve(model2, "solve m using lp MAX z")
    @test model2.objective.sense == MOI.MAX_SENSE
    return
end

function test_parse_solve_malformed_throws()
    # No `using`, so the inner regex never matches.
    model = JuMPConverter.Model()
    @test_throws ErrorException G.parse_solve(model, "solve foo")
    return
end

# ============================================================
# parse_constraint
# ============================================================

function test_parse_constraint_basic_uses_clean_expression()
    model = JuMPConverter.Model()
    G.parse_constraint(model, "c1", "x =l= 5")
    @test length(model.constraints) == 1
    @test model.constraints[1].name == "c1"
    @test model.constraints[1].expression == "x <= 5"
    return
end

# ============================================================
# parse_model — end-to-end exercising every dispatched command
# ============================================================

function test_parse_model_first_example_full()
    # Single end-to-end model that exercises:
    # Variables, Positive Variables, Equations (no-op), Model
    # (no-op), constraints (`name..`), `solve` w/ maximizing.
    mod = """
    Positive Variables    Xcorn, Xwheat, Xcotton;
    Variables             Z;

    Equations     obj, land, labor;

    obj..  Z =e= 109 * Xcorn + 90 * Xwheat + 115 * Xcotton;
    land..             Xcorn +      Xwheat +       Xcotton =l= 100;
    labor..        6 * Xcorn +  4 * Xwheat +   8 * Xcotton =l= 500;

    Model farmproblem / obj, land, labor /;

    solve farmproblem using LP maximizing Z;
    """
    m = G.parse_model(mod)
    @test all(
        haskey(m.variables, n) for n in ("Xcorn", "Xwheat", "Xcotton", "Z")
    )
    @test m.variables["Xcorn"].lower_bound == "0"
    @test m.variables["Z"].lower_bound === nothing
    @test length(m.constraints) == 3
    @test m.constraints[1].name == "obj"
    @test occursin("==", m.constraints[1].expression)
    @test occursin("<=", m.constraints[2].expression)
    @test m.objective.sense == MOI.MAX_SENSE
    @test m.objective.expression == "Z"
    return
end

function test_parse_model_negative_free_binary_integer_variables()
    # Cover the remaining variable dispatchers (Negative, Free,
    # Binary, Integer) plus Display (no-op).
    mod = """
    Negative Variables n;
    Free Variables f;
    Binary Variables b;
    Integer Variables i;
    Display n;
    """
    m = G.parse_model(mod)
    @test m.variables["n"].upper_bound == "0"
    @test m.variables["f"].lower_bound === nothing
    @test m.variables["b"].binary
    @test m.variables["i"].integer
    return
end

function test_parse_model_dot_bounds_are_dispatched()
    # Cover `name . suffix = value` dispatch.
    mod = """
    Variables x;
    x.lo = -1;
    x.up = 2;
    x.fx = 0;
    """
    m = G.parse_model(mod)
    # fx wins over lo/up since each push! replaces the variable
    # entry with the latest mutation.
    @test m.variables["x"].fixed_value == "0"
    return
end

function test_parse_model_skips_blank_commands()
    # Trailing `;` and double `;;` produce empty commands which
    # should be skipped silently.
    m = G.parse_model("Variables x;;;\n;\n;")
    @test haskey(m.variables, "x")
    return
end

function test_parse_model_with_star_comment_and_dollar_directive()
    # Cover the preprocessor's two skip patterns end-to-end. The
    # preprocessor only drops *individual* lines starting with `*`
    # or `\$`; it doesn't track multi-line comment regions.
    mod = """
    * Single-line star comment.
    \$title some directive
    Variables x;
    """
    m = G.parse_model(mod)
    @test haskey(m.variables, "x")
    return
end

# ============================================================
# read_model — file-based entry point
# ============================================================

function test_read_model_round_trip_first_example()
    # Read the committed `first_example.gms` (not in the submodule)
    # and re-render — must equal the committed `first_example.jl`.
    input = joinpath(@__DIR__, "input", "first_example.gms")
    expected = read(joinpath(@__DIR__, "output", "first_example.jl"), String)
    model = G.read_model(input)
    @test sprint(print, model) * "\n" == expected
    return
end

end  # module

TestGAMSParser.runtests()
