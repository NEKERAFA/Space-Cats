--- Mockup player prototype object.
-- This module construct a ship object with player apearance (For sequences or animations where player not have control).
--
-- @module  entities.ships.mockup_player
-- @author	Rafael Alcalde Azpiazu (NEKERAFA)
-- @license GNU General Public License v3

local collider = require "lib.vrld.HC"
local anim8    = require "lib.kikito.anim8.anim8"
local class    = require "lib.vrld.hump.class"
local ship     = require "src.main.entities.ship"

-- Module
player = class {
	--- Create new player
	-- @tparam ship self A ship to be used
	-- @tparam number x New x position
	-- @tparam number y New y position
	-- @treturn player New playership
	init = function(self, x, y)
		-- Create animation grid
		local flame_grid = anim8.newGrid(16, 16, 16, 64)
		
		ship.init(self, x, y, 1, "player")
	
		-- Create collider
		self.collider = collider.rectangle(x-16, y-6, 32, 12)
		
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
