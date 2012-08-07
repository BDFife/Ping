-- Löve Lua Tutorial

function speedup()
    -- this is for debug only 
    ball.x_vel = ball.x_vel * 1.2
    ball.y_vel = ball.y_vel * 1.2
end

function checkBoundaries(box_o, box_p, item_o, item_p, item_vel)
    -- item is within the boundaries
    if box_o < item_o and item_p < box_p then 
        return true
    else
        -- if the velocity is already correct, don't worry about it. 
        if box_o > item_o and item_vel > 0 then
            return true
        elseif item_p > box_p and item_vel < 0 then
            return true
        else
            -- item is outside the box and needs to 'bounce'
            return false
        end
    end
end
    

function love.load()
    
    paddle = { x = 50,
               y = 500,
               width = 100,
               height = 20,
               speed = 0,
               base_speed = 100,
               delta_speed = 10,
               direction = nil }
    
    ball =   { x = 0,
               y = 0,
               width = 15,
               height = 15,
               x_vel = 0,
               y_vel = 0,
               exists = false }

    screen = { width = love.graphics.getWidth(),
               height = love.graphics.getHeight(),
               origin = 0 }


    -- need to think about this in a more general sense
    debounce = false

end

function love.update(dt)
    -- this is kind of f'd up. " " is the spacebar. 
    if love.keyboard.isDown(" ") then
        ball.exists = true
        ball.x = 100
        ball.y = 100
        ball.x_vel = 60
        ball.y_vel = 200
        
    end
    

    
    if love.keyboard.isDown("down") then
        debug.debug()
    end
    
    if love.keyboard.isDown("up") then
        if debounce == false then
            speedup()
            debounce = true
        end
    else
        debounce = false
    end
    
    
    if love.keyboard.isDown("right") then
        if paddle.direction == "right" then
           paddle.speed = paddle.speed + paddle.delta_speed 
        else
            paddle.speed = paddle.base_speed
        end
        -- think about where the 0 actually is.
        -- yep, 0 is the left corner. 
        -- the upper left corner.  
        if paddle.x > screen.origin then
            paddle.x = paddle.x - (paddle.speed * dt )
        else
            paddle.x = screen.origin
        end
        paddle.direction = "right"
        
    elseif love.keyboard.isDown("left") then
        if paddle.direction == "left" then
            paddle.speed = paddle.speed + paddle.delta_speed
        else
            paddle.speed = paddle.base_speed
        end
        -- detect if paddle is at the end of the screen and if so, stop. 
        if paddle.x < (screen.width - paddle.width) then 
            paddle.x = paddle.x + (paddle.speed * dt )
        else
            paddle.x = (screen.width - paddle.width) 
        end
        paddle.direction = "left"
        
    -- if left or right isn't being pressed, stop the paddle. 
    else
        paddle.speed = paddle.base_speed
        paddle.direction = nil
    end
    
    if ball.exists == true then
        ball.x = ball.x + ball.x_vel * dt
        ball.y = ball.y + ball.y_vel * dt

        if not checkBoundaries(screen.origin, screen.width, ball.x, ball.x + ball.width,
                               ball.x_vel) then                               
            ball.x_vel = -1 * ball.x_vel
        end
        
        if not checkBoundaries(screen.origin, screen.height, ball.y, ball.y+ ball.height, 
                               ball.y_vel) then
            ball.y_vel = -1 * ball.y_vel
        end
        
        -- detect collision. probably shouldn't be here. 
        -- collision doesn't work when speed crosses a certain limit. This is because the 
        -- speed is so great it "blinks" past the paddle between frames. 
        -- bounce is a little 'edgy' - a square bounce on a trivial corner overlap
        
        if ball.y > (paddle.y - ball.height) then
            if ball.y < paddle.y then
                if paddle.x < (ball.x + ball.width) then
                    if ball.x < (paddle.x + paddle.width) then
                        if ball.y_vel > 0 then
                            ball.y_vel = -1 * ball.y_vel
                        end
                    end
                end
            end
        end




    end
end

function love.draw()
    love.graphics.setColor(255,255,255,255)
    love.graphics.rectangle("fill", paddle.x, paddle.y, paddle.width, paddle.height)
    if ball.exists == true then
        love.graphics.rectangle("fill", ball.x, ball.y, ball.width, ball.height)
    end
    
    --if checkBoundaries(0, screen.height, ball.y) then
    --    vel_str = "True"
    --else
    --    vel_str = "False"
    --end
    --love.graphics.print(vel_str, 10, 200)

end