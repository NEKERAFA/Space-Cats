--- Definition of general game functions in Space Cats
--
-- @author	Rafael Alcalde Azpiazu (NEKERAFA)
-- @license GNU General Public License v3

local gamestate           = require "lib.vrld.hump.gamestate"
local vector              = require "lib.vrld.hump.vector"
local stars               = require "src.main.entities.stars"
local player              = require "src.main.entities.ships.player"
local stars_painter       = require "src.main.painters.stars"
local particles_painter   = require "src.main.painters.particles"
local player_painter      = require "src.main.painters.ships.player"
local small_mouse_painter = require "src.main.painters.ships.small_mouse"
local mouse_painter       = require "src.main.painters.ships.mouse"
local dialog_manager      = require "src.main.dialog"

-- Module game
game = {}

--- Current points
game.points = nil
--- Entities in game
game.entities = nil
--- Number of entities in game
game.n_entities = nil
--- Particles in game
game.particles = nil
--- Player ship
game.player = nil
--- Stars background
game.stars = nil
--- Current level
game.level = "level_0"
--- Time since pop a level entity
game.dt = nil
--- Dialog manager
game.dialog_manager = nil
--- Game started
game.started = false

--- Load game variables and resources
function game:enter()
	-- Set entities
	self.entities = {}
	self.n_entities = 0
	
	-- Set particles
	self.particles = {}
	
	-- Create player
	self.player = player(vector(32, app.height/2))
	
	-- Set points
	self.points = 0
	hud:update_points()
	
	-- Set sounds
	snd.music.space_theme:stop()
	snd.music.brave_space_explorers:setLooping(true)
	snd.music.brave_space_explorers:play()
	
	-- Set time
	self.dt = 0
	
	-- Set dialog manager
	self.dialog_manager = dialog_manager(32, false)
	keyboard_msg = msg_string.moveup..": "..app.up.."\t"..msg_string.moveleft..": "..app.left.."\t"..msg_string.fire..": "..app.fire.."\n"
	keyboard_msg = keyboard_msg..msg_string.movedown..": "..app.down.."\t"..msg_string.moveright..": "..app.right
	self.dialog_manager:add_line(msg_string.controls, keyboard_msg)
	
	-- Load level
	dofile("src/main/levels/" .. self.level .. ".lua")
	level:init()
	
	-- Create stars
	if level.stars then self.stars = stars(vector(-1, 0)) end
end

--- Remove all elements and clear memory
function game:leave()
	-- Entities
	while #game.entities > 0 do
		game.entities[1]:free()
		table.remove(game.entities)
	end
	game.entities = nil

	-- Level entities
	while #level.entities > 0 do
		level.entities[1].object:free()
		table.remove(level.entities)
	end
	level.entities = nil

	-- Particles
	while #game.particles > 0 do
		game.particles[1]:free()
		table.remove(game.particles)
	end
	game.particles = nil
	
	-- Remove player
	game.player:free()
	game.player = nil
	
	-- Clear memory
	collectgarbage("collect")
end

--- Pop new entity
function game:pop_entity()
	--  Insert entity in game
	if level.entities[1].object then
		table.insert(game.entities, level.entities[1].object)
		game.n_entities = game.n_entities + 1
		-- Remove entity from stack level
		table.remove(level.entities, 1)
		level.entities_stacked = level.entities_stacked - 1
	end
end

--- Check level entities stack and pop new entity if it requires
function game:check_level_stack()
	-- Check if there are entities not poped
	if level.entities_stacked > 0 then
		if not level.entities[1].wait then
			-- Check if we can pop new entity
			if game.dt >= level.entities[1].time then
				game.dt = game.dt - level.entities[1].time
				game:pop_entity()
			end
		else
			-- Check if player destroy all entities
			if game.n_entities == 0 and game.dt >= level.entities[1].time then
				game.dt = game.dt - level.entities[1].time
				game:pop_entity()
			end
		end
	end
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
				
				-- Restart game counte
				if level.entities_stacked > 0 and level.entities[1].wait then
					game.dt = 0
				end
		end
	end

	-- Remove marked entities
	while removed > 0 do
		game.entities[remove_entities[removed]]:free()
		table.remove(game.entities, remove_entities[removed])
		game.n_entities = game.n_entities - 1
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

--- Update game variables
-- @tparam number dt Time since the last update in seconds
function game:update(dt)
	-- Update game variables
	if game.started then
		game.dt = game.dt + dt
		-- Check start
		game:check_level_stack()
		-- Update player
		self.player:update(dt)
		-- Update stars
		if level.stars then self.stars:update(dt) end
		-- Update entities
		game:update_entities(dt)
		-- Update particles
		game:update_particles(dt)
		-- Check collisions
		collision.check()
	end
	
	-- Update dialogs
	game.dialog_manager:update(dt)
	if #game.dialog_manager.script == 0 then
		game.started = true
	end
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
	if level.stars then stars_painter.draw(self.stars) end
	-- Draw entities
	game:draw_entities()
	-- Draw player
	player_painter.draw(self.player)
	-- Draw particles
	particles_painter.draw(self.particles)
	-- Draw hud
	hud:draw()
end