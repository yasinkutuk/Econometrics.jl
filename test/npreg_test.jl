using Winston
include("kernelweights.jl")
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
function npreg(y, x, xeval, weights, order)
    weights = sqrt(weights)
    neval, dimx = size(xeval)
    n, dimy = size(y)
    stacked = [x; xeval]
    # local constant
    if order==0            
        X = ones(n,1)
        Xeval = ones(neval,1)
    end    
    # local linear
    if order==1        
        X = [ones(n,1) x]
        Xeval = [ones(neval,1) xeval]
    end
    # local quadratic
    if order==2
        # cross products
        CP = zeros(n+neval, Int((dimx-1)*dimx/2))
        cpind = 0
        @inbounds for i = 1:dimx-1
            @inbounds for j = i+1:dimx
                cpind += 1
                CP[:,cpind] = stacked[:,i].*stacked[:,j]
            end
        end
        ZZ = [ones(n+neval,1) stacked CP]
        X = sub(ZZ,1:n,:)
        Xeval = sub(ZZ,(n+1):n+neval,:)
    end
    # do the fit
    yhat = zeros(neval, dimy)
    @inbounds for i = 1:neval
        WX = weights[:,i] .* X
        Wy = weights[:,i] .* y
        b = WX\Wy
        yhat[i,:] = Xeval[i,:]*b
    end    
    return yhat
end

function main()
order = 2 # 0 for local constant, 1 for local linear, 2 for local quadratic
k = 3 # number of regressors

bandwidth = 0.07
n = 100000
neval = 100
x = rand(n,k)*pi*2.
xeval = [pi*ones(neval,k-1) linspace(pi/2.,pi*1.5,neval)]
y = cos(sum(x,2)) + cos(2. * sum(x,2)) + 0.5*randn(n,1)
ytrue = cos(sum(xeval,2)) + cos(2. * sum(xeval,2))

@time weights = kernelweights(x, xeval, bandwidth, true, "gaussian", 200)
@time yhat = npreg(y, x, xeval, weights, order)
plot(xeval[:,k], [yhat ytrue])
end
@time main()
