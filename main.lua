-- Löve Lua Tutorial


-- I use this function to speed up the ball while testing. 
-- At the moment, triggered with the 'up' key.
function speedup()
    -- this is for debug only 
    ball.x_vel = ball.x_vel * 1.2
    ball.y_vel = ball.y_vel * 1.2
end

function collider(object, box, internal)
	if internal == true then
		-- remember, velocity must be checked so you don't 
		-- flip twice in succession.
		if object.x < box.x and object.x_vel < 0 then
			object.x_vel = object.x_vel * -1
		elseif (object.x + object.width) > (box.x + box.width) and
			   object.x_vel > 0 then
			object.x_vel = object.x_vel * -1
		end
		if object.y < box.y and object.y_vel < 0 then
			object.y_vel = object.y_vel * -1
		elseif (object.y + object.height) > (box.y + box.height) and	
			   object.y_vel > 0 then
			object.y_vel = object.y_vel * -1
		end
	else 
		-- the object is normally outside the box. 		
		-- this code assumes the object is never wholly contained within the box
		-- check for x overlap
		left = false
		right = false
		top = false
		bottom = false

		-- check left edge
		if object.x < (box.x + box.width) then
			if object.x > box.x then
				left = true
			end
		end
		-- check right edge		
		if (object.x + object.width) < (box.x + box.width) then
			if (object.x + object.width) > box.x then
				right = true
			end
		end 
		-- if right or left overlap, then check top/bottom
		if left == true or right == true then
			-- if ball moving down, check the top
			if object.y_vel > 0 then
				if (object.y + object.height) > box.y then
					if (object.y + object.height) < (box.y + box.height) then 
						object.y_vel = object.y_vel * -1
					end
				end
			-- if ball moving up, check the bottom
			elseif object.y_vel < 0 then
				if object.y < (box.y + box.height) then
					if object.y > box.y then
						object.y_vel = object.y_vel * -1
					end
				end
			end
		end
	end
end	
		
-- Function to check if the ball has left the screen.
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
               x = 0,
               y = 0,
               origin = 0 }

	bricks = { { exists = true,
				 x = 100, 
				 y = 20,
				 width = 30,
				 height = 20 },
			   { exists = true,
			   	 x = 300,
			   	 y = 20,
			   	 width = 30,
			   	 height = 20 },
			   { exists = true,
			   	 x = 500,
			   	 y = 50,
			   	 width = 30,
			   	 height = 20 } }

    -- I don't like having this here, but haven't bothered 
    -- to put in something sexier. 
    debounce = false

end

function love.update(dt)

	-- ---------------------
	-- Step 1: 
	-- Check for keypresses. 
	-- ---------------------
	
    -- " " is the spacebar. Use it to 'reset' the ball position.
    if love.keyboard.isDown(" ") then
        ball.exists = true
        ball.x = 100
        ball.y = 100
        ball.x_vel = 60
        ball.y_vel = 200
        
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
        -- 0 is the upper left corner of the paddle.  
        if paddle.x > screen.origin then
            paddle.x = paddle.x - (paddle.speed * dt )
        else
            paddle.x = screen.origin
        end
        paddle.direction = "right"
        
    -- Paddle left.    
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
		end

		-- see if the ball hits an edge (not the bottom)		
		if ball.exists == true then
			collider(ball, screen, true)
		end

        -- Check for collision with the paddle. 
        -- Collision doesn't work when speed crosses a certain limit. This is because the 
        -- speed is so great it "blinks" past the paddle between frames. 
        -- Bounce is very simplistic - a square bounce on a trivial corner overlap
        -- Other implementations have the edges of the paddle act as "slopes"
        if ball.exists == true then
        	collider(ball, paddle, false)
        end
        
        if ball.exists == true then
        	for i, brick in ipairs(bricks) do
        		if brick.exists == true then
        			-- collider(ball, brick, false)
        			brick.exists = true
        		end
        	end
        end
                            
    	-- Check for collision with the bricks.
    	for i,brick in ipairs(bricks) do
    		if brick.exists == true then
				collider(ball, brick, false)
			end
		end
    end
end

-- Update the screen.
function love.draw()
    love.graphics.setColor(255,255,255,255)
	-- draw rectangle    
    love.graphics.rectangle("fill", paddle.x, paddle.y, paddle.width, paddle.height)
	-- draw ball
    if ball.exists == true then
        love.graphics.rectangle("fill", ball.x, ball.y, ball.width, ball.height)
	end
	-- draw bricks
	for i, brick in ipairs(bricks) do
		if brick.exists == true then
			love.graphics.rectangle("fill", brick.x, brick.y, brick.width, brick.height)
		end
	end

    -- Optional code to show the ball velocity.
    --if checkBoundaries(0, screen.height, ball.y) then
    --    vel_str = "True"
    --else
    --    vel_str = "False"
    --end
    --love.graphics.print(vel_str, 10, 200)

end