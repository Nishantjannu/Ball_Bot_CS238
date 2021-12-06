include("Ball_Bot B.jl")
using POMDPs
# import a solver from POMDPs.jl e.g. QMDP, SARSOP
using SARSOP
using QMDP
# for visualization
using POMDPGifs
import Cairo, Fontconfig

pomdp = BallBot()    # initialize the problem 
solver = SARSOPSolver(precision=0.01, timeout=10.0) # configure the solver
#solver = QMDPSolver(max_iterations=100,verbose=true)

@time policy = solve(solver, pomdp) # solve the problem

sim = GifSimulator(filename="out.gif", max_steps=30)
simulate(sim, pomdp, policy);
