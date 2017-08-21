--- Weapon prototype object.
-- This module construct a weapon object.
--
-- @classmod src.main.entities.weapon
-- @see      src.main.entities.bullet
-- @author	 Rafael Alcalde Azpiazu (NEKERAFA)
-- @license  GNU General Public License v3

local class  = require "lib.vrld.hump.class"

local bullet = require "src.main.entities.bullet"

local weapon = class {
	--- Create new weapon object
	-- @tparam weapon self New weapon object
	-- @tparam ship   ship Ship object attached
	-- @tparam vector delta Delta from ship center where weapon shoot
	-- @tparam table  dimensions Dimensions of bullet
	-- @tparam vector velocity Velocity vector
	-- @tparam number damage Damage of bullets
	-- @tparam number delay Delay between bullets
	-- @tparam string type Type of bullets
	init = function(self, ship, delta, dimensions, velocity, damage, delay, type)
		self.ship = ship
		self.delta = delta
		self.dimensions = dimensions
		self.damage = damage
		self.velocity = velocity
		self.delay = delay
		self.type = type
		-- Current delay
		self.delay_value = 0
		-- If weapon have shooted
		self.shooted = false
		-- Table with all shooted bullets
		self.bullets = {}
	end,
	
	--- Update all bullets and variables
	-- @tparam weapon self Weapon object
	-- @tparam number dt Time since the last update in seconds
	update = function(self, dt)
		-- Table with bullets to remove
		remove_bullets = {}
		removed = 0

		-- Update all bullet
		for position, bullet in ipairs(self.bullets) do
			bullet:update(dt)
			-- If bullet goes out screen, remove it
			if bullet.position.x < 0 or bullet.position.x > app.width or 
			   bullet.position.y < 0 or bullet.position.y > app.height then
				table.insert(remove_bullets, position)
				removed = removed + 1
			end
		end

		-- Remove bullets
		while removed > 0 do
			table.remove(self.bullets, remove_bullets[removed])
			removed = removed - 1
		end

		-- Update delay
		if self.shooted then
			self.delay_value = self.delay_value + dt
			-- If delay is in top value, reset it
			if self.delay_value >= self.delay then
				self.delay_value = 0
				self.shooted = false
			end
		end
	end,

	-- Shoot new bullet
	-- @tparam Weapon self Weaon object
	-- @treturn boolean true if shoot new bullet, otherwise false
	shoot = function(self)
		if not self.shooted then
			self.shooted = true
			-- Position of bullet
			position = self.ship.position + self.delta
			-- Create new bullet
			local bullet_shooted = bullet(position, self.velocity, self.dimensions, self.damage, self.type)
			-- Add new bullet
			table.insert(self.bullets, bullet_shooted)

			return true
		end

		return false
	end,
	
	--- Free current weapon
	-- @tparam weapon self Weapon object
	free = function(self)
		-- Remove vectors
		self.delta = nil
		self.velocity = nil
		self.type = "entity"
		-- Remove bullets
		while #self.bullets > 0 do
			self.bullets[1]:free()
			table.remove(self.bullets, 1)
		end
	end
}

-- Return weapon module
return weapon