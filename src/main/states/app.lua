--- Definition of application functions
--
-- @author	Rafael Alcalde Azpiazu (NEKERAFA)
-- @license GNU General Public License v3

local gamestate = require "lib.vrld.hump.gamestate"

-- Save filesystem tree
local img_tree = nil
local snd_tree = nil

--- Module app
app = {}

-- Save total time to splash loading animation
app.total_loading_splash = 0

-- Save if app load image and sound sources
app.img_loaded = false
app.snd_loaded = false

--- Top delta x
app.dx = 0
--- Top delta y
app.dy = 0
--- App width
app.width = 320
--- App height
app.height = 180
--- Frame rate of game
app.frameRate = 60
--- Current version
app.version = "0.2-beta"
--- Debugging information
app.debug = true
--- Save file
app.save_file = love.filesystem.getSaveDirectory() .. "/settings.lua"

--- Up key
app.up = "w"
--- Down key
app.down = "s"
--- Left key
app.left = "a"
--- Right key
app.right = "d"
--- Fire key
app.fire = "k"
--- Accept key
app.accept = "return"
--- Cancel key
app.cancel = "backspace"

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
	
	-- Load points font
	print "Loading points font..."
	self.font_points = love.graphics.newFont("src/assets/fonts/pixel_operator/PixelOperator.ttf", 16)
	self.font_points:setFilter("nearest")
	
	-- Set normal font as default
	love.graphics.setFont(self.font)
end

--- Load all text strings like textures
function app:load_text_textures()
	txt.version    = love.graphics.newText(self.font, self.version)
	txt.copyright  = love.graphics.newText(self.font, "(c)  2017 NEKERAFA")
	txt.loading    = love.graphics.newText(self.font, msg_string.loading .. "...")
	--
	txt.story      = love.graphics.newText(self.font_bold, msg_string.story)
	txt.community  = love.graphics.newText(self.font_bold, msg_string.community)
	txt.settings   = love.graphics.newText(self.font_bold, msg_string.settings)
	txt.exit       = love.graphics.newText(self.font_bold, msg_string.exit)
	txt.mark       = love.graphics.newText(self.font, ">")
	txt.mark_bold  = love.graphics.newText(self.font_bold, ">")
	--
	txt.music      = love.graphics.newText(self.font_bold, msg_string.music .. ":")
	txt.sfx        = love.graphics.newText(self.font_bold, msg_string.sfx .. ":")
	txt.resolution = love.graphics.newText(self.font_bold, msg_string.resolution .. ":")
	txt.fullscreen = love.graphics.newText(self.font_bold, msg_string.fullscreen .. ":")
	txt.language   = love.graphics.newText(self.font_bold, msg_string.language .. ":")
	txt.credits    = love.graphics.newText(self.font_bold, msg_string.credits)
	--
	txt.saved      = love.graphics.newText(self.font, msg_string.saved .. " " .. app.save_file)
end

--- Update all text textures
function app:update_textures()
	txt.story:set(msg_string.story)
	txt.community:set(msg_string.community)
	txt.settings:set(msg_string.settings)
	txt.exit:set(msg_string.exit)
	--
	txt.music:set(msg_string.music .. ":")
	txt.sfx:set(msg_string.sfx .. ":")
	txt.resolution:set(msg_string.resolution .. ":")
	txt.fullscreen:set(msg_string.fullscreen .. ":")
	txt.language:set(msg_string.language .. ":")
	txt.credits:set(msg_string.credits)
	--
	txt.saved:set(msg_string.saved .. " " .. app.save_file)
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

--- Load shaders
function app:load_shaders()
	shaders.grayscale = love.graphics.newShader("src/assets/shaders/grayscale.glsl")
end

--- Init all app variables
function app:init()
	-- Fonts
	print "Loading fonts..."
	app:load_fonts()
	
	-- Loading language
	print "Loading language file..."
	do_file("lang/" .. app.language .. ".lua")
	
	-- Load text textures
	print "Loading text textures..."
	app:load_text_textures()
	
	-- Load file nodes
	print "Loading nodes..."
	app:load_nodes()
	
	-- Load shaders
	app:load_shaders()
end

--- Set current volume to music sounds
-- @tparam table root Table with contains source elements to set volume
-- @tparam number volume Volume to set all elements
function app:set_sound_volume(root, volume)
	local function set_recursive(node)
		local pos, elem
		for pos, sound in pairs(node) do
			if type(sound) == "table" and not sound.type then
				set_recursive(sound)
			else
				sound:setVolume(volume/100)
			end
		end
	end
	
	set_recursive(root)
end

--- Update app variables
-- @tparam number dt Time since the last update in seconds
function app:update(dt)
	-- Update splash variable
	if not self.loaded and self.total_loading_splash < 1 then
		self.total_loading_splash = self.total_loading_splash + dt

	-- If app not finished to load
	elseif not self.snd_loaded then
		if not self.img_loaded then
			-- If we come back top node, we finish load elements
			if img_tree == nil then
				self.img_loaded = true
				return
			end
			
			img_tree = files.load_node(img_tree, "img")
		else
			-- If we come back top node, we finish load elements
			if snd_tree == nil then
				self.snd_loaded = true
				return
			end
			
			snd_tree = files.load_node(snd_tree, "snd")
		end
	
	-- Loaded
	else
		app:set_sound_volume(snd.music, self.music_volume)
		app:set_sound_volume(snd.effects, self.sfx_volume)
		gamestate.switch(editor)
	end
end

--- Draw loading screen
function app:draw()
	local color = math.min(255, self.total_loading_splash*255)
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
	self.fullscreen   = fullscreen or false
	self.language	  = language or "english"
	
	-- Set scalefactor
	if self.fullscreen then
		local width, height = love.window.getDesktopDimensions()
		local sx, sy = width/app.width, height/app.height
		
		if sx < sy then self.scalefactor = sx
		else self.scalefactor = sy end
		
		self.dx = (width - math.floor(self.scalefactor*320 + 0.5)) / 2
		self.dy = (height - math.floor(self.scalefactor*180 + 0.5)) / 2
	else
		self.scalefactor = scalefactor or 3
		app.dx = 0
		app.dy = 0
	end
	
	width  = math.floor(self.scalefactor*320 + 0.5)
	height = math.floor(self.scalefactor*180 + 0.5)
	love.window.setMode(width, height, {fullscreen = self.fullscreen})
end