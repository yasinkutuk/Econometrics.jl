VERSION > v"0.4-" && __precompile__()

module Econometrics
using Distributions

# Utilities
include("stnorm.jl")
include("prettyprint.jl")
include("sortbyc.jl")
# OLS
include("lsfit.jl")
include("ols.jl")
include("NeweyWest.jl")
# nonparametrics
include("npreg.jl")
include("kernelweights.jl")
# optimization
include("samin.jl")

export stnorm, lsfit, ols, prettyprint, sortbyc, NeweyWest
export npreg, kernelweights, samin

end

