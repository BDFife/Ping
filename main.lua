-- Löve Lua Tutorial

function speedup()
-- this is for debug only 
    ball.x_vel = ball.x_vel * 1.2
    ball.y_vel = ball.y_vel * 1.2
end

function checkBoundaries()
-- this should be built generically 
-- but building specifically for now


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
        if ball.x > (screen.width-ball.width) then
            if ball.x_vel > 0 then
                ball.x_vel = -1 * ball.x_vel
            end
        end
        if ball.x < screen.origin then
            if ball.x_vel < 0 then
                ball.x_vel = -1 * ball.x_vel
            end
        end
        if ball.y < screen.origin then
            if ball.y_vel < 0 then
                ball.y_vel = -1 * ball.y_vel
            end
        end
        if ball.y > screen.height then
            ball.exists = false
        end
        
        -- detect collision. probably shouldn't be here. 
        -- collision doesn't work when speed crosses the limit. This is because the 
        -- speed is so great it quantum tunnels through the paddle. 
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
    
    --vel_str = screen.width
    --love.graphics.print(vel_str, 10, 200)

end