include("Ball_Bot A.jl") 
using POMDPs
# import a solver from POMDPs.jl e.g. QMDP, SARSOP
using SARSOP
using QMDP
# for visualization
using POMDPGifs
import Cairo, Fontconfig
using POMDPSimulators, POMDPPolicies, Distributions

pomdp = BallBot()    # initialize the problem 
#solver = SARSOPSolver(precision=0.01, timeout=10.0) # configure the solver
#solver = QMDPSolver(max_iterations=100,verbose=true)
solver=RandomSolver()

@time policy = solve(solver, pomdp) # solve the problem

sim = RolloutSimulator()
# sim = GifSimulator(filename="out.gif", max_steps=30)

r = Vector{Float64}(undef, 1000)
counter = 0
for i in 1:1000
    p = simulate(sim, pomdp, policy)
    if p < 0
        global counter += 1
    end
    r[i] = p
end

print(fit(Normal, r))
println(counter)
