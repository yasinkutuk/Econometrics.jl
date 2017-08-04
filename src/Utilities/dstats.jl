using StatsBase
function dstats(x, rnames="")
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
    cnames = ["mean", "std", "skew", "kurt", "min", "max"]
    stats = [m' s' sk' k' mn' mx'] 
    prettyprint(round.(stats,3), cnames, rnames);
    return stats
end    


