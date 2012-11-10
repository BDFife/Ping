
function collider(object, box, internal)
	-- This is the case of a ball inside a box.
	if internal == true then
		-- remember, velocity must be checked so you don't 
		-- flip twice in succession.
		
		bounced = false
		
		if object.x < box.x and object.x_vel < 0 then
			object.x_vel = object.x_vel * -1
			bounced = true
		elseif (object.x + object.width) > (box.x + box.width) and
			   object.x_vel > 0 then
			object.x_vel = object.x_vel * -1
			bounced = true
		end
		if object.y < box.y and object.y_vel < 0 then
			object.y_vel = object.y_vel * -1
			bounced = true
		elseif (object.y + object.height) > (box.y + box.height) and	
			   object.y_vel > 0 then
			object.y_vel = object.y_vel * -1
			bounced = true
		end
		
		return bounced

	-- This is the case of a ball hitting a brick or paddle. 
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
						-- first, assume if the ball-center is below the topline,
						-- is is a sidebounce. 
						if (object.y + (object.height / 2)) > box.y then
							object.x_vel = object.x_vel * -1
							return true	
						else
							object.y_vel = object.y_vel * -1
						end
						if (left == true and right == false) then
							if object.x_vel > 0 then 
								object.x_vel = (1 + paddle_english.x) * object.x_vel
								object.y_vel = (1 + paddle_english.y) * object.y_vel
							else
								object.x_vel = (1 - paddle_english.x) * object.x_vel
								object.y_vel = (1 - paddle_english.y) * object.y_vel
							end
						elseif (left == false and right == true) then
							if object.x_vel > 0 then
								object.x_vel = (1 - paddle_english.x) * object.x_vel
								object.y_vel = (1 - paddle_english.y) * object.y_vel
							else
								object.x_vel = (1 + paddle_english.x) * object.x_vel
								object.y_vel = (1 + paddle_english.y) * object.y_vel
							end
						end
						return true
					end
				end
			-- if ball moving up, check the bottom
			elseif object.y_vel < 0 then
				if object.y < (box.y + box.height) then
					if object.y > box.y then
						-- first, assume if the ball-center is above the bottomline,
						-- this is a sidebounce.
						if (object.y + (object.height / 2)) < (box.y + box.height) then
							object.x_vel = object.x_vel * -1
							return true
						else
							object.y_vel = object.y_vel * -1
						end
						if (left == true and right == false) then
							if object.x_vel > 0 then 
								object.x_vel = (1 + paddle_english.x) * object.x_vel
								object.y_vel = (1 + paddle_english.y) * object.y_vel
							else
								object.x_vel = (1 - paddle_english.x) * object.x_vel
								object.y_vel = (1 - paddle_english.y) * object.y_vel
							end
						elseif (left == false and right == true) then
							if object.x_vel > 0 then
								object.x_vel = (1 - paddle_english.x) * object.x_vel
								object.y_vel = (1 - paddle_english.y) * object.y_vel
							else
								object.x_vel = (1 + paddle_english.x) * object.x_vel
								object.y_vel = (1 + paddle_english.y) * object.y_vel
							end
						end

						return true
					end
				end
			else
				return false
			end
		else
			return false
		end
	end
end	