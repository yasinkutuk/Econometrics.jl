# computes GARCH(1,1) log likelihood
function garch11(theta, y, x)
    # dissect the parameter vector
    mu = theta[1:end-3]
    omega = theta[end-2]
    alpha = theta[end-1]
    beta = theta[end]
    e = y - x*mu
    n = size(e,1)
    h = zeros(n)
    # initialize variance; either of these next two are reasonable choices
    h[1] = var(y[1:10])
    # h[1] = var(y)
    for t = 2:n
        h[t] = omega + alpha*e[t]^2.0 + beta*h[t-1]
    end
    logL = -log(sqrt(2.0*pi)) - 0.5*log.(h) - 0.5*(e.^2.0)./h
end    
