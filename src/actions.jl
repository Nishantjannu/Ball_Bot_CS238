const N_ACTIONS = 5 #number of actions

const ACTIONS_DICT = Dict(:north => 1, 
                            :east => 2,
                            :south => 3,
                            :west => 4,
                            :hover => 5)

const ACTION_DIRS = (DSPos(0,1),
                     DSPos(1,0),
                     DSPos(0,-1),
                     DSPos(-1,0),
                     DSPos(0,0))
                     
POMDPs.actions(pomdp::BallBot) = 1:N_ACTIONS
POMDPs.actionindex(pomdp::BallBot, a::Int64) = a

POMDPs.actions(pomdp::BallBot, s::DSPos) = 1:N_ACTIONS