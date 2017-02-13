using Plots

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
