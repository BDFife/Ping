-- Löve Lua Tutorial

function love.load()
    paddle = { x = 50,
               y = 500,
               speed = 100,
               base_speed = 100,
               direction = nil }
    ball =   { x = 0,
               y = 0,
               x_vel = 0,
               y_vel = 0,
               exists = false }

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
    
    if love.keyboard.isDown("up") then
        if debounce == false then
            ball.x_vel = ball.x_vel * 1.2     
            ball.y_vel = ball.y_vel * 1.2
            debounce = true
        end
    else
        debounce = false
    end
    
    
    if love.keyboard.isDown("right") then
        if paddle.direction == "right" then
           paddle.speed = paddle.speed + 10 
        else
            paddle.speed = paddle.base_speed
        end
        -- think about where the 0 actually is.
        -- yep, 0 is the left corner. 
        -- the upper left corner.  
        if paddle.x > 0 then
            paddle.x = paddle.x - (paddle.speed * dt )
        else
            paddle.x = 0
        end
        paddle.direction = "right"
        
    elseif love.keyboard.isDown("left") then
        if paddle.direction == "left" then
            paddle.speed = paddle.speed + 10
        else
            paddle.speed = paddle.base_speed
        end
        -- this is dirty, since the window resolution is implicit. Fixme! 
        -- detect if paddle is at the end of the screen and if so, stop. 
        if paddle.x < (800 - 100) then 
            paddle.x = paddle.x + (paddle.speed * dt )
        else
            paddle.x = (800 - 100) 
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
        if ball.x > (800-15) then
            if ball.x_vel > 0 then
                ball.x_vel = -1 * ball.x_vel
            end
        end
        if ball.x < 0 then
            if ball.x_vel < 0 then
                ball.x_vel = -1 * ball.x_vel
            end
        end
        if ball.y < 0 then
            if ball.y_vel < 0 then
                ball.y_vel = -1 * ball.y_vel
            end
        end
        if ball.y > 600 then
            ball.exists = false
        end
        
        -- detect collision. probably shouldn't be here. 
        -- collision doesn't work when speed crosses the limit. This is because the 
        -- speed is so great it quantum tunnels through the paddle. 
        -- bounce is a little 'edgy' - a square bounce on a trivial corner overlap
        
        if ball.y > (paddle.y - 10) then
            if ball.y < paddle.y then
                if paddle.x < (ball.x + 10) then
                    if ball.x < (paddle.x + 100) then
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
    love.graphics.rectangle("fill", paddle.x, paddle.y, 100, 20)
    if ball.exists == true then
        love.graphics.rectangle("fill", ball.x, ball.y, 15, 15)
    end
    
    vel_str = ball.y_vel
    love.graphics.print(vel_str, 10, 200)

end