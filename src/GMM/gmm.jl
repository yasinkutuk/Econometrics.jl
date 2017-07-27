# moments() should return a nXg matrix of moment contributions
using Calculus
function gmm(theta, moments, weight)
    # average moments
    m = theta -> mean(moments(theta),1) # 1Xg
    # moment contributions
    momentcontrib = theta -> moments(theta) # nXg
    # GMM criterion
    obj = theta -> m(theta)*weight*m(theta)'
    # do minimization
    thetahat, objvalue, converged = fminunc(obj, theta)
    n = size(momentcontrib(theta),1) # how many observations?
    D = Calculus.jacobian(m', vec(thetahat), :central) 
    # covariance of moment contributions (need to add NW)
    omega = cov(scorecontrib)
    #HERE
    V = Jinv*I*Jinv/n # sandwich form is preferred
    #V = -Jinv/n      # other possibilities
    #V = inv(I)/n
    return thetahat, objvalue, V, converged
end    

