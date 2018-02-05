#= 

simple MCMC 
use this for a model by pointing
mcmcPrior = θ -> your_prior(θ, whatever other args)
mcmcLnL = θ -> your_log_likelihood(θ, whatever other args)
mcmcProposal = θ -> your_proposal(θ, whatever other args)
mcmcProposalDensity = (θᵗ,θ) -> 1.0 if proposal is symmetric, or to the real density, if not
θ is the current parameter, θᵗ is the trial value

called with no arguments, runs the simple example at the bottom

=#
using Distributions

function mcmc()
    println("mcmc(), called with no arguments, runs a simple example")
    println("execute edit(mcmc,()) to see the code")
    # sample is from exponential, prior is lognormal, proposal is random walk lognormal
    y = rand(Exponential(3.0),30)
    # set prior, likelihood and proposal
    Prior = θ -> pdf(LogNormal(1.0,1.0), θ) 
    lnL = θ -> sum(logpdf.(Exponential(θ),y))
    tuning = 0.5
    Proposal = θ -> rand(LogNormal(log(θ),tuning)) 
    # get the chain, plot posterior, and descriptive stats
    chain = mcmc(1.0, 100000, 10000, Prior, lnL, Proposal) # start value, chain length, and burnin 
    p = npdensity(chain[:,1]) # nonparametric plot of posterior density 
    plot!(p, title="posterior density, simple MCMC example: true value = 3.0") # add a title
    display(p)
    dstats(chain)
    return
end

# method to allow skipping proposal density when symmetric
function mcmc(θ, reps, burnin, Prior, lnL, Proposal::Function, report=true::Bool)
    ProposalDensity = (a,b) -> 1.0
    mcmc(θ, reps, burnin, Prior, lnL, Proposal, ProposalDensity, report)
end    


function mcmc(θ, reps, burnin, Prior, lnL, Proposal, ProposalDensity, report=true)
    reportevery = Int((reps+burnin)/100)
    lnLθ = lnL(θ)
    chain = zeros(reps, size(θ,1)+1)
    naccept = zeros(size(θ,1))
    for rep = 1:reps+burnin
        θᵗ = Proposal(θ) # new trial value
        i = .!(θᵗ .== θ) # find which changed
        lnLθᵗ = lnL(θᵗ)
        # MH accept/reject
        accept = rand() < 
            exp(lnLθᵗ-lnLθ)*
            Prior(θᵗ)/Prior(θ)*
            ProposalDensity(θ,θᵗ)/ProposalDensity(θᵗ,θ)
        if accept
            θ = copy(θᵗ)
            lnLθ = lnLθᵗ 
        end
        naccept[i] += accept
        if (mod(rep,reportevery)==0 & report)
            println(θ)
            println("acceptance rate: ", size(θ,1)*naccept/reportevery)
            naccept = naccept - naccept
        end    
        if rep > burnin
            chain[rep-burnin,:] = [θ; accept]
        end    
    end
    return chain
end


