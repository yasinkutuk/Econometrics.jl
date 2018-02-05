using Distributions
function mleresults()
    println("execute edit(mleresults,()) to examine the example code")
    x = randn(100,3)
    beta = rand(3)
    println("true betas: ")
    prettyprint(beta)
    y = zeros(100)
    for i = 1:100
        y[i] = rand(Poisson(exp.(x[i,:]'beta)))
    end    
    model = theta -> poisson(theta, y, x)
    mleresults(model, beta, "simple ML example");
end    

function mleresults(model, theta, title="", names="")
    n = size(model(theta),1)
    thetahat, objvalue, V, converged = mle(model, theta)
    k = size(V,1)
    if names==""
        names = 1:k
        names = names'
    end
    se = sqrt.(diag(V))
    t = thetahat ./ se
    p = 2.0 .- 2.0*cdf.(TDist(n-k),abs.(t))
    if converged == true convergence="Normal convergence"
    else convergence="No convergence"
    end
    PrintDivider()
    if title !="" println(title) end
    println("MLE Estimation Results")
    println("BFGS convergence: ", convergence)
    println("Average Log-L: ", round(objvalue,5))
    println("Observations: ", n)
    a =[thetahat se t p]
    println("")
    PrintEstimationResults(a, names)
    println()
    println("Information Criteria")
    caic = -2.0*n*objvalue + k*(log(n)+1.0)
    bic = -2.0*n*objvalue + k*log(n)
    aic = -2.0*n*objvalue + 2.0*k
    infocrit = round.([caic; bic; aic],5)
    infocrit = round.([infocrit infocrit/n],5)
    clabels = ["Crit.", "Crit/n"]
    rlabels = ["CAIC ", "BIC ", "AIC "]
    prettyprint(infocrit, clabels, rlabels)
    PrintDivider()
    return thetahat, objvalue, V, converged
end    

