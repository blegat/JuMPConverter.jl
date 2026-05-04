using JuMP
function build_model()
    model = Model()
    @variable(model, 0 <= x1 <= 3)
    @variable(model, 0 <= x2 <= 12)
    @variable(model, 0 <= x3 <= 1)
    @variable(model, 0 <= x4 <= 2)
    @variable(model, 0 <= y1 <= 1.93318204493)
    @variable(model, 0 <= y2 <= 4.44128606985)
    @variable(model, objvar)
    @constraint(model, e1, -(y1 + y2 - 6*x1 - 4*x3 - 3*x4) + objvar == 0)
    @constraint(model, e2, -3*x1 + x2 - 3*x3 == 0)
    @constraint(model, e3, x1 + 2*x3 <= 4)
    @constraint(model, e4, x2 + 2*x4 <= 4)
    @constraint(model, e5, x1^3 - y1^5 == 0)
    @constraint(model, e6, x2^3 - y2^5 == 0)
    @objective(model, Min, objvar)
    return model
end
