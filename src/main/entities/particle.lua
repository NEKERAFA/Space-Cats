--- Create particle prototype object.
-- This module construct a particle to create a simple system to emit damage and points particles.
--
-- @classmod src.main.entities.particle
-- @see      src.main.entity
-- @author	 Rafael Alcalde Azpiazu (NEKERAFA)
-- @license  GNU General Public License v3

local class  = require "lib.vrld.hump.class"
local entity = require "src.main.entities.entity"

local particle = class {
	--- Create a new particle entity
	-- @tparam particle self New particle
	-- @tparam vector position Start position
	-- @tparam vector velocity Particle velocity
	-- @tparam number lifetime Maximun particle lifetime
	-- @tparam number value Value of particle
	-- @tparam string type Type of particle
	init = function(self, position, velocity, lifetime, value, type)
		entity.init(self, position, velocity, type)
		self.value = value
		self.max_lifetime = lifetime
		self.lifetime = 0
		self.dead = false
	end,

	--- Inherit entity class
	__includes = entity,

	--- Update all variables and move particle
	-- @tparam particle self Particle object
	-- @tparam number dt Time since the last update in seconds
	update = function(self, dt)
		if not self.dead then
			-- Move particle
			entity.update(self, dt)
			-- Update life particle time
			self.lifetime = math.min(self.max_lifetime, self.lifetime + dt)
			if self.lifetime == self.max_lifetime then
				self.dead = true
			end
		end
	end
}

return particle