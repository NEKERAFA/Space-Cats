--- Entity prototype.
-- This module constructs a entity prototype class
--
-- @classmod src.main.entity
-- @author	 Rafael Alcalde Azpiazu (NEKERAFA)
-- @license  GNU General Public License v3

local class            = require "lib.vrld.hump.class"
local vector           = require "lib.vrld.hump.vector"
local collider_manager = require "lib.vrld.HC"

local entity = class {
	--- Create new entity
	-- @tparam entity self New entity to be used
	-- @tparam vector position Start position
	-- @tparam vector velocity Velocity to move entity
	-- @tparam string type Type of entity
	-- @treturn entity New entity
	init = function(self, position, velocity, type)
		self.position = position
		self.velocity = velocity
		self.type = type or "entity"
	end,
	
	--- Update all variable
	-- @tparam entity self Entity object
	-- @tparam number dt Time since the last update in seconds
	update = function(self, dt)
		-- Update position
		self.position = self.position + self.velocity * dt
		-- Update collider
		if self.collider then
			self.collider:moveTo(math.round(self.position.x), math.round(self.position.y))
		end
	end,

	--- Free collider if entity have shape collide
	-- @tparam entity self Entity object
	free = function(self)
		-- Remove collider
		if self.collider then
			collider_manager.remove(self.collider)
		end
		
		-- Remove vectors
		self.position = nil
		self.velocity = nil
		self.type = nil

		-- Collect garbage
		collectgarbage("collect")
	end
}

return entity