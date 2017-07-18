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
    p = 2.0 .- 2.0*cdf(TDist(n-k),abs.(t))
	if converged == true convergence="Normal convergence"
  	else convergence="No convergence"
    end
	println("******************************************************")
    if title !="" println(title) end
	println("MLE Estimation Results")
	println("BFGS convergence: ", convergence)
	println("Average Log-L: ", round(objvalue,5))
	println("Observations: ", n)
	a =[thetahat se t p]
	clabels = ["estimate", "st. err", "t-stat", "p-value"]
	println("")
	prettyprint(a, clabels, names)
    println()
	println("Information Criteria")
	caic = -2.0*n*objvalue + k*(log(n)+1.0)
	bic = -2.0*n*objvalue + k*log(n)
	aic = -2.0*n*objvalue + 2.0*k
	infocrit = [caic; bic; aic]
    infocrit = round.([infocrit infocrit/n],5)
    clabels = ["Crit.", "Crit/n"]
    rlabels = ["CAIC", "BIC", "AIC"]
    prettyprint(infocrit, clabels, rlabels)
	println("******************************************************")
    return thetahat, objvalue, V, converged
end    

