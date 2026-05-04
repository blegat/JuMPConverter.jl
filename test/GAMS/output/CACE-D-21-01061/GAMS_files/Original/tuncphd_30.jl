using JuMP
function build_model()
    model = Model()
    @variable(model, 0 <= x1 <= 1e2)
    @variable(model, 0 <= x2 <= 1e2)
    @variable(model, 0 <= x3 <= 1e2)
    @variable(model, 0 <= x4 <= 1e2)
    @variable(model, 0 <= x5 <= 1e2)
    @variable(model, 0 <= x6 <= 1e2)
    @variable(model, obj)
    @constraint(model, ob, 0.0204*x1*x4*(x1+x2+x3) + 0.0187*x2*x3*(x1+1.57*x2+x4) + 0.0607*x1*x4*x5*x5*(x1+x2+x3) + 0.0437*x2*x3*x6*x6*(x1+1.57*x2+x4) == obj)
    @constraint(model, c1, 0.001*x1*x2*x3*x4*x5*x6 - 2.07 >= 0)
    @constraint(model, c2, 0.00062*x1*x4*x5*x5*(x1+x2+x3)+0.00058*x2*x3*x6*x6*(x1+1.57*x2+x4) <= 1)
    @objective(model, Min, obj)
    optimize!(model)
    return model
end
