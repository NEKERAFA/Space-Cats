--- Gided blaster prototype object.
-- This module construct a blaster weapon object.
--
-- @module  guided_baster
-- @author	Rafael Alcalde Azpiazu (NEKERAFA)
-- @license GNU General Public License v3

local vector = require "lib.vrld.hump.vector"
local class  = require "lib.vrld.hump.class"
local weapon = require "src.main.entities.weapon"

local guided_blaster = class {
	--- Create new guided baster object
	-- @tparam ship ship Ship object attached
	-- @tparam ship pointer Ship to shoot
	-- @tparam number dx x position to shoot
	-- @tparam number dy y position to shoot
	-- @tparam vector velocity Velocity vector
	-- @tparam self guided_blaster New blaster object
	init = function(self, ship, pointed, dx, dy, velocity)
		-- Get direction
		local direction = vector(ship.x-pointed.x, ship.y-pointed.y)
		local velocity = direction:normalizeInplace() * velocity:len()
		
		weapon.init(self, ship, dx, dy, 4, 4, velocity, 1, "guided_blaster", 2)
	end,
	
	--- Inherit weapon class
	__includes = weapon,
	
	--- Update all bullets and variables
	-- @tparam guided_blaster self Guided blaster object
	-- @tparam number dt Time since the last update in seconds
	update = function(self, dt)
		-- Update direction
		local direction = vector(ship.x-pointed.x, ship.y-pointed.y)
		self.velocity = direction:normalizeInplace() * self.velocity:len()
		
		weapon.update(self, dt)
	end
}

-- Return guided_blaster module
return guided_blaster