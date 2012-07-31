
function love.conf(t)
    t.title = "Lua Test Game"
    t.author = "Brian Fife"
    t.identity = nil
    t.version = "0.7.2"
    t.console = false
    t.release = false
    t.screen.width = 800
    t.screen.height = 600
    t.sync.fullscreen = false
    t.screen.vsync = true
    t.screen.fsaa = 0
    t.modules.joystick = false
    t.modules.audio = false
    t.modules.keyboard = true
    t.modules.event = true
    t.modules.image = true
    t.modules.graphics = true
    t.modules.timer = true
    t.modules.mouse = false
    t.modules.sound = false
    t.modules.physics = false
end
