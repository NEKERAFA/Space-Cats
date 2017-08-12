--- Definition of general game functions in Space Cats
--
-- @author	Rafael Alcalde Azpiazu (NEKERAFA)
-- @license GNU General Public License v3

local gamestate           = require "lib.vrld.hump.gamestate"
local vector              = require "lib.vrld.hump.vector"

local player              = require "src.main.entities.ships.player"
local mockup_player       = require "src.main.entities.ships.mockup_player"
local mouse               = require "src.main.entities.ships.mouse"
local small_mouse         = require "src.main.entities.ships.small_mouse"

local hud_painter         = require "src.main.painters.hud"
local stars_painter       = require "src.main.painters.stars"
local particles_painter   = require "src.main.painters.particles"

local player_painter      = require "src.main.painters.ships.player"
local small_mouse_painter = require "src.main.painters.ships.small_mouse"
local mouse_painter       = require "src.main.painters.ships.mouse"

local stars_manager       = require "src.main.managers.stars"
local dialog_manager      = require "src.main.managers.dialogs"
local level_manager       = require "src.main.managers.levels"
local collision_manager   = require "src.main.collisions"

-- Module game
game = {}

--- Current points
game.points = nil
--- Entities in game
game.entities = nil
--- Particles in game
game.particles = nil
--- Player ship
game.player = nil
--- Current level
game.level = "src/main/levels/level_0.lua"
--- Stars background
game.stars_manager = nil
--- Dialog manager
game.dialog_manager = nil
--- Level manager
game.level_manager = nil

--- Create new mouse 
-- @tparam table args Arguments to create mouse
local function create_mouse(args)
	from    = vector(args[1].x, args[1].y)
	to      = vector(args[2].x, args[2].y)
	pointed = game.player
	return mouse(from, to, pointed)
end
	
--- Create new small mouse
-- @tparam table args Arguments to create small mouse
local function create_small_mouse(args)
	path       = {}
	wait_point = vector(args[2].x, args[2].y)
	bullets    = args[3]
	for pos, point in ipairs(args[1]) do
		table.insert(path, vector(point.x, point.y))
	end
	return small_mouse(path, wait_point, bullets)
end
	
--- Create new dialog
-- @tparam table args Arguments to create dialog
local function create_dialog(args)
	if #args > 1 then
		return {title = args[1], message = args[2]}
	end
	return {message = args[1]}
end

--- Load managers and variables
function game:init()
	game.dialog_manager = dialog_manager(32)
	game.level_manager = level_manager()
end

--- Load game variables and resources
function game:enter()
	-- Set entities
	self.entities = {}
	
	-- Set particles
	self.particles = {}
	
	-- Create player
	self.player = player(vector(32, app.height/2))
	
	-- Set points
	self.points = 0
	hud_painter:update_points(0)
	
	-- Load level
	self.level_manager:load(self.level)
	
	-- Set sounds
	snd.music.space_theme:stop()
	self.level_manager.bgm:setLooping(true)
	self.level_manager.bgm:play()
	
	-- Create stars
	if self.level_manager.stars then
		self.stars_manager = stars_manager(vector(-1, 0))
	end
end

--- Remove all elements and clear memory
function game:leave()
	-- Entities
	while #self.entities > 0 do
		self.entities[1]:free()
		table.remove(self.entities)
	end
	self.entities = nil

	-- Particles
	while #self.particles > 0 do
		self.particles[1]:free()
		table.remove(self.particles)
	end
	self.particles = nil

	-- Remove level entities
	self.level_manager:free()

	-- Remove player
	self.player:free()
	self.player = nil

	-- Remove stars
	self.stars_manager:free()
	self.stars_manager = nil

	-- Clear memory
	collectgarbage("collect")
end

--- Update level entities
-- @tparam number dt Time since the last update in seconds
function game:update_entities(dt)
	remove_entities = {}
	removed = 0

	-- Update all entities
	for position, entity in ipairs(game.entities) do
		entity:update(dt)
		-- Check if entity exit screen and mark it to remove
		if entity.position.x < -64 or entity.position.x > app.width+64 or
		   entity.position.y < -64 or entity.position.y > app.height+64 or
		   entity.destroyed then
				table.insert(remove_entities, position)
				removed = removed + 1
		end
	end

	-- Remove marked entities
	while removed > 0 do
		game.entities[remove_entities[removed]]:free()
		table.remove(game.entities, remove_entities[removed])
		removed = removed - 1
	end
end

--- Update particles
-- @tparam number dt Time since the last update in seconds
function game:update_particles(dt)
	remove_particles = {}
	removed = 0
	
	-- Update all particles
	for position, particle in ipairs(game.particles) do
		particle:update(dt)
		-- Remove particle if it need
		if particle.dead then
			table.insert(remove_particles, position)
			removed = removed + 1
		end
	end
	
	-- Remove marked particles
	while removed > 0 do
		game.particles[remove_particles[removed]]:free()
		table.remove(game.particles, remove_particles[removed])
		removed = removed - 1
	end
end

--- Update level variables and check if can pop new entities
-- @tparam number dt Time since the last update in seconds
function game:update_level(dt)
	-- Check if all entities are poped
	if #self.entities == 0 and #self.dialog_manager.script == 0 then
		self.level_manager.poped_entities_destroyed = true
	end
	
	-- Update level manager
	self.level_manager:update(dt)
	-- Check if it can pop new entity
	entity_data = self.level_manager:pop_entity()
	
	-- Load new entity
	if entity_data then
		-- Create a mouse
		if entity_data.type == "mouse" then
			table.insert(game.entities, create_mouse(entity_data.args))
		end
		
		-- Create a small mouse
		if entity_data.type == "small_mouse" then
			table.insert(game.entities, create_small_mouse(entity_data.args))
		end
		
		-- Create a dialog
		if entity_data.type == "dialog" then
			dialog = create_dialog(entity_data.args)
			if dialog.title == nil then
				self.dialog_manager:add_text(dialog.message)
			else
				self.dialog_manager:add_line(dialog.title, dialog.message)
			end
		end
	end
end

--- Update game variables
-- @tparam number dt Time since the last update in seconds
function game:update(dt)
	-- Update level
	game:update_level(dt)
	-- Update player
	self.player:update(dt)
	-- Update entities
	game:update_entities(dt)
	-- Update particles
	game:update_particles(dt)
	
	-- Check collisions
	points = collision_manager:check(self.player, self.entities, self.particles)
	if points then
		self.points = self.points + points
		hud_painter:update_points(self.points)
	end

	-- Update stars
	if self.stars_manager ~= nil then 
		self.stars_manager:update(dt)
	end
	
	-- Update dialogs
	self.dialog_manager:update(dt)
end

--- Update menu variable
-- @tparam KeyConstant key Character of the pressed key
-- @tparam Scancode scancode The scancode representing the pressed key
-- @tparam bolean isrepeat Whether this key press event is a repeat. The delay between key depends on the user's system settings
function game:keypressed(key, scancode, isrepeat)
	-- Update dialogs
	game.dialog_manager:keypressed(key, scancode, isrepeat)
end

--- Draw entities
function game:draw_entities()
	for pos, entity in ipairs(self.entities) do
		if entity.type == "mouse" then
			mouse_painter.draw(entity)
		elseif entity.type == "small_mouse" then
			small_mouse_painter.draw(entity)
		end
	end
end

--- Draw game resources, textures and interface
-- @tparam number dt Time since the last update in seconds
function game:draw(dt)
	-- Draw background
	love.graphics.draw(img.backgrounds.space, 0, 0)
	-- Draw stars
	if self.stars_manager then 
		stars_painter.draw(self.stars_manager)
	end
	-- Draw entities
	game:draw_entities()
	-- Draw player
	player_painter.draw(self.player)
	-- Draw particles
	particles_painter.draw(self.particles)
	-- Draw hud
	hud_painter:draw(4, self.player.weapon, self.dialog_manager)
end