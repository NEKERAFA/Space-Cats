--- Ray blaster prototype object.
-- This module construct a ray weapon object. Note: due to complexity of ray blaster, this module doesn't inherit from weapon.
--
-- @classmod src.main.entities.weapons.ray_baster
-- @see      src.main.entities.weapon
-- @author	 Rafael Alcalde Azpiazu (NEKERAFA)
-- @license  GNU General Public License v3

local collider = require "lib.vrld.HC"

local class    = require "lib.vrld.hump.class"

local ray_blaster = class {
	--- Create new ray blaster weapon
	-- @tparam ray_blaster self New blaster object
	-- @tparam ship ship Ship object attached
	-- @tparam number dx x position to shoot
	-- @tparam number dy y position to shoot
	-- @tparam number size Size of ray
	-- @tparam vector direction Direction of ray
	-- @tparam number damage Damage of bullets
	-- @tparam number collition_entities Table of entities which ray can collide
	init = function(self, ship, dx, dy, size, direction, damage, collition_entities)
		self.ship = ship
		self.dx = dx
		self.dy = dy
		self.size = size
		self.direction = direction
		self.damage = damage
		self.collition_entities = collition_entities
		self.shooted = false
		self.type = "ray_blaster"
	end,
	
	--- Update all bullets and variables
	-- @tparam weapon self Weapon object
	-- @tparam number dt Time since the last update in seconds
	update = function(self, dt)
		-- If we are shooting, check all ray tracer
		if self.shooted then
			-- Get ray tracer an entity which ray collide
			ray, entity = self:get_ray_tracer()
			
			-- Update variables
			self.ray = ray
			self.collide_entity = entity			
			self.shooted = false
		-- If we aren't shooting but ray variable exists, delete it
		elseif self.ray then
			self.ray = nil
		end
	end,

	--- Get line points of ray tracer and last entity collided
	-- @tparam weapon self Weapon object
	-- @return a table with ray line and last entity can reach ray
	get_ray_tracer = function(self)
		-- Point where shoot
		local shot = {x = ship.x + dx, y = ship.y + dy}
		-- Last ray x point
		local last_x = app.width
		--- Last ray y point
		local last_y = app.height
		-- Last enemy
		local last_entity = nil

		-- Get all entities to check ray tracer collision
		for i, entity in ipairs(self.collition_entities) do
			-- Check if entity has collider box
			if entity.collider then
				-- Check collider ray tracer
				local ray_test, ray_param = entity.collider:intersectsRay(shot.x, shot.y, direction.x, direction.y)
				
				if ray_test then
					-- Get collition point
					local x = shot.x + direction.x * ray_param
					local y = shot.y + direction.y * ray_param
					-- If collision point is closer than last ray point, update this
					if x - last_x < 0 or y - last_y < 0 then
						last_x = x; last_y = y
						last_entity = entity
					end
				end -- if ray_test
			end -- if entity.collider
		end -- foreach entity
		
		return {shot.x, shot.y, last_x, last_y}, last_entity
	end,

	-- Shoot new bullet
	-- @tparam Weapon self Weapon object
	-- @treturn boolean true if shoot new bullet, otherwise false
	shoot = function(self, dt)
		self.shooted = true
	end
}

return ray_blaster