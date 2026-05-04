using JuMP
function build_model()
    model = Model()
    @variable(model, -1 <= c11 <= 1.5)
    @variable(model, -1 <= c12 <= 1.5)
    @variable(model, -1 <= c21 <= 1.5)
    @variable(model, -1 <= c22 <= 1.5)
    @variable(model, obj)
    @constraint(model, ob, -15.73426*(c12*c12 + c11*c11) + 0.5721648*c12*c22*c21*c21 + 1.56814504*(c12*c12*c11*c21 + c11*c11*c12*c22) - 7.7290488*(c11*c21 + c12*c22) - 4.204318*(c21*c21 + c22*c22) + 2.2988306*((c11)^(4) + (c12)^(4)) + 4.5976612*c11*c11*c12*c12 - 1.329488452*c11*c21*c12*c22 + 0.8353663*c21*c21*c22*c22 + 0.41768315*((c21)^(4) + (c22)^(4)) + 2.124875442*(c11*c11*c22*c22 + c12*c12*c21*c21) + 1.460131216*(c12*c12*c22*c22 + c11*c11*c21*c21) + 0.5721648*(c11*c21*c21*c21 + c12*c22*c22*c22 + c11*c21*c22*c22) + 1.56814504*(c12*c12*c12*c22 + c11*c11*c11*c21) == obj)
    @constraint(model, c1, c11*c11 + c21*c21 + 2*c11*c21*0.259517 == 1)
    @constraint(model, c2, c12*c12 + c22*c22 + 2*c12*c22*0.259517 == 1)
    @constraint(model, c3, c11*c12 + c21*c22 + (c11*c22 + c21*c12)*0.259517 == 0)
    @objective(model, Min, obj)
    return model
end
