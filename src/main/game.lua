--- Definition of general game functions in Space Cats
--
-- @author	Rafael Alcalde Azpiazu (NEKERAFA)
-- @license GNU General Public License v3

local gamestate      = require "lib.vrld.hump.gamestate"
local player         = require "src.main.entities.ships.player"
local painter_player = require "src.main.painters.ships.player"

game = {point = 0, entities = {}}

function game:init()
	game.player = player(32, app.height/2)
end

function game:update(dt)
	game.player:update(dt)
end

function game:draw(dt)
	love.graphics.draw(img.backgrounds.space, 0, 0)
	
	painter_player.draw(game.player)
end