using Random
using LinearAlgebra
using POMDPs
using POMDPModelTools
using Parameters
using StaticArrays
using Compose
using Colors

export 
    DSPos,
    DSState,
    botCam,
    PerfectCam,
    BallBot


const DSPos = SVector{2, Int64}

struct DSState
    bot::DSPos
    player::DSPos
end


"""
    PerfectCam

When used as a camera model, the BallBot can detect the player with probability 1 when 
he/she is in its field of view.
"""
struct PerfectCam end

"""
    BallBot{M} <: POMDP{DSState, Int64, Int64}

# Fields 
- `size::Tuple{Int64, Int64} = (5,5)` size of the grid world
- `region_A::DSPos = [1, 1]` initial state of the bot
- `region_B::DSPos = [size[1], size[2]]` target location
- `fov::Tuple{Int64, Int64} = (3, 3)` size of the field of view of the ballbot
- `camera::M = PerfectCam()` observation model
- `terminal_state::DSState = DSState([-1, -1], [-1, -1])` terminal state
- `discount_factor::Float64 = 0.95` the discount factor
"""
@with_kw mutable struct BallBot{M} <: POMDP{DSState, Int64, Int64} #@with_kw allows assigning default values inside the struct
    size::Tuple{Int64, Int64} = (8,8)
    baseline_size::Tuple{Int64, Int64} = (2,4)
    baseline_startgrid::DSPos=[4,3]
    region_A::DSPos = rand([[1,1],[8,2],[1,8],[8,7]])
    region_B::DSPos = [4,4]#[rand(1:10),rand(1:10)]
    fov::Tuple{Int64, Int64} = (3, 3)
    camera::M = PerfectCam() 
    terminal_state::DSState = DSState([-1, -1], [-1, -1])
    discount_factor::Float64 = 0.95
end

POMDPs.isterminal(pomdp::BallBot, s::DSState) = s == pomdp.terminal_state 
POMDPs.discount(pomdp::BallBot) = pomdp.discount_factor

function POMDPs.reward(pomdp::BallBot, s::DSState, a::Int64)
    # if s.bot == s.player 
    #     return -1.0
    # end
    # if s.bot == pomdp.region_B
    #     return 1.0
    # end
    if s.bot == s.player 
        return -100
    elseif s.bot == pomdp.region_B
        return 100
    end
    return 0
end

include("states.jl")
include("actions.jl")
include("transition.jl")
include("observation.jl")
include("visualization_a.jl")
