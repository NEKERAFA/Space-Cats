--- Mockup player prototype object.
-- This module construct a ship object with player apearance (For sequences or animations where player not have control).
--
-- @classmod src.main.entities.ships.mockup_player
-- @see      src.main.entities.ship
-- @author	 Rafael Alcalde Azpiazu (NEKERAFA)
-- @license  GNU General Public License v3

local anim8    = require "lib.kikito.anim8"

local class    = require "lib.vrld.hump.class"
local vector   = require "lib.vrld.hump.vector"

local ship     = require "src.main.entities.ship"

-- Module
local player = class {
	--- Create new player
	-- @tparam ship self A ship to be used
	-- @tparam vector position Start position
	-- @treturn player New playership
	init = function(self, position)
		-- Create animation grid
		local flame_grid = anim8.newGrid(16, 16, 16, 64)
		ship.init(self, position, vector(0,0), {w = 32, h = 12}, nil, 4, 4, "player")
		-- Create animations
		self.flame = anim8.newAnimation(flame_grid(1, '1-4'), 0.05)
	end,
	
	--- Inherit ship class
	__includes = ship,
	
	--- Update all variables in the player
	-- @tparam ship self Ship object
	-- @tparam number dt Time since the last update in seconds
	update = function(self, dt)
		ship.update(self, dt)
	end
}

-- Return player module
return player
