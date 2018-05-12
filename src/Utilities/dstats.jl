using StatsBase
function dstats(x, rnames="";short=false)
    k = size(x,2)
    if rnames==""
        rnames = 1:k
        rnames = rnames'
    end
    m = mean(x,1)
    s = std(x,1)
    sk = m-m
    k = m-m
    for i = 1:size(x,2)
        sk[:,i] = skewness(x[:,i])
        k[:,i] = kurtosis(x[:,i])
    end
    mn = minimum(x,1)
    mx = maximum(x,1)
    q05 = zeros(k)
    q95 = zeros(k)
    if short == false
        for i = 1:size(x,2) q05[i] = quantile(x[:,i], 0.05) end
        for i = 1:size(x,2) q95[i] = quantile(x[:,i], 0.95) end
        cnames = ["  mean", "  std", "skew", "kurt", "min", "max", "q05", "q95"]
        stats = [m' s' sk' k' mn' mx' q05' q95'] 
        prettyprint(stats, cnames, rnames)
    else
        cnames = ["  mean", "  std", "skew", "kurt", "min", "max"]
        stats = [m' s' sk' k' mn' mx'] 
        prettyprint(stats, cnames, rnames)
    end
    return stats
end    


