using MXNet
using PyPlot
using Distributions
using Econometrics

# main training function
function TrainNet(data, trainsize, noutputs, layerconfig, batchsize, epochs, savefile)
    # prepare data
    data, mX, sX = stnorm(data)
    Y = data[1:trainsize,1:noutputs]'
    YT = data[trainsize+1:end,1:noutputs]'
    X = data[1:trainsize,noutputs+1:end]'
    XT = data[trainsize+1:end,noutputs+1:end]'
    # sizes of layers
    L1size = layerconfig[1]
    L2size = layerconfig[2]
    L3size = layerconfig[3]
    L4size = layerconfig[4]
    Outputsize = size(Y,1)
    # set up 2 layer MLP with 2 outputs
    data = mx.Variable(:data)
    label = mx.Variable(:label)
    if L4size != 0
        net  = @mx.chain    mx.FullyConnected(data = data, num_hidden=L1size) =>
                            mx.Activation(act_type=:relu) =>
                            mx.FullyConnected(num_hidden=L2size) =>
                            mx.Activation(act_type=:tanh) =>
                            mx.FullyConnected(num_hidden=L3size) =>
                            mx.Activation(act_type=:relu) =>
                            mx.FullyConnected(num_hidden=L4size) =>
                            mx.Activation(act_type=:tanh) =>
                            mx.FullyConnected(num_hidden=Outputsize)        
    elseif L3size != 0
        net  = @mx.chain    mx.FullyConnected(data = data, num_hidden=L1size) =>
                            mx.Activation(act_type=:relu) =>
                            mx.FullyConnected(num_hidden=L2size) =>
                            mx.Activation(act_type=:tanh) =>
                            mx.FullyConnected(num_hidden=L3size) =>
                            mx.Activation(act_type=:relu) =>
                            mx.FullyConnected(num_hidden=Outputsize)        
    else
        net  = @mx.chain    mx.FullyConnected(data = data, num_hidden=L1size) =>
                            mx.Activation(act_type=:relu) =>
                            mx.FullyConnected(num_hidden=L2size) =>
                            mx.Activation(act_type=:tanh) =>
                            mx.FullyConnected(num_hidden=Outputsize)        
    end
    # squared error loss is appropriate for regression, don't change
    cost = mx.LinearRegressionOutput(data = net, label=label)
    # final model definition, don't change, except if using gpu
    model = mx.FeedForward(cost, context=mx.cpu())
    # set up the optimizer: select one, explore parameters, if desired
    #optimizer = mx.SGD(lr=0.01, momentum=0.9, weight_decay=0.00001)
    optimizer = mx.ADAM()
    trainprovider = mx.ArrayDataProvider(:data => X, batch_size=batchsize, shuffle=false, :label => Y)
    evalprovider = mx.ArrayDataProvider(:data => XT, batch_size=batchsize, shuffle=false, :label => YT)
    mx.fit(model, optimizer, eval_metric=mx.MSE(), initializer=mx.UniformInitializer(0.02), trainprovider, eval_data=evalprovider, n_epoch = epochs)
    # more training with larger batch size, saving the final fitted model
    batchsize = 10*batchsize
    mx.fit(model, optimizer, eval_metric=mx.MSE(), trainprovider, eval_data=evalprovider, n_epoch = 20, callbacks=[mx.do_checkpoint(savefile, frequency=20, save_epoch_0=false)])
end    

# this script makes predictions, gets RMSEs, and plots the figure
function Analyze(savefile, data, trainsize, noutputs; title="", params="",doplot=false)
    Y = data[trainsize+1:end,1:noutputs]
    data, m, s = stnorm(data)
    X = data[trainsize+1:end,noutputs+1:end]'
    model = mx.load_checkpoint(savefile, 20, mx.FeedForward) # load trained model
    # obtain predictions
    provider = mx.ArrayDataProvider(:data => X)
    fit = mx.predict(model, provider)
    fit = fit'
    fit = fit.*s[:,1:noutputs]
    fit = fit.+m[:,1:noutputs]
    # compute RMSE
    error = Y - fit
    bias = mean(error,1)
    mse = mean(error.^2,1)
    rmse = sqrt(mse)
    rsq = 1.0 .- mse./mean((Y .- mean(Y,1)).^2,1)
    names = ["bias","rmse","mse","R2"]
    println()
    println("________________________________________")
    println("Neural net indirect inference results")
    if title != "" println(title) end
    if params != ""
        prettyprint([bias' rmse' mse' rsq'], names, params)
    else
        prettyprint([bias' rmse' mse' rsq'], names)
    end     
    println("________________________________________")
    if doplot
        # get the first layer parameters for influence analysis
        model = mx.load_checkpoint(savefile, 20) # load trained model
        beta = copy(model[2][:fullyconnected0_weight])
        z = maximum(abs(beta),2);
        cax3 = matshow(z', interpolation="nearest")
        colorbar(cax3)
        ninputs = size(z,1)
        xlabels = [string(i) for i=1:ninputs]
        xticks(0:ninputs-1, xlabels)
        println("") # stop PyPlot screen spam
    end
    return fit
end

