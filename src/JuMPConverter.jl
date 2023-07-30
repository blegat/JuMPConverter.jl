module JuMPConverter

export convert_to

function parse_line(::IO, ::Val{:Model}, args) end
function parse_line(::IO, ::Val{:Equations}, args) end

function add_variables(io::IO, args, post)
    for name in args
        if endswith(name, ",")
            name = name[1:end-1]
        end
        println(io, "@variable(model, $name$post)")
    end
end

function _expect(s, exp)
    if s != exp
        error("Expected `$exp`, got `$s`")
    end
end

function parse_line(io::IO, ::Val{:Positive}, args)
    _expect(args[1], "Variables")
    return add_variables(io, args[2:end], " >= 0")
end

function parse_line(io::IO, ::Val{:Variables}, args)
    return add_variables(io, args, "")
end

function parse_line(io::IO, ::Val{:solve}, args)
    sign = args[4]
    if sign == "maximizing"
        jump_sign = "Max"
    else
        error("Unsupported sign $sign")
    end
    objective = args[5]
    println(io, "@objective(model, $jump_sign, $objective)")
    return println(io, "optimize!(model)")
end

function add_constraint(io::IO, name::AbstractString, args)
    print(io, "@constraint(model, $name, ")
    mapped = map(args) do arg
        if arg == "=e="
            return "=="
        elseif arg == "=l="
            return "<="
        else
            return arg
        end
    end
    print(io, join(mapped, " "))
    return println(io, ")")
end

function convert_line(io::IO, line)
    tokens = split(line)
    if isempty(tokens)
        return
    end
    if endswith(tokens[1], "..")
        add_constraint(io, tokens[1][1:end-2], tokens[2:end])
    else
        parse_line(io, Val(Symbol(tokens[1])), tokens[2:end])
    end
end

function convert_to(from, output::IO)
    current_line = ""
    open(from, "r") do input
        println(output, "using JuMP")
        println(output, "model = Model()")
        for line in eachline(input)
            statements = split(line, ';')
            if length(statements) > 1
                convert_line(output, current_line * statements[1])
                current_line = ""
            end
            for line in statements[2:end-1]
                convert_line(output, line)
            end
            current_line *= statements[end]
        end
        return convert_line(output, current_line)
    end
end

convert_to(from) = convert_to(from, Base.stdout)

function convert_to(from, to::AbstractString)
    open(to, "w") do output
        return convert_to(from, output)
    end
end

end # module JuMPConverter
