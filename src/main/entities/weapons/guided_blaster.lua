--- Gided blaster prototype object.
-- This module construct a blaster weapon object.
--
-- @classmod src.main.entities.weapons.guided_baster
-- @see      src.main.entities.weapon
-- @author	 Rafael Alcalde Azpiazu (NEKERAFA)
-- @license  GNU General Public License v3

local vector = require "lib.vrld.hump.vector"
local class  = require "lib.vrld.hump.class"

local weapon = require "src.main.entities.weapon"

local guided_blaster = class {
	--- Create new guided baster object
	-- @tparam guided_blaster self New blaster object
	-- @tparam ship ship Ship object attached
	-- @tparam ship pointed Ship to shoot
	-- @tparam vector delta Delta from ship center where weapon shoot
	init = function(self, ship, pointed, delta)
		-- Set weapon
		weapon.init(self, ship, delta, {w = 8, h = 8}, vector(0,0), 1, 2, "guided_blaster")
		-- Set pointed
		self.pointed = pointed
	end,
	
	--- Inherit weapon class
	__includes = weapon,
	
	--- Velocity of bullets
	max_velocity = 1*app.frameRate,
	
	--- Update all bullets and variables
	-- @tparam guided_blaster self Guided blaster object
	-- @tparam number dt Time since the last update in seconds
	update = function(self, dt)
		-- Update direction
		local direction = (self.pointed.position - self.ship.position):normalized()
		self.velocity = direction * self.max_velocity
		weapon.update(self, dt)
	end
}

-- Return guided_blaster module
return guided_blaster