function POMDPs.stateindex(pomdp::BallBot, s::DSState)
    if isterminal(pomdp, s)
        return length(pomdp)
    end
    nx, ny = pomdp.size 
    nx1,ny1 = pomdp.baseline_size
    spx=s.player[1]-pomdp.baseline_startgrid[1]+1
    spy=s.player[2]-pomdp.baseline_startgrid[2]+1
    LinearIndices((nx, ny, nx1, ny1))[s.bot[1], s.bot[2], spx, spy]
end

function state_from_index(pomdp::BallBot, si::Int64)
    if si == length(pomdp)
        return pomdp.terminal_state
    end
    nx, ny = pomdp.size 
    nx1,ny1=pomdp.baseline_size
    s = CartesianIndices((nx, ny, nx1, ny1))[si]
    return DSState([s[1], s[2]], [s[3]+pomdp.baseline_startgrid[1]-1, s[4]+pomdp.baseline_startgrid[2]-1])
end

# defining the state space 
POMDPs.states(pomdp::BallBot) = [[DSState([x1, y1], [x2, y2]) for x1=1:pomdp.size[1], y1=1:pomdp.size[2], x2=pomdp.baseline_startgrid[1]:pomdp.baseline_startgrid[1]+pomdp.baseline_size[1]-1, y2=pomdp.baseline_startgrid[2]:pomdp.baseline_startgrid[2]+pomdp.baseline_size[2]-1]..., pomdp.terminal_state]

Base.length(pomdp::BallBot) = (pomdp.size[1] * pomdp.size[2])*(pomdp.baseline_size[1]*pomdp.baseline_size[2]) + 1

function Base.iterate(pomdp::BallBot, i::Int64 = 1)
    if i > length(pomdp)
        return nothing
    end
    s = state_from_index(pomdp, i)
    return (s, i+1)
end

function POMDPs.initialstate(pomdp::BallBot)
    bot = pomdp.region_A # starting position of bot
    states = DSState[] # possible states
    #restricting the initial state of the player to an area on the court
    xspace = pomdp.baseline_startgrid[1]:pomdp.baseline_startgrid[1]+pomdp.baseline_size[1]-1
    yspace = pomdp.baseline_startgrid[2]:pomdp.baseline_startgrid[2]+pomdp.baseline_size[2]-1
    for x in xspace
        for y in yspace
            player = DSPos(x, y)
            push!(states, DSState(bot, player))
        end
    end
    probs = normalize!(ones(length(states)), 1)
    return SparseCat(states, probs)
end