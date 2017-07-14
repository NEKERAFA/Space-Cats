--- Definition of splash functions in Space Cats
--
-- @author	Rafael Alcalde Azpiazu (NEKERAFA)
-- @license GNU General Public License v3

local o_ten_one = require 'love2d-community.splashes.o-ten-one'

splash = {done = false}

--- Load splash information
function splash.load()
	splash.anim = o_ten_one({background={0,0,0}})
	splash.anim.onDone = function()
		splash.done = true
		game.run = true
	end
end

splash.load()