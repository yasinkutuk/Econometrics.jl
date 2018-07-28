using Distributions, Plots, Random
"""
simple univariate kernel density that uses rule-of-thumb
bandwidth and Gaussian kernel
* x is n-vector of data
* xeval is neval-vector of evaluation points
* output is neval-vector of estimated densities

execute ndens() for an example
"""
function npdens()
    println("ndens(), with no arguments, runs a simple example")
    println("execute edit(ndens,()) to see the code")
    srand(1) # set seed to enable testing
    bandwidth = 1.0
    x = rand(Chisq(5),1000)
    xeval = Array(range(0.0, stop=30.0, length = 100))
    d = npdens(x, xeval)
    dt = pdf.(Ref(Chisq(5)), xeval)
    plot(xeval, d, label="kernel")
    plot!(xeval, dt, label="true")
end 

function npdens(x::Array{Float64,1}, xeval::Array{Float64,1})
    neval = size(xeval,1)
    dens = zeros(neval)
    n = size(x,1)
    bandwidth = 1.06*std(x)/(n^0.2) # rule-of-thumb: replace with CV?
    dist = Normal(0.0,1.0)
    for i = 1:neval
        dens[i] = mean(pdf.(Ref(dist), (x .- xeval[i])./bandwidth))
    end
    dens ./= bandwidth
end
