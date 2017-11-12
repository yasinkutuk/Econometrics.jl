# example of neural net functions in Econometrics.jl
using Econometrics

# generate draws from linear regression model, and
# fitted coefficients from correct model, plus
# quadratic and cubic models (irrelevant regressors)
# and 5 pure noise statistics
function make_simdata(reps=100000)
    n = 30
    simdata = zeros(reps, 35+6)
    for rep = 1:reps
        # draw the regressors
        x = randn(n,4)
        z = [ones(n,1) x]
        # draw the parameters from prior
        b = randn(5,1)
        sig = exp.(randn(1))
        # generate dependent variable
        y = z*b + sig.*randn(n,1)
        # linear model
        bhat1 = z\y
        uhat = y-z*bhat1
        sighat1 = sqrt.(uhat'*uhat/(n-size(z,2)))
        # quadratic model
        z = [ones(n,1) x 0.1*x.^2.0]
        bhat2 = z\y
        uhat = y-z*bhat2
        sighat2 = sqrt.(uhat'*uhat/(n-size(z,2)))
        # cubic model
        z = [ones(n,1) x 0.1*x.^2.0 0.01*x.^3.0]
        bhat3 = z\y
        uhat = y-z*bhat3
        sighat3 = sqrt.(uhat'*uhat/(n-size(z,2)))
        # pure noise
        z = randn(1,5)
        # assemble: 
        simdata[rep,:] = [b' log.(sig) bhat1' log.(sighat1) bhat2' log.(sighat2) bhat3' log.(sighat3) z]
    end
    return simdata
end

# fit a neural net to the linear model data, and show influence of statistics
function main()
    data = make_simdata()
    noutputs = 6
    trainsize = 80000
    savefile = "olsnet"
    layerconfig = [20, 10, 0, 0]
    epochs = 30
    TrainNet(data, trainsize, noutputs, layerconfig, 512, epochs, savefile)
    Y = data[trainsize+1:end,1:noutputs]
    olsfit = data[trainsize+1:end,(noutputs+1):(2*noutputs)]
    title = "linear regression example"
    params = ["constant", "x1","x2","x3","x4","x5"]
    fit = AnalyzeNet(savefile, epochs, data, trainsize, noutputs, title=title, params=params, doplot=true);
end
main();
