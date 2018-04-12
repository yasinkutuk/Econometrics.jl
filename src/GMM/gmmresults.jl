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
    gmmresults(moments, thetahat, W, "GMM example, two step");
    # CUE
    gmmresults(moments, thetahat, "", "GMM example, CUE");
end    

function gmmresults(moments, theta, weight, title="", names="", efficient=true)
    n,g = size(moments(theta))
    if weight !="" # if weight provided, use it
        thetahat, objvalue, D, ms, converged = gmm(moments, theta, weight)
    else # do CUE
        thetahat, objvalue, D, ms, converged = gmm(moments, theta)
        weight = inv(NeweyWest(ms))
    end
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
    p = 2.0 .- 2.0*cdf.(TDist(n-k),abs.(t))
    if converged == true convergence="Normal"
    else convergence="No convergence"
    end
    PrintDivider()
    if title !="" println(title) end
    print("GMM Estimation Results    BFGS convergence: ")
    if convergence=="Normal"
        print_with_color(:green, convergence)
        println()
    else
        print_with_color(:red, convergence)
        println()
    end
    println("Observations: ", n)
    println("Hansen-Sargan statistic: ", round(n*objvalue,5))
    if g > k
        println("Hansen-Sargan p-value: ", round(1.0 - cdf(Chisq(g-k),n*objvalue),5))
    end    
    a =[thetahat se t p]
    println("")
    PrintEstimationResults(a, names)
    println()
    PrintDivider()
    return thetahat, objvalue, V, converged
end    
