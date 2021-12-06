function POMDPs.transition(pomdp::BallBot, s::DSState, a::Int64)
    # check for termination condition
    if (POMDPs.reward(pomdp,s,a) > 0)||(s.bot==s.player)
        return Deterministic(pomdp.terminal_state)
    end    

    # move bot
    new_bot = s.bot + ACTION_DIRS[a]

    if !(0 < new_bot[1] <= pomdp.size[1]) || !(0 < new_bot[2] <= pomdp.size[2])
        new_bot = s.bot #check if bot is going out of bounds and stay in the same state if TRUE
    end
    
    # move player 
    new_states = MVector{N_ACTIONS, DSState}(undef)
    probs = @MVector(zeros(N_ACTIONS))

    for (i, act) in enumerate(ACTION_DIRS)
        new_player = s.player + act
        
        if player_inbounds(pomdp, new_player)
            new_states[i] = DSState(new_bot, new_player)
            probs[i] += 1.0
        else
            # new_states[i] =  DSState(new_bot, s.player)
            new_states[i] = pomdp.terminal_state 
        end
    end
    normalize!(probs, 1)
    return SparseCat(new_states, probs)

end

"""
    player_inbounds(pomdp::BallBot, s::DSPos)
returns true if s in an authorized position for the player
s must be on the baseline and outside of the target location/waiting stations
"""
function player_inbounds(pomdp::BallBot, s::DSPos)
    if !(pomdp.baseline_startgrid[1]-1 < s[1] < pomdp.baseline_startgrid[1]+pomdp.baseline_size[1]) || !(pomdp.baseline_startgrid[2]-1 < s[2] < pomdp.baseline_startgrid[2]+pomdp.baseline_size[2]) # bounding the player to an area near the baseline
        return false
    end
    if s == pomdp.region_A || s == pomdp.region_B
        return false 
    end
    return true
end