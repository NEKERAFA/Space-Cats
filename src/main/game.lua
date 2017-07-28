--- Definition of general game functions in Space Cats
--
-- @module  game
-- @author	Rafael Alcalde Azpiazu (NEKERAFA)
-- @license GNU General Public License v3

local gamestate      = require "lib.vrld.hump.gamestate"
local player         = require "src.main.entities.ships.player"
local painter_player = require "src.main.painters.ships.player"

-- Module game
game = {}

--- Current points
game.points = 0
--- All level entities
game.entities = {}
-- Player ship
game.player = nil

--- Load game variables and resources
function game:init()
	-- Create player
	game.player = player(32, app.height/2)
end

--- Update game variables
-- @tparam number dt Time since the last update in seconds
function game:update(dt)
	-- Update player
	game.player:update(dt)
end

-- Draw game resources, textures and interface
function game:draw(dt)
	-- Draw background
	love.graphics.draw(img.backgrounds.space, 0, 0)
	-- Draw player
	painter_player.draw(game.player)
end