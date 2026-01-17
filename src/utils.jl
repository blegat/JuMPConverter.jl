function next_token(s::AbstractString, args...)
    token_rest = strip.(split(s, args...; limit = 2))
    if length(token_rest) == 1
        return token_rest[], ""
    else
        token, rest = token_rest
        return token, rest
    end
end

function _get_command(s::AbstractString, expected::Vector)
    for command::Pair in expected
        if isa(command.first, String)
            if startswith(s, command.first)
                rest = chop(s, head = length(command.first), tail = 0)
                return command.second(command.first, rest)
            end
        elseif isa(command.first, Regex)
            m = match(command.first, s)
            if m !== nothing
                rest = chop(s, head = length(m.match), tail = 0)
                return command.second(m.captures..., rest)
            end
        end
    end
    return error(
        "Cannot parse element, does not start with any of the commands $expected in:\"\n$s\"",
    )
end
