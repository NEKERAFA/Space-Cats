--- Definition of general game functions in Space Cats
--
-- @module  game
-- @author	Rafael Alcalde Azpiazu (NEKERAFA)
-- @license GNU General Public License v3

local gamestate      = require "lib.vrld.hump.gamestate"
local vector         = require "lib.vrld.hump.vector"
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
-- Stars background
game.stars = nil

--- Load game variables and resources
function game:init()
	-- Create player
	self.player = player(32, app.height/2)
	-- Create stars
	self.stars = stars.new(vector(-1, 0))
	-- Set sounds
	snd.music.space_theme:stop()
	snd.music.brave_space_explorers:setLooping(true)
	snd.music.brave_space_explorers:play()
end

--- Update game variables
-- @tparam number dt Time since the last update in seconds
function game:update(dt)
	-- Update player
	self.player:update(dt)
	-- Update stars
	stars.update(self.stars, dt)
end

--- Draw game resources, textures and interface
function game:draw(dt)
	-- Draw background
	love.graphics.draw(img.backgrounds.space, 0, 0)
	-- Draw stars
	stars.draw(self.stars)
	-- Draw player
	painter_player.draw(self.player)
	-- Draw hud
	hud:draw()
end