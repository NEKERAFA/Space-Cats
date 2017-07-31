--- Initial Löve script
--
-- @author	Rafael Alcalde Azpiazu (NEKERAFA)
-- @license GNU General Public License v3
-- @release 0.9

local gamestate = require "lib.vrld.hump.gamestate"
local timer     = require "lib.vrld.hump.timer"

--- Module app
app = {}

--- App width
app.width = 320
--- App height
app.height = 180
--- Frame rate of game
app.frameRate = 60
--- Current version
app.version = "0.9 (alphaka)"
--- Maximun of stars
app.max_stars = 32
--- Debugging information
app.debug = true
--- Save file
app.save_file = love.filesystem.getSaveDirectory() .. "/settings.lua"

-- Save total update time
local total_title_time = 0
local trigger_title_time = 0.1

-- Save total time to call garbage collector
local total_gb_time = 0
local trigger_gb_time = 5

-- Save total time to splash loading animation
local total_loading_splash = 0
local trigger_loading_splash = 1

-- Save if app is loaded
local loaded = false
local img_loaded = false
local snd_loaded = false

-- Save filesystem tree
local img_tree = nil
local snd_tree = nil

--- Table of save textures
img = {}
--- Table of save sound
snd = {}
--- Table of printable text
txt = {}

--- Load fonts
function app:load_fonts()
	-- Load normal font
	print "Loading normal font..."
	self.font = love.graphics.newFont("src/assets/fonts/pixel_operator/PixelOperator8.ttf", 8)
	self.font:setFilter("nearest")
	
	-- Load bold font
	print "Loading bold font..."
	self.font_bold = love.graphics.newFont("src/assets/fonts/pixel_operator/PixelOperator8-Bold.ttf", 8)
	self.font_bold:setFilter("nearest")
	
	-- Set normal font as default
	love.graphics.setFont(self.font)
end

--- Load all text strings like textures
function app:load_text_textures()
	txt.version    = love.graphics.newText(self.font, self.version)
	txt.loading    = love.graphics.newText(self.font, msg_string.loading .. "...")
	txt.story      = love.graphics.newText(self.font_bold, msg_string.story)
	txt.settings   = love.graphics.newText(self.font_bold, msg_string.settings)
	txt.exit       = love.graphics.newText(self.font_bold, msg_string.exit)
	txt.mark       = love.graphics.newText(self.font, ">")
	txt.mark_bold  = love.graphics.newText(self.font_bold, ">")
	txt.music      = love.graphics.newText(self.font_bold, msg_string.music .. ":")
	txt.sfx        = love.graphics.newText(self.font_bold, msg_string.sfx .. ":")
	txt.resolution = love.graphics.newText(self.font_bold, msg_string.resolution .. ":")
	txt.fullscreen = love.graphics.newText(self.font_bold, msg_string.fullscreen .. ":")
	txt.language   = love.graphics.newText(self.font_bold, msg_string.language .. ":")
	txt.credits    = love.graphics.newText(self.font_bold, msg_string.credits)
	txt.saved      = love.graphics.newText(self.font, msg_string.saved .. " " .. app.save_file)
end

--- Load tree nodes
function app:load_nodes()
	-- texture file tree
	print "Loading texture file tree..."
	img_tree = files.new_node('root', "src/assets/images", img, 'img')
	
	-- Sound file tree
	print "Loading sound file tree..."
	snd_tree = files.new_node('root', "src/assets/sounds", snd, 'snd')
end

--- Init all app variables
function app:init()
	-- Fonts
	print "Loading fonts..."
	app:load_fonts()
	
	-- Loading language
	print "Loading language file..."
	dofile("lang/" .. app.language .. ".lua")
	
	-- Load text textures
	print "Loading text textures..."
	app:load_text_textures()
	
	-- Load file nodes
	print "Loading nodes..."
	app:load_nodes()
end

--- Update app variables
-- @tparam number dt Time since the last update in seconds
function app:update(dt)
	-- Update splash variable
	if not loaded and total_loading_splash < trigger_loading_splash then
		total_loading_splash = total_loading_splash + dt
	
	-- If app not finished to load
	elseif not loaded then
		if not img_loaded then
			-- If we come back top node, we finish load elements
			if img_tree == nil then
				img_loaded = true
				return
			end
			
			img_tree = files.load_node(img_tree, "img")
		elseif not snd_loaded then
			-- If we come back top node, we finish load elements
			if snd_tree == nil then
				snd_loaded = true
				loaded = true
				return
			end
			
			snd_tree = files.load_node(snd_tree, "snd")
		end
	
	-- Loaded
	else
		gamestate.switch(menu)
	end
end

--- Draw loading screen
function app:draw()
	local color = math.min(255, total_loading_splash/trigger_loading_splash*255)
	love.graphics.setColor(color, color, color, 255)
	local x  = math.round(self.width/2)
	local y  = math.round(self.height/2)
	local x0 = math.round(txt.loading:getWidth()/2)
	local y0 = math.round(txt.loading:getHeight()/2)
	
	love.graphics.draw(txt.loading, x, y, 0, 1, 1, x0, y0)
end

--- Load saved settings
function app:load_settings()
	-- Loading save file
	pcall(dofile, self.save_file)
	
	-- Set variables
	self.music_volume = music_volume or 50
	self.sfx_volume   = sfx_value or 50
	self.scalefactor  = scalefactor or 3
	self.fullscreen   = fullscreen or false
	self.language	  = language or "english"
	
	-- Set scalefactor
	if app.fullscreen then
		width = love.window.getDesktopDimensions()
		app.scalefactor = width / app.width
	end
	
	width  = math.ceil(self.scalefactor*320)
	height = math.ceil(self.scalefactor*180)
	love.window.setMode(width, height, {fullscreen = self.fullscreen})
end

--- [Löve] This function is called exactly once at the beginning of the game
-- @tparam table args Command line arguments given to the game
function love.load(args)
	-- Load settings
	print "Loading settings..."
	app:load_settings()
	
	-- Load utils
	dofile("src/main/utils.lua")
	
	-- Load animations
	dofile("src/main/animations.lua")
	
	-- Load splash
	dofile("src/main/splash.lua")
	-- Load credits
	dofile("src/main/credits.lua")
	-- Load settings menu
	dofile("src/main/settings.lua")
	-- Load levels menu
	dofile("src/main/levels.lua")
	-- Load start menu
	dofile("src/main/menu.lua")
	-- Load general game functions
	dofile("src/main/game.lua")
	
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
		love.graphics.draw(txt.version, 10, app.height - txt.version:getHeight() - 5, 0, 1, 1, 0, 0)
	end
	
	if gamestate.current() ~= splash then
		-- Remove rescale screen
		love.graphics.pop()
	end
end
