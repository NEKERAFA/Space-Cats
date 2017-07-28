-- Load settings
dofile("settings.lua")

-- Configure
function love.conf(t)
    t.version = "0.10.2"
    t.console = false
    t.window.title = "Space cats!"
    t.window.width = 320*app.scalefactor
    t.window.height = 180*app.scalefactor
	t.window.fullscreen = app.fullscreen
	t.window.fullscreentype = "desktop"
    t.window.vsync = true
    t.window.highdpi = true
end
