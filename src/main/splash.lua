--- This module load an show Löve splash
--
-- @module  splash
-- @author	Rafael Alcalde Azpiazu (NEKERAFA)
-- @license GNU General Public License v3

local gamestate = require "lib.vrld.hump.gamestate"
local o_ten_one = require "lib.love2d-community.splashes.o-ten-one"

-- Module splash
splash = {}

--- Load splash variables and resources
function splash:init()
	splash.anim = o_ten_one({background={0,0,0}})
	splash.anim.onDone = function()
		gamestate.switch(app)
	end
end

--- Update splash variables
-- @tparam number dt Time since the last update in seconds
function splash:update(dt)
	splash.anim:update(dt)
end

--- Draw splash animation
function splash:draw(dt)
	splash.anim:draw(dt)
end