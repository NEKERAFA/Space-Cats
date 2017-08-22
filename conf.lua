-- Configure love variables
function love.conf(t)
	t.version = "0.10.2"
	t.console = false
	
	t.window.title = "Space cats"
	t.window.icon = "src/assets/images/icon.png"
    t.window.width = 320
    t.window.height = 180
	t.window.borderless = true
	t.window.vsync = true
	t.window.highdpi = true
	
	t.modules.audio = true
    t.modules.event = true
    t.modules.graphics = true 
    t.modules.image = true
    t.modules.joystick = false
    t.modules.keyboard = true
    t.modules.math = false
    t.modules.mouse = true
    t.modules.physics = false
    t.modules.sound = true
    t.modules.system = true
    t.modules.timer = true
    t.modules.touch = true
    t.modules.video = true 
    t.modules.window = true
    t.modules.thread = false 
end
