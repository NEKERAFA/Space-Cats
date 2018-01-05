--- Initial Löve script
--
-- @author	Rafael Alcalde Azpiazu (NEKERAFA)
-- @license GNU General Public License v3
-- @release 0.2-beta (1.1-demo)

local gamestate  = require "lib.vrld.hump.gamestate"
local timer      = require "lib.vrld.hump.timer"

-- Load a lua chunck and execute it
function do_file(path)
	f, err = love.filesystem.load(path)
	if err then
		error(err, 2)
	else
		ok, err = pcall(f)
		if not ok then error(err, 2) end
	end
end

-- Save total update time
local total_title_time = 0
local trigger_title_time = 0.1

--- Table of save textures
img = {}
--- Table of save sound
snd = {}
--- Table of printable text
txt = {}
--- Table of shaders
shaders = {}

local function error_printer(msg, layer)
	print((debug.traceback("Error: " .. tostring(msg), 1+(layer or 1)):gsub("\n[^\n]+$", "")))
end

--- [LÖVE] This function is called exactly once at the beginning of the game
-- @tparam table args Command line arguments given to the game
function love.load(args)
	-- Set random seed
	math.randomseed(os.time())
	
	-- Load application settings
	do_file("src/main/states/app.lua")
	app:load_settings()
	
	-- Load utils
	do_file("src/main/utils.lua")
	
	-- Load splash
	do_file("src/main/states/splash.lua")
	-- Load credits
	do_file("src/main/states/credits.lua")
	-- Load start menu
	do_file("src/main/states/menu.lua")
	-- Load general game functions
	do_file("src/main/states/game.lua")
	-- Load level creator
	do_file("src/main/states/editor.lua")
	
	-- Change state to splash
	gamestate.switch(app)
end

--- [LÖVE] Callback function used to update the state of the game every frame
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
	
	-- Update timers
	timer.update(dt)
	
	-- Update current state
	gamestate.update(dt)
end

--- [LÖVE] Callback function triggered when a key is pressed
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

--- [LÖVE] Callback function triggered when a key is pressed
function love.keyreleased(key, scancode, isrepeat)
	gamestate.keyreleased(key, scancode, isrepeat)
end


--- [LÖVE] Callback function
function love.textinput(text)
    gamestate.textinput(text)
end

--- [LÖVE] Callback function triggered when a mouse button is pressed.
-- @tparam number x Mouse x position, in pixels
-- @tparam number y Mouse y position, in pixels
-- @tparam number button The button index that was pressed. 1 is the primary mouse button, 2 is the secondary mouse button and 3 is the middle button. Further buttons are mouse dependent
-- @tparam boolean True if the mouse button press originated from a touchscreen touch-press.
function love.mousepressed(x, y, button, istouch)
	-- Clip for screen render
	if x > app.dx and x < app.dx + app.width*app.scalefactor and
	   y > app.dy and y < app.dy + app.height*app.scalefactor then
			gamestate.mousepressed(x/app.scalefactor, y/app.scalefactor, button, istouch)
	end
end

-- Edit
--- [LÖVE] Callback function triggered when a mouse button is pressed.
function love.mousereleased(x, y, button, istouch)
	-- Clip for screen render
	if x > app.dx and x < app.dx + app.width*app.scalefactor and
	   y > app.dy and y < app.dy + app.height*app.scalefactor then
			gamestate.mousereleased(x/app.scalefactor, y/app.scalefactor, button, istouch)
	end
end

--- [LÖVE] Callback function triggered when the mouse is moved.
-- @tparam number x Mouse x position, in pixels
-- @tparam number y Mouse y position, in pixels
-- @tparam number dx The amount moved along the x-axis since the last time love.mousemoved was called
-- @tparam number dy The amount moved along the y-axis since the last time love.mousemoved was called.
-- @tparam boolean True if the mouse button press originated from a touchscreen touch-press.
function love.mousemoved(x, y, dx, dy, istouch)
	-- Clip for screen render
	if x > app.dx and x < app.dx + app.width*app.scalefactor and
	   y > app.dy and y < app.dy + app.height*app.scalefactor then  
			gamestate.mousemoved(x/app.scalefactor, y/app.scalefactor, dx/app.scalefactor, dy/app.scalefactor, istouch)
	end
end

--- [LÖVE] Callback function used to draw on the screen every frame
function love.draw()
	-- When isn't in game mode
	if gamestate.current() ~= splash then
		-- Prepare to change scale
		love.graphics.push("all")
		-- Center screen drawing in window
		love.graphics.translate(app.dx, app.dy)
		-- Cut outline screen
		love.graphics.setScissor(app.dx, app.dy, app.width * app.scalefactor, app.height * app.scalefactor)
		-- Rescale screen
		love.graphics.scale(app.scalefactor, app.scalefactor)		
	end

	-- Set white current color
	love.graphics.setColor(255, 255, 255, 255)
	-- Show current state
	gamestate.draw()
	
	if gamestate.current() ~= splash then
		if app.debug then
			-- Print current version
			love.graphics.setColor(255, 210, 0, 255)
			love.graphics.draw(txt.version, 10, app.height - txt.version:getHeight() - 5)
		end
		-- Remove rescale screen
		love.graphics.pop()
	end
end

--- [LÖVE] The error handler, used to display error messages.
-- @tparam string msg The error message
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
