 function menu_update(dt)
	-- Keyboard

    if love.keyboard.isDown(" ") then
       bricks = load_bricks()
       state = load_state()
       menu = false 
    end
    
    if love.keyboard.isDown("q") then
    	love.event.push("quit")
    end
	
    if love.keyboard.isDown("up") then
    	if debounce == false then
    		debounce = true
    		if menu_position > 1 then
    			menu_position = menu_position - 1
    		end
    	end
    elseif love.keyboard.isDown("down") then
    	if debounce == false then
    		debounce = true
    		if menu_position  < 3 then 
    			menu_position = menu_position + 1
    		end
    	end
    else
    	debounce = false
	end
    

	-- Now load the data
	if not (loaded_menu == menu_position) then
		if menu_position == 1 then
			love.audio.stop()
			love.filesystem.load(manifest[1][2])()
			load_loop()
		elseif menu_position == 2 then
			love.audio.stop()
			love.filesystem.load(manifest[2][2])()
			load_loop()
		elseif menu_position == 3 then
			love.audio.stop()
			love.filesystem.load(manifest[3][2])()
			load_loop()
		end
		loaded_menu = menu_position
	end   	
end

function menu_draw()

    love.graphics.setBackgroundColor(63, 63, 63, 255)

	-- love.graphics.setColorMode("replace")
	
	love.graphics.setColor(204,147,147)
	
	love.graphics.setFont(menu_font)
    menu_str = "E C H O B R E A K O U T"
    love.graphics.print(menu_str, 175, 100)
    
    love.graphics.setColor(220,220,204)
    
    
	-- menu_str = "Press Space to Play"
	-- love.graphics.setFont(small_menu_font)
	-- menu_str = love.filesystem.getWorkingDirectory()
	menu_str = manifest[1][1]
	love.graphics.print(menu_str, 200, 250)
    menu_str = manifest[2][1]
    love.graphics.print(menu_str, 200, 300)
	menu_str = manifest[3][1]
	love.graphics.print(menu_str, 200, 350)
	love.graphics.setFont(small_menu_font)
	
	love.graphics.setColor(147,176,204)
	menu_str = "Designed for Music Hack Day 2012 at MIT"
	love.graphics.print(menu_str, 60, 500)
	menu_str = "by @BDFife and @JimFingal"
	love.graphics.print(menu_str, 60, 530)
	love.graphics.setColor(255,255,255,100)
	love.graphics.rectangle("fill", 180, 190 + (50 * menu_position), 400, 30)
end