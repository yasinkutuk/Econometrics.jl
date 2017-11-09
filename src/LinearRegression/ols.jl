using Distributions
# OLS fit and report results

function ols()
    println("ols(), with no arguments, runs Pkg.dir/Econometrics/examples/ols_example.jl")
    println("examine that file for information on how to call ols.jl")
    include(Pkg.dir()*"/Econometrics/examples/ols_example.jl")
end

function ols(y, x; R=[], r=[], names="", vc="white", silent=false)
    n,k = size(x)
    if names==""
        names = 1:k
        names = names'
    end
    b, fit, e = lsfit(y,x)
    df = n-k
    sigsq = (e'*e/df)[1,1]
    xx_inv = inv(x'*x)
    ess = (e' * e)[1,1]
    # Restricted LS?
    if R !=[]
        q = size(R,1)
        P_inv = inv(R*xx_inv*R')
        b = b - xx_inv*R'*P_inv*(R*b-r)
        e = y-x*b;
        ess = (e' * e)[1,1]
        df = n-k-q
        sigsq = ess/df
        A = eye(k) - xx_inv*R'*P_inv*R;  # the matrix relating b and b_r
    end
    # Ordinary or het. consistent variance estimate
    if vc=="white"
        xe = x.*e
        varb = xx_inv*xe'xe*xx_inv
    elseif vc=="nw"
        xe = x.*e
        lags = Int(max(round(n^0.25),1.0))
        varb = n*xx_inv*NeweyWest(xe,lags)*xx_inv
    else
        varb= xx_inv.*sigsq
    end
    # restricted LS?
    if R !=[]
        varb = A*varb*A'
    end
    # common to both ordinary and restricted
    seb = sqrt.(diag(varb))
    t = b ./ seb
    tss = y - mean(y)
    tss = (tss'*tss)[1,1]
    rsq = (1.0 - ess / tss)
    labels = ["coef", "se", "t", "p"]
    if !silent
        println()
        println("**************************************************")
        if R==[]
            @printf("  OLS estimation, %d observations\n", n)
        else
            @printf("  Restricted LS estimation, %d observations\n", n)
        end
        @printf("  R²: %f   σ²: %f\n", rsq, sigsq)
        p = 2.0 - 2.0*cdf.(TDist(df),abs.(t))
        results = [b seb t p]
        if vc=="white"
            println("  White's covariance estimator")

        elseif vc=="nw"
            println("  Newey-West covariance estimator")
        end
        println()
        prettyprint(results, labels, names)
        println("**************************************************")
    end
    return b, varb, e, ess, rsq
    ""
end
