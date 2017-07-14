--- Initial Löve script
--
-- @author	Rafael Alcalde Azpiazu (NEKERAFA)
-- @license GNU General Public License v3
-- @release 0.6

-- Save total update time
local total_update_time = 0
local trigger_update_time = 0.1

-- Save total time to call garbage collector
local total_gb_time = 0
local trigger_gb_time = 5
local fullscreen = false

local lg = love.graphics

--- Callback to load resources
function love.load(arg)
	-- Load splash file
	dofile(love.game.path .. "src/main/splash.lua")
	-- Load game file
    dofile(love.game.path .. "src/main/game.lua")
	
    print "Loaded!"
end

--- Update variables
function love.update(dt)
    -- Update game variables
	if splash.done then
		game.update(dt)
	-- Update splash
	else
		splash.anim:update(dt)
	end

	total_update_time = total_update_time + dt
    -- Update window title
	if total_update_time >= trigger_update_time then
		title = string.format("%i FPS, %.2f KB", love.timer.getFPS(), collectgarbage("count"))
		love.window.setTitle(title)
        -- Restart update time
		total_update_time = total_update_time - trigger_update_time
	end
	
	total_gb_time = total_gb_time + dt
    -- Launch garbage collector
	if total_gb_time >= trigger_gb_time then
		collectgarbage("collect")
        -- Restart collector time
		total_gb_time = total_gb_time - trigger_gb_time
	end
end

--- Callback when a key is pressed
function love.keypressed(key, scancode, isrepeat)
    -- ESQ key kill game
	if scancode == "escape" then
		love.event.quit(0)
	end
	
	-- Fullscreen
	if scancode == "f" then
		fullscreen = not fullscreen
		
		-- Change settings to
		if fullscreen then
			love.window.setFullscreen(true, "desktop")
			width = love.graphics.getDimensions()
			love.game.scalefactor = width/love.game.width
		-- Return to windowed settings
		else
			love.game.scalefactor = 3
			love.window.setFullscreen(false)
			love.window.setMode(
				love.game.scalefactor * love.game.width,
				love.game.scalefactor * love.game.height,
				{
					vsync = true,
					highdpi = true,
				}
			)
		end
	end
end

--- Callback to print game
function love.draw()
	-- Show game
	if splash.done then
		-- Rescale screen
		lg.push()
		lg.scale(love.game.scalefactor, love.game.scalefactor)
		love.graphics.setColor(255, 255, 255, 255)
		-- Draw game
		game.draw()
		-- Print current version
		lg.printf({{255, 210, 0}, love.game.version}, 10, love.game.height-20, love.game.width, "left")
		lg.pop()
	-- Show splash
	else
		splash.anim:draw()
	end
end
