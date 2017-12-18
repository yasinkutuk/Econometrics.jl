using KernelDensity
function npdensity(x)
    y = kde(x)
    return linspace(extrema(x)..., 100), z->pdf(y, z)
end    
