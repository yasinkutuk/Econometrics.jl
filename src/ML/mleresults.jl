"""
    mleresults(model, θ)

Do maximum likelihood estimation, where model is a function that gives
the vector of log likelihoods of the observations, and θ is the
parameter vector. call edit(mleresults()) to see a coded example.

"""


function mleresults()
    println("execute edit(mleresults,()) to examine the example code")
    x = randn(100,3)
    β = rand(3)
    println("true betas: ")
    prettyprint(β)
    y = zeros(100)
    for i = 1:100
        y[i] = rand(Poisson(exp.(x[i,:]'β)))
    end
    model = β -> poisson(β, y, x)
    mleresults(model, β, "simple ML example");
end

function mleresults(model, θ, title="", names=""; vc=1)
    n = size(model(θ),1)
    thetahat, objvalue, V, converged = mle(model, θ, vc)
    k = size(V,1)
    if names==""
        names = 1:k
        names = names'
    end
    se = sqrt.(diag(V))
    t = thetahat ./ se
    p = 2.0 .- 2.0*cdf.(TDist(n-k),abs.(t))
    if converged == true convergence="Normal"
    else convergence="No convergence"
    end
    PrintDivider()
    if title !="" println(title) end
    print("MLE Estimation Results    BFGS convergence: ")
    if convergence=="Normal"
        print_with_color(:green, convergence)
        println()
    else
        print_with_color(:red, convergence)
        println()
    end    
    println("Average Log-L: ", round(objvalue, digits=5), "   Observations: ", n)
    if vc==1
        println("Sandwich form covariance estimator")
    elseif vc==2
        println("Inverse Hessian form covariance estimator")
    else
        println("OPG form covariance estimator")
    end
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
