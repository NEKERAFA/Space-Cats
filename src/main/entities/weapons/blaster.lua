--- blaster prototype object.
-- This module construct a blaster weapon object.
--
-- @module  entities.weapons.baster
-- @author	Rafael Alcalde Azpiazu (NEKERAFA)
-- @license GNU General Public License v3

local class  = require "lib.vrld.hump.class"
local weapon = require "src.main.entities.weapon"

local blaster = class {
	--- Create new baster object
	-- @tparam blaster self New blaster object
	-- @tparam ship ship Ship object attached
	-- @tparam number dx x position to shoot
	-- @tparam number dy y position to shoot
	-- @tparam vector velocity Velocity vector
	init = function(self, ship, dx, dy, velocity)
		weapon.init(self, ship, dx, dy, 4, 4, velocity, 1, "blaster", 0.25)
	end,
	
	--- Inherit weapon class
	__includes = weapon,
}

-- Return blaster module
return blaster