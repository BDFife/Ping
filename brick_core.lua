function game_update(dt)

	-- ---------------------
	-- Step 0: 
	-- Don't break the speed limit
	-- ---------------------
	if ball.y_vel > 600 then
		ball.y_vel = 600
	elseif ball.y_vel < -600 then
		ball.y_vel = -600
	elseif ball.y_vel > 0 and ball.y_vel < 100 then
		ball.y_vel = 100
	elseif ball.y_vel < 0 and ball.y_vel > -100 then
		ball.y_vel = -100
	end
	
	if ball.x_vel > 400 then
		ball.x_vel = 400
	elseif ball.x_vel < -400 then
		ball.x_vel = -400
	elseif ball.x_vel > 0 and ball.x_vel < 30 then
		ball.x_vel = 30
	elseif ball.x_vel < 0 and ball.x_vel > -30 then
		ball.x_vel = -30
	end
	

	-- ---------------------
	-- Step 1: 
	-- Check for keypresses. 
	-- ---------------------
	
    -- " " is the spacebar. Use it to 'reset' the ball position.
    if love.keyboard.isDown(" ") then
        ball.exists = true
        ball.x = 200
        ball.y = 200
        ball.x_vel = 100
        ball.y_vel = 400
        
    end
    
    -- I don't remember what this does anymore! 
    if love.keyboard.isDown("down") then
        debug.debug()
    end
    
    
    -- Speed up the ball. Need to debounce to keep from running out of
    -- control. 
    if love.keyboard.isDown("up") then
        if debounce == false then
            speedup()
            debounce = true
        end
    else
        debounce = false
    end
    
    -- Paddle right.
    if love.keyboard.isDown("right") then
        if paddle.direction == "right" then
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
        paddle.direction = "right"
        
    -- Paddle left.    
    elseif love.keyboard.isDown("left") then
        if paddle.direction == "left" then
            paddle.speed = paddle.speed + paddle.delta_speed
        else
            paddle.speed = paddle.base_speed
        end
        -- 0 is the upper left corner of the paddle.  
        if paddle.x > screen.origin then
            paddle.x = paddle.x - (paddle.speed * dt )
        else
            paddle.x = screen.origin
        end
        paddle.direction = "left"
        
    -- If left or right isn't being pressed, stop the paddle. 
    else
        paddle.speed = paddle.base_speed
        paddle.direction = nil
    end
    
    -- ---------------
    -- Step 2: 
    -- Move the ball
    -- ---------------
    if ball.exists == true then

		-- Move the ball
        ball.x = ball.x + ball.x_vel * dt
        ball.y = ball.y + ball.y_vel * dt

		
		-- If the ball is leaving the bottom of the screen, disable it: 
		if ball.y > (paddle.y + paddle.height + ball.height*2) then
			ball.exists = false
			love.audio.play(fail_snd)
		end

		-- see if the ball hits an edge (not the bottom)		
		if ball.exists == true then
			bounce = collider(ball, screen, true)
			if bounce == true then
				love.audio.play(wall_snd)
			end
		end

        -- Check for collision with the paddle. 
        -- Collision doesn't work when speed crosses a certain limit. This is because the 
        -- speed is so great it "blinks" past the paddle between frames. 
        -- Bounce is very simplistic - a square bounce on a trivial corner overlap
        -- Other implementations have the edges of the paddle act as "slopes"
        if ball.exists == true then
        	bounce = collider(ball, paddle, false)
        	if bounce == true then
        		love.audio.play(bounce_snd)
        	end
        end
        
        if ball.exists == true then
        	for i, brick in ipairs(bricks) do
        		if brick.exists == true then
        			bounce = collider(ball, brick, false)
        			if bounce == true then
        				brick.exists = false
        				love.audio.play(brick.snd)
        			end
        		end
        	end
        end
    end
end

function game_draw()
    love.graphics.setBackgroundColor(63, 63, 63, 255)

    love.graphics.setColor(220,220,204)
	-- draw rectangle    
    love.graphics.rectangle("fill", paddle.x, paddle.y, paddle.width, paddle.height)
	-- draw ball
    if ball.exists == true then
        love.graphics.rectangle("fill", ball.x, ball.y, ball.width, ball.height)
	end
	-- draw bricks
	for i, brick in ipairs(bricks) do
		if brick.exists == true then
		    love.graphics.setColor(brick.r, brick.g, brick.b)
			love.graphics.rectangle("fill", brick.x, brick.y, brick.width, brick.height)
		end
	end

    -- love.graphics.print(ball.x_vel, 10, 200)
end
