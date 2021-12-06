function POMDPModelTools.render(pomdp::BallBot, step;
    viz_rock_state=true)

    
    nx, ny = pomdp.size
    cells = []
    for x in 1:nx, y in 1:ny
        
        ctx = cell_ctx((x,y), (nx,ny))
        
        clr = "white" # default cell color 

        if x >= 4 && x<=5 && y >= 3 && y<=6
            clr = "light salmon"
        end

        # if  DSPos(x, y) == pomdp.region_B
        #     clr = "green"  
        # end
        if  (DSPos(x, y) == [1,1])||(DSPos(x, y) == [1,8])
            clr = "green"  
        end

        if (DSPos(x, y) == [8,2])||(DSPos(x, y) == [8,7])
            clr="darkseagreen1"
        end

        if DSPos(x, y) == pomdp.region_B 
            clr = "snow4"  
        end

    
        if get(step, :s, nothing) != nothing 
            if in_fov(pomdp, step[:s].bot, DSPos(x,y))
                clr = ARGB(0.0, 0., 1.0, 0.9) # if in fov sets colour to blue
            end
        end
        
        cell = compose(ctx, rectangle(), fill(clr))
        push!(cells, cell)
    end
    
    grid = compose(context(), linewidth(0.5mm), stroke("gray"), cells...)
    outline = compose(context(), linewidth(1mm), rectangle())
    
    if get(step, :s, nothing) != nothing
        bot_ctx = cell_ctx(step[:s].bot, (nx,ny))
        bot = render_bot(bot_ctx)   
        player_ctx = cell_ctx(step[:s].player, (nx, ny))    
        player = render_player(player_ctx)
    else
        bot = nothing
        player = nothing
        action = nothing
    end

    sz = min(w,h)
    
    return compose(context((w-sz)/2, (h-sz)/2, sz, sz), bot, player, grid, outline)

end


function cell_ctx(xy, size)
    nx, ny = size
    x, y = xy
    return context((x - 1)/nx, (ny-y)/ny, 1/nx, 1/ny)
end


# Design the ballbot
function render_bot(ctx)
    center = compose(context(), ellipse(0.5, 0.5, 0.20, 0.3), fill("orange"), stroke("black"))
    ld_rot = compose(context(), circle(0.2,0.8,0.17), fill("gray"), stroke("black"))
    rd_rot = compose(context(), circle(0.8,0.8,0.17), fill("gray"), stroke("black"))
    lu_rot = compose(context(), circle(0.2,0.2,0.17), fill("gray"), stroke("black"))
    ru_rot = compose(context(), circle(0.8,0.2,0.17), fill("gray"), stroke("black"))
    return compose(ctx, ld_rot, rd_rot, lu_rot, ru_rot, center)
end

# Design the player
function render_player(ctx)
    body = compose(context(), ellipse(0.5, 0.5, 0.3, 0.2), fill("red"), stroke("black"))
    head = compose(context(), circle(0.5, 0.5, 0.15), fill("black"), stroke("black"))
    return compose(ctx, head, body)
end

function in_fov(pomdp::BallBot, bot::DSPos, s::DSPos)
    return abs(s[1] - bot[1]) < pomdp.fov[1] - 1 && abs(s[2] - bot[2]) < pomdp.fov[2] - 1
end