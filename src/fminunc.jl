# unrestricted OLS using optimize (Optim)
using Optim
function fminunc(obj, x)
    results = Optim.optimize(obj, x, LBFGS(), 
                            Optim.Options(
                            g_tol = 1e-6,
                            x_tol=1e-6,
                            f_tol=1e-12))
    return results.minimizer, results.minimum, Optim.converged(results)
end


