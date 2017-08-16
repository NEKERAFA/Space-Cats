--- Initial Löve script
--
-- @author	Rafael Alcalde Azpiazu (NEKERAFA)
-- @license GNU General Public License v3
-- @release 1.0 - Demo

local gamestate  = require "lib.vrld.hump.gamestate"
local timer      = require "lib.vrld.hump.timer"

-- Save total update time
local total_title_time = 0
local trigger_title_time = 0.1

-- Save total time to call garbage collector
local total_gb_time = 0
local trigger_gb_time = 5

--- Table of save textures
img = {}
--- Table of save sound
snd = {}
--- Table of printable text
txt = {}
--- Table of shaders
shaders = {}

print(love.filesystem.getSource())

local function error_printer(msg, layer)
	print((debug.traceback("Error: " .. tostring(msg), 1+(layer or 1)):gsub("\n[^\n]+$", "")))
end

--- [Löve] This function is called exactly once at the beginning of the game
-- @tparam table args Command line arguments given to the game
function love.load(args)
	-- Set random seed
	math.randomseed(os.time())
	
	-- Load application settings
	dofile(love.filesystem.getSource() .. "/src/main/states/app.lua")
	app:load_settings()
	
	-- Load utils
	dofile(love.filesystem.getSource() .. "/src/main/utils.lua")
	
	-- Load splash
	dofile(love.filesystem.getSource() .. "/src/main/states/splash.lua")
	-- Load credits
	dofile(love.filesystem.getSource() .. "/src/main/states/credits.lua")
	-- Load start menu
	dofile(love.filesystem.getSource() .. "/src/main/states/menu.lua")
	-- Load general game functions
	dofile(love.filesystem.getSource() .. "/src/main/states/game.lua")
	
	-- Change state to splash
	gamestate.switch(splash)
end

--- [Löve] Callback function used to update the state of the game every frame
-- @tparam number dt Time since the last update in seconds
function love.update(dt)
	-- Debug information
	if app.debug then
		total_title_time = total_title_time + dt
		-- Update window title
		if total_title_time >= trigger_title_time then
			title = string.format("%i FPS, %.2f KB", love.timer.getFPS(), collectgarbage("count"))
			love.window.setTitle(title)
			-- Restart update time
			total_title_time = total_title_time - trigger_title_time
		end
	end
	
	total_gb_time = total_gb_time + dt
	-- Launch garbage collector
	if total_gb_time >= trigger_gb_time then
		collectgarbage("collect")
		-- Restart collector time
		total_gb_time = total_gb_time - trigger_gb_time
	end
	
	-- Update timers
	timer.update(dt)
	
	-- Update current state
	gamestate.update(dt)
end

--- [Löve] Callback function triggered when a key is pressed
-- @tparam KeyConstant key Character of the pressed key
-- @tparam Scancode scancode The scancode representing the pressed key
-- @tparam boolean isrepeat Whether this key press event is a repeat. The delay between key depends on the user's system settings
function love.keypressed(key, scancode, isrepeat)
	-- ESQ key kill game
	if scancode == "escape" then
		love.event.quit(0)
	end
	
	gamestate.keypressed(key, scancode, isrepeat)
end

--- [Löve] Callback function used to draw on the screen every frame
function love.draw()
	-- When isn't in game mode
	if gamestate.current() ~= splash then
		-- Prepare to change scale
		love.graphics.push("all")
		
		local window_width = app.width * app.scalefactor
		local window_height = app.height * app.scalefactor
		local dx = 0; local dy = 0
		
		-- If is in fullscreen, center window
		if app.fullscreen then
			screen_width, screen_height = love.window.getDesktopDimensions()
			dx = math.round((screen_width-window_width)/2)
			dy = math.round((screen_height-window_height)/2)
			love.graphics.translate(dx, dy)
		end
		
		-- Cut outline screen
		love.graphics.setScissor(dx, dy, window_width, window_height)
		-- Rescale screen
		love.graphics.scale(app.scalefactor, app.scalefactor)		
	end

	-- Set white current color
	love.graphics.setColor(255, 255, 255, 255)
	-- Show current state
	gamestate.draw()
	
	if app.debug and (gamestate.current() ~= splash) then
		-- Print current version
		love.graphics.setColor(255, 210, 0, 255)
		love.graphics.draw(txt.version, 10, app.height - txt.version:getHeight() - 5)
	end
	
	if gamestate.current() ~= splash then
		-- Remove rescale screen
		love.graphics.pop()
	end
end

function love.errhand(msg)
	msg = tostring(msg)
	
	error_printer(msg, 2)

	if not love.window or not love.graphics or not love.event then
		return
	end
 
	-- Reset state.
	if love.mouse then
		love.mouse.setVisible(true)
		love.mouse.setGrabbed(false)
		love.mouse.setRelativeMode(false)
	end
	if love.joystick then
		-- Stop all joystick vibrations.
		for i,v in ipairs(love.joystick.getJoysticks()) do
			v:setVibration()
		end
	end
	if love.audio then love.audio.stop() end

	local trace = debug.traceback()
 
	local err = {}
 
	table.insert(err, msg.."\n")
 
	for l in string.gmatch(trace, "(.-)\n") do
		if not string.match(l, "boot.lua") then
			l = string.gsub(l, "stack traceback:", "Traceback:")
			table.insert(err, l)
		end
	end
 
	local p = table.concat(err, "\n")
 
	p = string.gsub(p, "\t", "    ")
	p = string.gsub(p, "%[string \"(.-)\"%]", "%1")
	
	err_log = io.open("errlog", "w+")
	err_log:write(p)
	err_log:close()
	
	love.window.showMessageBox("Error", p, "error")
	
	return
end
