function menu_update(dt)
    if love.keyboard.isDown(" ") then
       menu = false 
    end
    if love.keyboard.isDown("up") then
    	if debounce == false then
    		debounce = true
    		if menu_position > 0 then
    			menu_position = menu_position - 1
    		end
    	end
    elseif love.keyboard.isDown("down") then
    	if debounce == false then
    		debounce = true
    		if menu_position  < 2 then 
    			menu_position = menu_position + 1
    		end
    	end
    else
    	debounce = false
    end
    	
end

function menu_draw()
	love.graphics.setColorMode("replace")
	love.graphics.setFont(menu_font)
    menu_str = "This is the menu. Hit spacebar, dummy!"
    love.graphics.print(menu_str, 60, 100)
	menu_str = "Here's another line"
	love.graphics.print(menu_str, 200, 250)
	menu_str = "Another option" 
	love.graphics.print(menu_str, 200, 300)
	menu_str = "Last option"
	love.graphics.print(menu_str, 200, 350)
	love.graphics.setFont(small_menu_font)
	menu_str = "Designed for Music Hack Day 2012 at MIT"
	love.graphics.print(menu_str, 60, 500)
	menu_str = "by @BDFife and @JimFingal"
	love.graphics.print(menu_str, 60, 530)
	love.graphics.setColor(255,255,255,100)
	love.graphics.rectangle("fill", 180, 240 + (50 * menu_position), 400, 30)
end




