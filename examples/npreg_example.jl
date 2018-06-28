using Plots
order = 2 # 0 for local constant, 1 for local linear, 2 for local quadratic
k = 3 # number of regressors
srand(1) # set seed to enable testing by fact check
bandwidth = 0.07
n = 100000
neval = 100
x = rand(n,k)*pi*2.0
xeval = [pi*ones(neval,k-1) range(pi/2., stop=pi*1.5, length=neval)]
y = cos.(sum(x,2)) + cos.(2. * sum(x,2)) + 0.5*randn(n,1)
ytrue = cos.(sum(xeval,2)) + cos.(2. * sum(xeval,2))
weights = kernelweights(x, xeval, bandwidth, true, "gaussian", 200)
yhat = npreg(y, x, xeval, weights, order)
plot(xeval[:,k], [yhat ytrue])
