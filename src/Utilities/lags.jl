# returns the variable (or matrix), lagged from 1 to p times,
# with the first p rows filled with ones (to avoid divide errors)
# remember to drop those rows before doing analysis
function  lags(x,p)
	n, k = size(x)
	lagged_x = zeros(n,p*k)
	for i = 1:p
		lagged_x[:,i*k-k+1:i*k] = lag(x,i)
	end
    return lagged_x
end	 
