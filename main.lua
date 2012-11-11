-- Ping (Table Tennis Trainer)

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
    menu_position = 0
    -- fixme: the below is just set to NOT match with above.
    loaded_menu = 2
    winner = false
    debug = false
    
    drag = 1000
    max_ball_y = 600
    max_ball_x = 400
    min_ball_y = 100
    min_ball_x = 30
    
    
    paddle = { x = 50,
               y = 500,
               width = 100,
               height = 20,
               speed = 0,
               base_speed = 200,
               delta_speed = 40,
               direction = "Stopped" }
    
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
			
	bricks = {}
	state = {}
	background_snd = {}			

    -- I don't like having this here, but haven't bothered 
    -- to put in something sexier. 
    debounce = false

	-- Using PressStart2P font from http://openfontlibrary.org/en/font/press-start-2p
	awesome_font = love.graphics.newFont("PressStart2P.ttf", 30)
	menu_font = love.graphics.newFont("PressStart2P.ttf", 18)
	small_menu_font = love.graphics.newFont("PressStart2P.ttf", 14)
	
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