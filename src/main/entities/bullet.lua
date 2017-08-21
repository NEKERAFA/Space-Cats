--- bullet prototype object.
-- This module construct a bullet object.
--
-- @classmod src.main.entities.bullet
-- @see      src.main.entity
-- @author	 Rafael Alcalde Azpiazu (NEKERAFA)
-- @license  GNU General Public License v3

local entity           = require "src.main.entities.entity"
local class            = require "lib.vrld.hump.class"

local collider_manager = require "lib.vrld.HC"

local bullet = class {
	--- Create a new bullet
	-- @tparam bullet self A bullet object to be used
	-- @tparam vector position Start position
	-- @tparam vector velocity Velocity to move entity
	-- @tparam table  dimensions Table with bullet dimensions
	-- @tparam number damage Current damage of bullet
	-- @tparam string type Type of bullet
	init = function(self, position, velocity, dimensions, damage, type)
		entity.init(self, position, velocity, type)
		-- Collider shape
		local rect_x = position.x - math.round(dimensions.w/2)
		local rect_y = position.y - math.round(dimensions.h/2)
		self.collider = collider_manager.rectangle(rect_x, rect_y, dimensions.w, dimensions.h)
		-- Damage
		self.damage = damage
	end,
	
	--- Inherit entity class
	__includes = entity
}

-- Return bullet module
return bullet
