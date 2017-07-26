-- A new global table
app = {
	width = 320,
	height = 180,
	scalefactor = 4,
	debug = true,
	max_stars = 32,
	language = "english",
	music_value = 50,
	sfx_value = 50
}

-- Configure
function love.conf(t)
    t.version = "0.10.2"
    t.console = false

    t.window.title = "Space cats!"
    t.window.width = 1280
    t.window.height = 720
	t.window.fullscreen = false
	t.window.fullscreentype = "desktop"
    t.window.vsync = true
    t.window.highdpi = true
end
