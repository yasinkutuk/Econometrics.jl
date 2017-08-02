function gmmresults(moments, theta, weight, title="", names="", efficient=true)
    n = size(moments(theta),1)
    thetahat, objvalue, D, ms, converged = gmm(moments, theta, weight)
    k,g = size(D)
    # estimate asymptotic variance
    V = inv(D*weight*D')
    if !efficient
        omega = NeweyWest(ms)
        V = V*D*weight*omega*weight*D'*V
    end
    V = V/n # adapt to sample size, for inference
    if names==""
        names = 1:k
        names = names'
    end
    se = sqrt.(diag(V))
    t = thetahat ./ se
    p = 2.0 .- 2.0*cdf(TDist(n-k),abs.(t))
    if converged == true convergence="Normal convergence"
    else convergence="No convergence"
    end
    println("************************************************************")
    if title !="" println(title) end
    println("GMM Estimation Results")
    println("BFGS convergence: ", convergence)
    println("Observations: ", n)
    println("Hansen-Sargan statistic: ", round(n*objvalue,5))
    if g > k
        println("Hansen-Sargan p-value: ", 1.0 - cdf(Chisq(g-k),n*objvalue))
    end    
    a =[thetahat se t p]
    clabels = ["estimate", "st. err", "t-stat", "p-value"]
    println("")
    prettyprint(a, clabels, names)
    println()
    println("************************************************************")
    return thetahat, objvalue, V, converged
end    

function gmmresults()
    # example of GMM: draws from N(0,1)
    y = randn(100,1)
    # 3 moment conditions
    moments = theta -> [y-theta[1] (y.^2.0).-theta[2] (y.-theta[1]).^3.0]
    # first round consistent
    W = eye(3)
    theta = [0.0, 1.0]
    thetahat, objvalue, D, ms, converged = gmm(moments, theta, W)
    # second round efficient
    W = inv(NeweyWest(ms))
    prettyprint(W)
    gmmresults(moments, thetahat, W, "GMM example");
end    


