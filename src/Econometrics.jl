VERSION > v"0.4-" && __precompile__()

module Econometrics

# Utilities
include("stnorm.jl")
include("prettyprint.jl")
include("sortbyc.jl")
include("dstats.jl")
include("lag.jl")
include("lags.jl")
# linear regression
include("lsfit.jl")
include("ols.jl")
include("tsls.jl")
include("NeweyWest.jl")
# nonparametrics
include("npreg.jl")
include("kernelweights.jl")
include("TrainNet.jl")
include("AnalyzeNet.jl")
# optimization
include("samin.jl")
include("fminunc.jl")
include("fmincon.jl")
export stnorm,prettyprint, sortbyc, dstats, lag, lags
export lsfit, ols, tsls, NeweyWest
export npreg, kernelweights,TrainNet, AnalyzeNet
export samin, fminunc, fmincon

end

