VERSION > v"0.4-" && __precompile__()

module Econometrics
using Distributions

include("stnorm.jl")
include("lsfit.jl")
include("ols.jl")
include("prettyprint.jl")
include("sortbyc.jl")
include("NeweyWest.jl")

export stnorm, lsfit, ols, prettyprint, sortbyc, NeweyWest
end

