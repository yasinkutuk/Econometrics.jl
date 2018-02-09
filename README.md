# Econometrics.jl
Functions for econometrics, and supporting utilities. Has maximum likelihood, fminunc and fmincon replacements, some nonparametrics, some utilities, neural nets, etc.

This is used in the graduate econometrics lecture notes at https://github.com/mcreel/Econometrics

To install this, execute Pkg.clone("https://github.com/mcreel/Econometrics.jl.git") from the Julia prompt, then access the functions by "using Econometrics".

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
![nn2](https://github.com/mcreel/Econometric

Figure out what statistics are important inputs to the neural net:
![nn](https://github.com/mcreel/Econometrics.jl/blob/master/nn.svg)

