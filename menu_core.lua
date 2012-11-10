function menu_update(dt)
    if love.keyboard.isDown(" ") then
       menu = false 
    end
end

function menu_draw()
    menu_str = "This is the menu. Hit spacebar, dummy!"
    love.graphics.print(menu_str, 10, 200)
end

