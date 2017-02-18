# Newey-West covariance estimator
function NeweyWest(Z,nlags)
#=
    Returns the Newey-West estimator of the asymptotic variance matrix
    INPUTS: Z, a nxk matrix with rows the vector zt'
            nlags, the number of lags
    OUTPUTS: omegahat, the Newey-West estimator of the covariance matrix
=#
    n,k = size(Z)
    # de-mean the variables
    Z = Z .- mean(Z,1)
    omegahat = Z'*Z/n # sample variance
    if nlags > 0
       # sample autocovariances
       for i = 1:nlags
          Zlag = Z[1:n-i,:]
          ZZ = Z[i+1:n,:]
          gamma = (ZZ'*Zlag)/n
          weight = 1.0 - (i/(nlags+1.0))
          omegahat += weight*(gamma + gamma')
       end
    end    
    return omegahat
end
