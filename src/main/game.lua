--- Definition of general game functions in Space Cats
--
-- @module  main.game
-- @author	Rafael Alcalde Azpiazu (NEKERAFA)
-- @license GNU General Public License v3

local gamestate           = require "lib.vrld.hump.gamestate"
local vector              = require "lib.vrld.hump.vector"
local small_mouse_painter = require "src.main.painters.ships.small_mouse"
local player              = require "src.main.entities.ships.player"
local player_painter      = require "src.main.painters.ships.player"

-- Module game
game = {}

--- Current points
game.points = 0
--- Entities in game
game.entities = {}
--- Number of entities in game
game.n_entities = 0
--- Player ship
game.player = nil
--- Stars background
game.stars = nil
--- Current level
game.level = "level_0"
--- Time since pop a level entity
game.dt = 0

--- Load game variables and resources
function game:init()
	-- Load level
	dofile("src/main/levels/" .. game.level .. ".lua")
	level:init()
	-- Create player
	self.player = player(vector(32, app.height/2))
	-- Create stars
	self.stars = stars.new(vector(-1, 0))
	-- Set sounds
	snd.music.space_theme:stop()
	snd.music.brave_space_explorers:setLooping(true)
	snd.music.brave_space_explorers:play()
end

--- Pop new entity
function game:pop_entity()
	--  Insert entity in game
	table.insert(game.entities, level.entities[1].object)
	game.n_entities = game.n_entities + 1
	-- Remove entity from stack level
	table.remove(level.entities, 1)
	level.entities_stacked = level.entities_stacked - 1
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
			if game.n_entities == 0 then
				game.dt = 0
				game:pop_entity()
			end
		end
	end
end

--- Update level entities
function game:update_entities(dt)
	remove_entities = {}
	removed = 0

	-- Update all enities
	for position, entity in ipairs(game.entities) do
		entity:update(dt)
		-- Check if entity exit screen and mark it to remove
		if entity.position.x < -64 or entity.position.x > app.width+64 or
		   entity.position.y < -64 or entity.position.y > app.height+64 then
				table.insert(remove_entities, position)
				removed = removed + 1
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

--- Update game variables
-- @tparam number dt Time since the last update in seconds
function game:update(dt)
	-- Check stack
	game.dt = game.dt+dt
	game:check_level_stack()
	-- Update player
	self.player:update(dt)
	-- Update stars
	stars.update(self.stars, dt)
	-- Update entities
	game:update_entities(dt)
end

--- Draw entities
function game:draw_entities()
	for pos, entity in ipairs(self.entities) do
		small_mouse_painter.draw(entity)
	end
end

--- Draw game resources, textures and interface
-- @tparam number dt Time since the last update in seconds
function game:draw(dt)
	-- Draw background
	love.graphics.draw(img.backgrounds.space, 0, 0)
	-- Draw stars
	stars.draw(self.stars)
	-- Draw entities
	game:draw_entities()
	-- Draw player
	player_painter.draw(self.player)
	-- Draw hud
	hud:draw()
end