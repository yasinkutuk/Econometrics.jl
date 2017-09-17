# nonparametric regression, using pre-generated weights
# can be local constant, local linear, or local quadratic
#
# y is n X p
# x is n X dimx
# xeval is neval X dimx
# weights is n X neval (different weights for each eval. point)
#
# weights should sum to one by columns, they are typical 
# nonparametric weights from a kernel.

function npreg()
    println("npreg(), with no arguments, runs Pkg.dir/Econometrics/examples/npreg_example.jl")
    println("examine that file for information on how to call npreg.jl")
    include(Pkg.dir()*"/Econometrics/examples/npreg_example.jl")
end 

function npreg(y::Array{Float64,2}, x::Array{Float64,2}, xeval::Array{Float64,2}, weights::Array{Float64,2}, order::Int64=1, do_median::Bool=false, do_ci::Bool=false)
    weights = sqrt.(weights)
    neval, dimx = size(xeval)
    n, dimy = size(y)
    # local constant
    if order==0            
        X = ones(n,1)
        Xeval = ones(neval,1)
    elseif order==1    
    # local linear    
        X = [ones(n,1) x]
        Xeval = [ones(neval,1) xeval]
    else
    # local quadratic
        stacked = [x; xeval]
        # cross products
        CP = Array{Float64}(n+neval, Int((dimx-1)*dimx/2))
        cpind = 0
        for i = 1:dimx-1
            for j = (i+1):dimx
                cpind += 1
                CP[:,cpind] = stacked[:,[i]].*stacked[:,[j]]
            end
        end
        ZZ = [ones(n+neval,1) stacked CP]
        X = view(ZZ,1:n,:)
        Xeval = view(ZZ,(n+1):n+neval,:)
    end
    # do the fit
    yhat = Array{Float64}(neval, dimy)
    for i = 1:neval
        WX = weights[:,i] .* X
        Wy = weights[:,i] .* y
        b = WX\Wy
        yhat[i,:] = Xeval[[i],:]*b
    end    
    return yhat
end
