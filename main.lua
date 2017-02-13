--- Initial Löve script
--
-- @author	Rafael Alcalde Azpiazu (NEKERAFA)
-- @license GNU General Public License v3
-- @version 0.6

-- Save current version
love.game.version = "0.6 (alphaka)"
-- Save total update time
local total_update_time = 0
local trigger_update_time = 1
-- Save total time to call garbage collector
local total_gb_time = 0
local trigger_gb_time = 5

local lg = love.graphics

-- Callback to load resources
function love.load(arg)
    dofile(love.game.path .. "game.lua")
    print "Loaded!"
end

-- Update variables
function love.update(dt)
    -- Update game variables
    game.update(dt)

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
end

-- Callback to print game
function love.draw()
    -- Rescale screen
    lg.push()
    lg.scale(love.scalefactor, love.scalefactor)
    -- Draw game
    game.draw()
    -- Print current version
	lg.printf({{255, 210, 0}, love.game.version}, 10, love.game.getHeight()-20, love.game.getWidth(), "left")
    lg.pop()
end