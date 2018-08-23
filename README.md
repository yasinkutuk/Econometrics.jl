# Econometrics.jl
Functions for econometrics, and supporting utilities. Has maximum likelihood, fminunc and fmincon replacements, some nonparametrics, some utilities, neural nets, etc.

The master branch is now 100% Julia 1.0 compatible, I believe. For Julia 0.6.x, use release 1.0.

This is used in the graduate econometrics lecture notes at https://github.com/mcreel/Econometrics

To install this, execute add https://github.com/mcreel/Econometrics.jl.git from the Julia pkg prompt, then access the functions by "using Econometrics".

The main functions will run a simple explanatory example if called with no arguments, e.g.,
ols()

fminunc()

fmincon()

samin()

mcmc()

mleresults()

gmmresults()

Basic OLS:
![OLS](https://github.com/mcreel/Econometrics.jl/blob/master/ols.png)

Maximum likelihood:
![ml](https://github.com/mcreel/Econometrics.jl/blob/master/ml.svg)

GMM:
![gmm](https://github.com/mcreel/Econometrics.jl/blob/master/gmm.svg)

MCMC:
![mcmc](https://github.com/mcreel/Econometrics.jl/blob/master/mcmc.svg)



