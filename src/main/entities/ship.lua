--- Ship prototype object.
-- This module construct a ship object. See diagram for know atributes.
--
-- @module  ship
-- @author	Rafael Alcalde Azpiazu (NEKERAFA)
-- @license GNU General Public License v3

local collider = require "lib.vrld.HC"
local class    = require "lib.vrld.hump.class"

local ship = class {
	--- Create a new ship
	-- @tparam number x New x position
	-- @tparam number y New y position
	-- @tparam number life Current life
	-- @tparam string type Type of ship
	-- @tparam ship self A ship to be used
	init = function(self, x, y, life, type)
		self.x = x
		self.y = y
		self.life = life
		self.type = type
		self.destroyed = false
		self.damaged = false
		self.damaged_value = 0
	end,
	
	--- Maximun damaged value
	damaged_max = 0.1,
	
	--- Velocity
	velocity = 2,
	
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
				collider.remove(self.collider)
				self.collider = nil
				-- Show explosion
				self.explosion:resume()
				sfx.explosion:rewind()
				sfx.explosion:play()
			end
		end
	end,
	
	--- Update all variables in the ship and move it
	-- @tparam ship self Ship object
	-- @tparam number dt Time since the last update in seconds
	update = function(self, dt)
		-- Update flame animation
		if self.flame then self.flame:update(dt) end

		-- Update explosion
		if self.explosion then self.explosion:update(dt) end
		
		-- Update damage
		if self.damaged then
			self.damaged_value = self.damaged_value + dt
			
			-- If damaged value is top value, reset it
			if self.damaged_value >= self.damaged_max then
				self.damaged_value = 0
				self.damaged = false
			end
		end

		-- Update weapon
		if self.weapon then self.weapon:update(dt) end
	end,
		
	--- Free current ship
	-- @tparam ship self Ship object
	free = function(self)
		-- Remove weapon
		self.weapon_free()
		self.weapon = nil

		-- Remove animations
		self.flame = nil
		self.explosion = nil
		self.threshold = nil

		self = nil
		collectgarbage('collect')
	end
}

-- Return ship module
return ship