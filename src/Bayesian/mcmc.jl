""" 
    chain = mcmc(θ, reps, burnin, Prior, lnL, Proposal)

    Simple MH MCMC

    You must set the needed functions, e.g.,:
    Prior = θ -> your_prior(θ, whatever other args)
    lnL = θ -> your_log_likelihood(θ, whatever other args)
    Proposal = θ -> your_proposal(θ, whatever other args)
    (optionally) mcmcProposalDensity = (θᵗ,θ) -> your_proposal_density

    then get the chain using the above syntax, or optionally,
    (non-symmetric proposal) chain = mcmc(θ, reps, burnin, Prior, lnL, Proposal, ProposalDensity, report=true)
    (example code) mcmc(): runs a simple example. edit(mcmc,()) to see the code

"""

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

# the main loop
<<<<<<< HEAD
function mcmc(θ, reps, burnin, Prior, lnL, Proposal, ProposalDensity, report=true)
    reportevery = Int((reps+burnin)/10)
=======
function mcmc(θ, reps, burnin, Prior, lnL, Proposal::Function, ProposalDensity::Function, report=true::Bool)
    reportevery = Int((reps+burnin)/100)
>>>>>>> ce5177d4a34cfab9bb7353644afccf01b43fed2e
    lnLθ = lnL(θ)
    chain = zeros(reps, size(θ,1)+1)
    naccept = zeros(size(θ,1))
    for rep = 1:reps+burnin
        θᵗ = Proposal(θ) # new trial value
        changed = .!(θᵗ .== θ) # find which changed
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
        naccept[changed] += accept
        if (mod(rep,reportevery)==0 && report)
            println(θ)
            println("acceptance rate by parameter: ", round.(naccept/reportevery,3))
            naccept = naccept - naccept
        end    
        if rep > burnin
            chain[rep-burnin,:] = [θ; accept]
        end    
    end
    return chain
end


