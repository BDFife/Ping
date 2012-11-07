
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