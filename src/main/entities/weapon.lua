--- Weapon prototype object.
-- This module construct a weapon object.
--
-- @module  entities.weapon
-- @author	Rafael Alcalde Azpiazu (NEKERAFA)
-- @license GNU General Public License v3

local collider = require "lib.vrld.HC"
local class    = require "lib.vrld.hump.class"
local bullet   = require "src.main.entities.bullet"

local weapon = class {
	--- Create new weapon object
	-- @tparam weapon self New blaster object
	-- @tparam ship ship Ship object attached
	-- @tparam number dx delta x point from ship center where weapon shoot
	-- @tparam number dy delta y point from ship center where weapon shoot
	-- @tparam number width Width of bullet
	-- @tparam number height Height of bullet
	-- @tparam vector velocity Velocity vector
	-- @tparam number damage Damage of bullets
	-- @tparam string type Type of bullets
	-- @tparam number delay Delay between bullets
	init = function(self, ship, dx, dy, width, height, velocity, damage, type, delay)
		self.ship = ship -- Ship attached
		self.dx = dx -- delta x point from ship center where weapon shoot
		self.dy = dy -- delta y point from ship center where weapon shoot
		self.width = width -- width of bullet
		self.height = height -- height of bullet
		self.damage = damage -- damage
		self.velocity = velocity -- velocity
		self.shooted = false -- not shooted
		self.delay = delay -- top of delay
		self.delay_value = 0 -- current delay
  		self.type = type -- type of weapon
		self.bullets = {} -- table of bullets
	end,
	
	--- Update all bullets and variables
	-- @tparam weapon self Weapon object
	-- @tparam number dt Time since the last update in seconds
	update = function(self, dt)
		-- Update all bullet
		for i, bullet in ipairs(self.bullets) do
			bullet:update(dt)
			
			-- If bullet goes out screen, remove it
			if bullet.x < 0 or bullet.x > app.width or bullet.y < 0 or bullet.y > app.height then
				bullet:free()
				table.remove(self.bullets, i)
				break
			end
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
			
			-- x and y centered position
			local x = self.ship.x + self.dx
			local y = self.ship.y + self.dy
			-- x and y top-left position
			local x_top = x - self.width/2
			local y_left = y - self.height/2
			
			-- Create new bullet
			local bullet_shooted = bullet(x, y, self.velocity, self.damage, self.type)
			-- Create collider
			bullet_shooted.collider = collider.rectangle(x_top, y_left, self.width, self.height)
			
			-- Add new bullet
			table.insert(self.bullets, bullet_shooted)
			
			return true
		end
		
		return false
	end,
	
	--- Free current weapon
	-- @tparam weapon self Weapon object
	free = function(self)
		while #self.bullets > 0 do
			self.bullets[1]:free()
			table.remove(self.bullets, 1)
		end
	end
}

-- Return weapon module
return weapon