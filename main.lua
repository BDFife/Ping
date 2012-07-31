-- Löve Lua Tutorial

function love.load()
    x = 50
    y = 500
    base_speed = 100
    speed = 100
    direction = nil
    ball_x = 0
    ball_y = 0
    x_vel = 0
    y_vel = 0
    ball = false
end

function love.update(dt)
    -- this is kind of f'd up. " " is the spacebar. 
    if love.keyboard.isDown(" ") then
        ball = true
        ball_x = 100
        ball_y = 100
        x_vel = 40
        y_vel = 40
    end
    
    if love.keyboard.isDown("right") then
        if direction == "right" then
           speed = speed + 10 
        else
            speed = base_speed
        end
        -- think about where the 0 actually is.
        -- yep, 0 is the left corner. 
        -- the upper left corner.  
        if x > 0 then
            x = x - (speed * dt )
        else
            x = 0
        end
        direction = "right"
        
    elseif love.keyboard.isDown("left") then
        if direction == "left" then
            speed = speed + 10
        else
            speed = base_speed
        end
        -- this is dirty, since the window resolution is implicit. Fixme! 
        -- edge detection
        if x < (800 - 100) then 
            x = x + (speed * dt )
        else
            x = (800 - 100) 
        end
        direction = "left"
        
    else
        speed = base_speed
        direction = nil
    end
    
    if ball == true then
        ball_x = ball_x + x_vel * dt
        ball_y = ball_y + y_vel * dt

    end
end

function love.draw()
    love.graphics.setColor(255,255,255,255)
    love.graphics.rectangle("fill", x, y, 100, 20)
    if ball == true then
        love.graphics.rectangle("fill", ball_x, ball_y, 15, 15)
    end
end