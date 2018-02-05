"""
    mle(model, θ)

Maximum likelihood estimation.

* model should be a function that gives the vector of log likelihoods of 
the observations
* θ is the parameter vector
* execute mleresults() for an example, or edit(mleresults,()) to see the code.

"""

function mle(model, θ)
    avg_obj = θ -> -mean(vec(model(θ))) # average log likelihood
    thetahat, objvalue, converged = fminunc(avg_obj, θ) # do the minimization of -logL
    objvalue = -objvalue
    obj = θ -> vec(model(θ)) # unaveraged log likelihood
    n = size(obj(θ),1) # how many observations?
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
    println("mle(), with no arguments, runs mleresults(), which show usage")
    mleresults()
end 
