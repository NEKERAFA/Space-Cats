--- Definition of splash functions in Space Cats
--
-- @author	Rafael Alcalde Azpiazu (NEKERAFA)
-- @license GNU General Public License v3

local gamestate = require "lib.vrld.hump.gamestate"
local o_ten_one = require "lib.love2d-community.splashes.o-ten-one"

splash = {}

--- Load splash information
function splash:init()
	splash.anim = o_ten_one({background={0,0,0}})
	splash.anim.onDone = function()
		gamestate.switch(app)
	end
end

function splash:update(dt)
	splash.anim:update(dt)
end

function splash:draw(dt)
	splash.anim:draw(dt)
end