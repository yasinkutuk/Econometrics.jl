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
mleresults()
gmmresults()

Basic OLS:
![OLS](https://github.com/mcreel/Econometrics.jl/blob/master/ols.png)

Indirect inference using neural net to map overidentifying statistics to parameter:
![nn2](https://github.com/mcreel/Econometrics.jl/blob/master/nn2.svg)

Figure out what statistics are important inputs to the neural net:
![nn](https://github.com/mcreel/Econometrics.jl/blob/master/nn.svg)

