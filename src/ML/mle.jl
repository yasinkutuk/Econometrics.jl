using Calculus
function mle(model, theta)
    avg_obj = theta -> -mean(vec(model(theta))) # average log likelihood
    thetahat, objvalue, converged = fminunc(avg_obj, theta) # do the minimization of -logL
    objvalue = -objvalue
    obj = theta -> vec(model(theta)) # unaveraged log likelihood
    n = size(obj(theta),1) # how many observations?
    scorecontrib = Calculus.jacobian(obj, vec(thetahat), :central)
    I = cov(scorecontrib)
    J = Calculus.hessian(avg_obj, vec(thetahat), :central)
    Jinv = inv(J)
    V = Jinv*I*Jinv/n # sandwich form is preferred
    #V = -Jinv/n      # other possibilities
    #V = inv(I)/n
    return thetahat, objvalue, V, converged
end    

function mle()
    println("mle(), with no arguments, runs Pkg.dir/Econometrics/examples/mle_example.jl")
    println("examine that file for information on how to call mle.jl")
    include(Pkg.dir()*"/Econometrics/examples/mle_example.jl")
end 
