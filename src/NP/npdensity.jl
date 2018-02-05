# plots kernel density summary of data, with 90% acceptance region, mean and median.
using KernelDensity, Plots

function npdensity(z)
    pyplot()
    n = size(z,2)
    p = zeros(n)
    for i = 1:n
        x = z[:,i]
        y = kde(x)
        q05 = quantile(x,0.05)
        Plots.plot(linspace(minimum(x),q05,100),z->pdf(y,z), color=:orange, fill=(0,0.5,:orange), label="q05")
        q95 = quantile(x,0.95)
        Plots.plot!(linspace(q05,q95,100),z->pdf(y,z), color=:green, fill=(0,0.5,:green),label="90% acceptance region")
        Plots.plot!(linspace(q95,maximum(x),100),z->pdf(y,z), color = :orange, fill=(0,0.5,:orange),label="q95")
        m = mean(x)
        Plots.plot!([m,m],[0,pdf(y,m)],color=:blue, label="mean")
        m = median(x)
        if i == 1
            p = Plots.plot!([m,m],[0,pdf(y,m)],color=:black, label="median")
        else
            p = [p, Plots.plot!([m,m],[0,pdf(y,m)],color=:black, label="median")]
        end
    end
    return p
end 
