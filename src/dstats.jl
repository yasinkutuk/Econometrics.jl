using StatsBase
function dstats(x)
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
    names = ["mean", "std", "skew", "kurt", "min", "max"]
    stats = [m' s' sk' k' mn' mx'] 
    prettyprint(stats, names)
    return stats
end    


