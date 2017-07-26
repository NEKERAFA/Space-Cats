--- Initial Löve script
--
-- @author	Rafael Alcalde Azpiazu (NEKERAFA)
-- @license GNU General Public License v3
-- @release 0.9

local gamestate = require "lib.vrld.hump.gamestate"

-- Frame rate of game
app.frameRate = 60
-- Current version
app.version = "0.9 (alphaka)"
-- Loaded variable
app.finish_loaded = false

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

-- Table of textures
img = {}
-- Table of effects
snd = {}
-- Table of printable text
txt = {}

function app:init()
    -- Fonts
    print "Loading fonts..."
    app.font = love.graphics.newFont("src/assets/fonts/pixel_operator/PixelOperator8.ttf", 8)
    app.font:setFilter("nearest")
	
	app.font_bold = love.graphics.newFont("src/assets/fonts/pixel_operator/PixelOperator8-Bold.ttf", 8)
	app.font_bold:setFilter("nearest")
	
	-- Loading language
	dofile("lang/" .. app.language .. ".lua")
	
	-- Load text textures
	app.load_text_textures()
	
	-- texture file tree
	print "Loading texture file tree..."
	img_tree = files.new_node('root', "src/assets/images", img, 'img')
	
	-- Sound file tree
	print "Loading sound file tree..."
	snd_tree = files.new_node('root', "src/assets/sounds", snd, 'snd')
end

--- Load all text strings like textures
function app.load_text_textures()
	txt.version = love.graphics.newText(app.font, app.version)
	txt.loading = love.graphics.newText(app.font, msg_string.loading .. "...")
	txt.story = love.graphics.newText(app.font_bold, msg_string.story)
	txt.settings = love.graphics.newText(app.font_bold, msg_string.settings)
	txt.exit = love.graphics.newText(app.font_bold, msg_string.exit)
	txt.mark = love.graphics.newText(app.font, ">")
	txt.music = love.graphics.newText(app.font_bold, msg_string.music .. ":")
	txt.sfx = love.graphics.newText(app.font_bold, msg_string.sfx .. ":")
	txt.resolution = love.graphics.newText(app.font_bold, msg_string.resolution .. ":")
	txt.language = love.graphics.newText(app.font_bold, msg_string.language .. ":")
end

--- Update app variables
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
	
	-- Update splash variable
	elseif total_loading_splash > 0 then
		total_loading_splash = total_loading_splash - dt
	
	-- Loaded
	else
		gamestate.switch(menu)
	end
end

function app:draw()
	local color = math.min(255, total_loading_splash/trigger_loading_splash*255)
	love.graphics.setColor(color, color, color, 255)
	local x  = math.round(app.width/2)
	local y  = math.round(app.height/2)
	local x0 = math.round(txt.loading:getWidth()/2)
	local y0 = math.round(txt.loading:getHeight()/2)
	
	love.graphics.draw(txt.loading, x, y, 0, 1, 1, x0, y0)
end

--- Callback to load resources
function love.load(arg)
	-- Load utils
	dofile("src/main/utils.lua")
	
	-- Load splash file
	dofile("src/main/splash.lua")
	-- Load menu file
	dofile("src/main/menu.lua")
	-- Load game file
    dofile("src/main/game.lua")
	
	gamestate.switch(splash)
	
    print "Loaded game!"
end

--- Update variables
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
	
	-- Update current state
	gamestate.update(dt)
end

--- Callback when a key is pressed
function love.keypressed(key, scancode, isrepeat)
    -- ESQ key kill game
	if scancode == "escape" then
		love.event.quit(0)
	end
	
	gamestate.keypressed(key, scancode, isrepeat)
end

--- Callback to print game
function love.draw()
	-- When isn't in game mode
	if gamestate.current() ~= splash then
		-- Rescale screen
		love.graphics.push()
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
