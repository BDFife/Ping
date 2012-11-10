-- Ping (Table Tennis Trainer)

require "brick"
require "collider"
require "brick_core"
require "menu_core"

-- I use this function to speed up the ball while testing. 
-- At the moment, triggered with the 'up' key.
function speedup()
    -- this is for debug only 
    ball.x_vel = ball.x_vel * 1.2
    ball.y_vel = ball.y_vel * 1.2
end

function love.load()
    menu = true
    
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

	paddle_english = { x = .5,
					   y = .2 } 
						

	bricks = load_bricks()

    -- I don't like having this here, but haven't bothered 
    -- to put in something sexier. 
    debounce = false

	-- These are the core game sounds. The brick breaking sound is managed
	-- via the brick object.
	bounce_snd = love.audio.newSource("Boing.mp3", "static")
	wall_snd = love.audio.newSource("Bing.mp3", "static")
	fail_snd = love.audio.newSource("GameOver.mp3", "static")

end

-- Perform computations, etc. between screen refreshes.
function love.update(dt)
	if menu then
		menu_update(dt)
	-- assume in game
	else 
		game_update(dt)
	end
end

-- Update the screen.
function love.draw()
	if menu then
		menu_draw()
	else
		game_draw()
	end
end