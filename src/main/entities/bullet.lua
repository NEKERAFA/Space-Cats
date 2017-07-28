--- bullet prototype object.
-- This module construct a bullet object.
--
-- @module  entities.bullet
-- @author	Rafael Alcalde Azpiazu (NEKERAFA)
-- @license GNU General Public License v3

local collider = require "lib.vrld.HC"
local class    = require "lib.vrld.hump.class"

local bullet = class {
	--- Create a new bullet
	-- @tparam bullet self A bullet object to be used
	-- @tparam number x New x position
	-- @tparam number y New y position
	-- @tparam vector velocity New velocity
	-- @tparam number damage Current damage of bullet
	-- @tparam string type Type of bullet
	init = function(self, x, y, velocity, damage, type)
		-- Set variables
		self.x = x
		self.y = y
		self.velocity = velocity
		self.damage = damage
		self.type = type
	end,
	
	--- Move the current bullet
	-- @tparam bullet self Bullet object
	-- @tparam number dt Time since the last update in seconds
	update = function(self, dt)
		-- Update position
		self.x = self.x + self.velocity.x * dt
		self.y = self.y + self.velocity.y * dt

		-- Update collider
		self.collider:moveTo(self.x, self.y)
	end,
	
	--- Free current bullet
	-- @tparam bullet self Bullet object
	free = function(self)
		-- Remove collider from space collider
		collider.remove(self.collider)
	end
}

-- Return bullet module
return bullet
