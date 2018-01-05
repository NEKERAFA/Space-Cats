--- blaster prototype object.
-- This module construct a blaster weapon object.
--
-- @classmod src.main.entities.weapons.baster
-- @see      src.main.entities.weapon
-- @author	 Rafael Alcalde Azpiazu (NEKERAFA)
-- @license  GNU General Public License v3

local class  = require "lib.vrld.hump.class"

local weapon = require "src.main.entities.weapon"

local blaster = class {
	--- Create new baster object
	-- @tparam weapon self New blaster object
	-- @tparam ship   ship Ship object attached
	-- @tparam vector delta Delta from ship center where weapon shoot
	-- @tparam vector velocity Velocity vector
	init = function(self, ship, delta, velocity)
		weapon.init(self, ship, delta, {w = 4, h = 4}, velocity, 1, 0.25, "blaster")
	end,
	
	--- Inherit weapon class
	__includes = weapon,
}

-- Return blaster module
return blaster