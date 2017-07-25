--- Löve configuration script
--
-- @author	Rafael Alcalde Azpiazu (NEKERAFA)
-- @license GNU General Public License v3
-- @release 0.2

-- A new global table
app = {
	width = 320,
	height = 180,
	scalefactor = 4,
	debug = true,
	fullscreen = false,
	max_stars = 16
}

-- Configure
function love.conf(t)
    t.version = "0.10.2"
    t.console = false

    t.window.title = "Space cats!"
    t.window.width = app.width*app.scalefactor
    t.window.height = app.height*app.scalefactor
	t.window.fullscreen = app.fullscreen
	t.window.fullscreentype = "desktop"
    t.window.vsync = true
    t.window.highdpi = true
end
