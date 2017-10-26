using MXNet
# main training function
function TrainNet(data, trainsize, noutputs, net, batchsize, epochs, savefile)
    # prepare data
    data, mX, sX = stnorm(data)
    Y = data[1:trainsize,1:noutputs]'
    YT = data[trainsize+1:end,1:noutputs]'
    X = data[1:trainsize,noutputs+1:end]'
    XT = data[trainsize+1:end,noutputs+1:end]'
    Outputsize = size(Y,1)
    # final model definition, don't change, except if using gpu
    model = mx.FeedForward(net, context=mx.cpu())
    # set up the optimizer: select one, explore parameters, if desired
    #optimizer = mx.SGD(lr=0.01, momentum=0.9, weight_decay=0.00001)
    optimizer = mx.ADAM()
    trainprovider = mx.ArrayDataProvider(:data => X, batch_size=batchsize, shuffle=true, :label => Y)
    evalprovider = mx.ArrayDataProvider(:data => XT, batch_size=batchsize, shuffle=true, :label => YT)
    # train
    mx.fit(model, optimizer, eval_metric=mx.MSE(), initializer=mx.UniformInitializer(0.05), trainprovider, eval_data=evalprovider, n_epoch = epochs)
    # more training with larger batch size, saving the final fitted model
    batchsize = 10*batchsize
    mx.fit(model, optimizer, eval_metric=mx.MSE(), trainprovider, eval_data=evalprovider, n_epoch = 20, callbacks=[mx.do_checkpoint(savefile, frequency=20, save_epoch_0=false)])
end    


