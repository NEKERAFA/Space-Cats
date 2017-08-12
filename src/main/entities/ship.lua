--- Ship prototype object.
-- This module construct a ship object. See diagram for know atributes.
--
-- @classmod src.main.entities.ship
-- @see      src.main.entity
-- @author	 Rafael Alcalde Azpiazu (NEKERAFA)
-- @license  GNU General Public License v3

local class            = require "lib.vrld.hump.class"
local collider_manager = require "lib.vrld.HC"

local entity           = require "src.main.entities.entity"

local ship = class {
	--- Create a new ship
	-- @tparam ship self A ship to be used
	-- @tparam vector position Start position
	-- @tparam vector velocity Velocity to move ship
	-- @tparam table  dimensions Table with ship dimensions
	-- @tparam weapon weapon Weapon object
	-- @tparam number life Current life
	-- @tparam number shield Time of protection when ship receives damage in seconds
	-- @tparam string type Type of ship
	init = function(self, position, velocity, dimensions, weapon, life, shield, type)
		entity.init(self, position, velocity, type)
		self.weapon = weapon
		self.life = life
		self.shield = shield
		self.damaged_time = 0
		self.destroyed = false
		self.damaged = false

		-- Create collider
		rect_x = position.x - math.round(dimensions.w/2)
		rect_y = position.y - math.round(dimensions.h/2)
		self.collider = collider_manager.rectangle(rect_x, rect_y, dimensions.w, dimensions.h)
	end,
	
	--- Inherit entity class
	__includes = entity,
	
	--- Update status after explosion animation
	-- @tparam anim animation Current animation object
	-- @tparam number loops Number of loops done
	end_explotion = function(animation, loops)
		animation:pause()
		animation.ship.destroyed = true
	end,
	
	--- Set damage to current ship
	-- @tparam ship self Ship object
	-- @tparam number damage Damage to make
	damage = function(self, damage)
		if not self.damaged then
			-- Make damage
			if self.life > 0 then
				self.life = math.max(self.life - damage, 0)
				self.damaged = true
			end

			if self.life == 0 then
				-- Remove collider
				collider_manager.remove(self.collider)
				self.collider = nil
				-- Show explosion
				self.explosion:resume()
				snd.effects.explosion:rewind()
				snd.effects.explosion:play()
			end
			return true
		end
		
		return false
	end,
	
	--- Update all variables in the ship and move it
	-- @tparam ship self Ship object
	-- @tparam number dt Time since the last update in seconds
	update = function(self, dt)
		-- Update flame animation
		if self.flame then self.flame:update(dt) end
		-- Update explosion
		if self.explosion then self.explosion:update(dt) end
		-- Update weapon
		if self.weapon then self.weapon:update(dt) end

		-- Update damage time
		if self.damaged then
			self.damaged_time = self.damaged_time + dt
			-- If damaged value is top value, reset it
			if self.damaged_time >= self.shield then
				self.damaged_time = 0
				self.damaged = false
			end
		end
	end,
		
	--- Free current ship
	-- @tparam ship self Ship object
	free = function(self)
		-- Remove weapon
		self.weapon:free()
		self.weapon = nil

		-- Remove animations
		self.flame = nil
		self.explosion = nil
		self.threshold = nil
		
		-- Remove variables
		entity.free(self)
	end
}

-- Return ship module
return ship