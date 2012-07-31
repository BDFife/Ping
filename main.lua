-- Löve Lua Tutorial

function love.load()
    x = 50
    y = 500
    base_speed = 100
    speed = 100
    direction = nil
end

function love.update(dt)
    -- this is kind of f'd up. " " is the spacebar. 
    if love.keyboard.isDown(" ") then
        x = 50
        y = 500
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
end

function love.draw()
    love.graphics.setColor(255,255,255,255)
    love.graphics.rectangle("fill", x, y, 100, 20)
end