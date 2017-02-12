# standardize and normalize
function stnorm(X)
    mX = mean(X,1)
    sX = std(X,1)
    X = (X .- mX) ./ sX
    return X, mX, sX
end
