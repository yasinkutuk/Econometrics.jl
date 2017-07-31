# this is the log-likelihood for the linear model
# y = x*b+e, with e~N(0,s^2)
# the parameter theta = [b' s]
# this file is used for demonstration of MLE, to compare to OLS
function normal(theta, y, x)
    b = theta[1:end-1]
    s = theta[end]
	e = y - x*b
	logdensity = -log.(sqrt.(2.0*pi)) - log(sqrt(s^2.0)) - e.*e/(2.0*s^2.0)
end
