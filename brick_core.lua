function game_update(dt)

	-- ---------------------
	-- Step 0: 
	-- Don't break the speed limit
	-- ---------------------
	if ball.y_vel > max_ball_y then
		ball.y_vel = max_ball_y
	elseif ball.y_vel < (max_ball_y * -1) then
		ball.y_vel = (max_ball_y * -1)
	elseif ball.y_vel > 0 and ball.y_vel < min_ball_y then
		ball.y_vel = min_ball_y
	elseif ball.y_vel < 0 and ball.y_vel > (min_ball_y * -1) then
		ball.y_vel = (min_ball_y * -1)
	end
	
	if ball.x_vel > max_ball_x then
		ball.x_vel = max_ball_x
	elseif ball.x_vel < (-1 * max_ball_x) then
		ball.x_vel = (-1 * max_ball_x)
	elseif ball.x_vel > 0 and ball.x_vel < (min_ball_x) then
		ball.x_vel = (min_ball_x * -1)
	elseif ball.x_vel < 0 and ball.x_vel > (min_ball_x * -1) then
		ball.x_vel = (min_ball_x * -1)
	end
	
	

	-- ---------------------
	-- Step 1: 
	-- Check for keypresses. 
	-- ---------------------
	
	-- Esc re-sets the board
	if love.keyboard.isDown("escape") then
		love.audio.stop()
		menu = true
		--winner = false
		--ball.exists = false
		--for i, brick in ipairs(bricks) do
        --		brick.exists = true
        --end
    end
    
    if love.keyboard.isDown("q") then
    	love.event.push("quit")
    end
    
	
    -- " " is the spacebar. Use it to 'reset' the ball position.
    if love.keyboard.isDown(" ") then
        ball.exists = true
        ball.x = paddle.x + (0.5 * paddle.width)
        ball.y = paddle.y
        ball.x_vel = state.ball_x
        ball.y_vel = state.ball_y * -1
        
    end
    
    if love.keyboard.isDown("d") then
        debug = true
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
           if paddle.speed > paddle_max_x then
           		paddle.speed = paddle_max_x
           end
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
            if paddle.speed > paddle_max_x then
           		paddle.speed = paddle_max_x
           	end
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
        
    -- If left or right isn't being pressed, slow the paddle down. 
    else
    
     	paddle.speed = paddle.speed - (drag * dt)

		if paddle.direction == "left" then
			if paddle.x > screen.origin then
	            paddle.x = paddle.x - (paddle.speed * dt )
	        else
	            paddle.x = screen.origin
	            paddle.direction = "right"
	        end
	    elseif paddle.direction == "right" then
		    if paddle.x < (screen.width - paddle.width) then 
	            paddle.x = paddle.x + (paddle.speed * dt )
	        else
	            paddle.x = (screen.width - paddle.width) 
	            paddle.direction = "left"
	        end
	    end
		
		if paddle.speed > paddle_max_x then
           	paddle.speed = paddle_max_x
        end

		if paddle.speed < 0 then
	       paddle.speed = 0
		   paddle.direction = "Stopped"
		end
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
			-- UNCOMMENT TO ADD ZOE SOUND BACK IN love.audio.play(fail_snd)
		end

		-- see if the ball hits an edge (not the bottom)		
		if ball.exists == true then
			bounce = collider(ball, screen, true)
			if bounce == true then
				-- UNCOMMENT TO ADD ZOE SOUND BACK IN love.audio.play(wall_snd)
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
        		-- UNCOMMENT TO ADD ZOE SOUND BACK IN love.audio.play(bounce_snd)
        	end
        end
        
        if ball.exists == true then
        	for i, brick in ipairs(bricks) do
        		if brick.exists == true then
        			bounce = collider(ball, brick, false)
        			if bounce == true then
        				brick.exists = false
						-- erase the brick, and play the brick's associated
						-- music clip, synchronized to the main loop, 
						-- if there aren't too many sources playing. 
        				if love.audio.getNumSources() < max_sources then
	        				love.audio.play(brick.snd)
	        			end
        			end
        		end
        	end
        end
        
        for i, brick in ipairs(bricks) do
        	if brick.exists == true then
        		return true
			else
				winner = true
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
	
	if winner == true then
		love.graphics.setFont(awesome_font)
		love.graphics.setColor(255,255,255,255)
		love.graphics.print("WINNER!", 300, 200)
	end
	
	if ball.exists == false then
		love.graphics.setFont(small_menu_font)
		love.graphics.setColor(255,255,255,255)
		love.graphics.print("Press Spacebar to Start", 250, 400)
	end

	if debug then
	    love.graphics.print("vX:" .. ball.x_vel, 10, 250)
	    love.graphics.print("vY:" .. ball.y_vel, 10, 275)
	    love.graphics.print("bgdSecs:" .. background_snd:tell("seconds"), 10, 300)
	    love.graphics.print("srcs:" .. love.audio.getNumSources(), 10, 325)
	    love.graphics.print("pS:" .. paddle.speed, 10, 350)
	    love.graphics.print("pD:" ..paddle.direction, 10, 375)
	    love.graphics.print("pX:" ..paddle.x, 10, 400)
	    love.graphics.print("bL:" .. background_length, 10, 425)
	    love.graphics.print("sL:" .. song_length, 10, 450)
	    
    end
    

end
