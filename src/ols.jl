using Distributions
# OLS fit and report results
function ols(y, x; names="", vc="white", silent=false)
    n,k = size(x)
    if names==""
        names = 1:k
        names = names'
    end
    b, fit, e = lsfit(y,x)
    sigsq = (e'*e/(n-k))[1,1]
    xx_inv = inv(x'*x)
    ess = (e' * e)[1,1]

    # Ordinary or het. consistent variance estimate
    if vc=="white"
        xe = x.*e
        varb = xx_inv*xe'*xe*xx_inv
    elseif vc=="nw"
        xe = x.*e
        lags = Int(max(round(n^0.25),1))
        varb = n*xx_inv*NeweyWest(xe,lags)*xx_inv
    else
        varb= xx_inv.*sigsq
    end
    seb = sqrt(diag(varb))
    t = b ./ seb
    tss = y - mean(y)
    tss = (tss'*tss)[1,1]
    rsq = (1.0 - ess / tss)
    labels = ["coef", "se", "t", "p"]
    if !silent
        println("******************************************")
        @printf("  OLS estimation, %d observations\n", n)
        @printf("  R^2: %f   Sig^2: %f\n", rsq, sigsq)
        p = 2.0 - 2.0*cdf(TDist(n-k),abs(t))
        results = [b seb t p]
        if vc=="white"
            println("  White's covariance estimator")

        elseif vc=="nw"
            println("  Newey-West covariance estimator")
        end
        println()
        prettyprint(results, labels, names)
        println("******************************************")
    end
    return b, varb, e, ess, rsq;
end 
