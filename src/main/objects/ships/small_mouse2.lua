--- Enemy ship prototype object.
-- This module construct a ship object that represents a enemy.
--
-- @module  small_mouse
-- @author	Rafael Alcalde Azpiazu (NEKERAFA)
-- @license GNU General Public License v3

local ship = require 'ship'
local bullet = require 'bullet'
local vector = require 'nekerafa.collections.src.math.vector'
local collider = require 'vrld.HC'

-- Module
local small_mouse2 = ship.extends()

--- Threshold to change path point
small_mouse2.path_threshold = 1

--- Velocity
small_mouse2.velocity = 2

--- Create a new enemy
-- @tparam table  from Point where ship apperar
-- @tparam table  point Point where ship will shoot (Must be in the path)
-- @treturn ship A ship to be used
function small_mouse2.new(from, point)
	local mouse_ship = small_mouse2.super.new(from.x, from.y, 2, "small_mouse2")
	local meta = getmetatable(mouse_ship)

	-- Variables
    mouse_ship.point = point -- Point where ship must shoot
	mouse_ship.flame = mouse_ship.flame:flipH() -- Flips flame
	-- Distance vector
	mouse_ship.distance_v = vector(point.x-from.x, point.y-from.y, 0)
	-- Velocity vector
	mouse_ship.velocity_v = mouse_ship.distance_v:unit()*love.game.frameRate
	-- Color to see damage
	mouse_ship.color = 255

	-- Mouse collider
	mouse_ship.collider = collider.rectangle(from.x-16, from.y-6, 32, 12)

    -- Overiden methods
	mouse_ship.damage = small_mouse2.damage
	mouse_ship.update = small_mouse2.update
	mouse_ship.move   = small_mouse2.move

	-- Overiden metamethods
	meta["__gc"] = small_mouse2.free

	return setmetatable(mouse_ship, meta)
end

--- Set damage to current ship
-- @tparam ship self Ship object
-- @tparam number damage Damage to make
function small_mouse2.damage(self, damage)
	small_mouse2.super.damage(self, damage)
	
	-- Change value color
	if self.life > 0 then
		self.color = 0
	else
		self.color = 255
	end
end

--- Update all variables in the ship
-- @tparam ship self Ship object
-- @tparam number dt Time since the last update in seconds
function small_mouse2.update(self, dt)
	small_mouse2.super.update(self, dt)

	-- Update variables
	if self.life > 0 then
		-- Update color
		if self.color < 255 then
			self.color = math.min(255, self.color + 256 * dt)
		end

		-- Check distance
		if self.distance_v:magnitude() < small_mouse2.path_threshold and
		   self.distance_v:magnitude() > -small_mouse2.path_threshold and
		   self.velocity_v:magnitude() ~= 0.0 then
			-- Stop mouse
			self.velocity_v:free()
			self.velocity_v = vector(0, 0, 0)
		end
		
		-- Check if whe can shoot
		if self.velocity_v:magnitude() == 0.0 and
		   self.threshold:getTime() == 0 then
			-- Sound effect
			game.sfx.laser:rewind()
			game.sfx.laser:play()
				
			-- Create new bullet
			distance = vector(game.player.x-self.x, game.player.y-self.y, 0)
			velocity = distance:unit()*(1*love.game.frameRate)
			table.insert(self.bullets, bullet(self.x-14, self.y-1, velocity, 1, "blaster2"))
				
			-- Wait to shoot
			self.threshold:start(2000)
		end
	end
end

--- Move the current ship ship
-- @tparam ship self Ship object
-- @tparam number dt Time since the last update in seconds
function small_mouse2.move(self, dt)
	-- Move ship
	if self.life > 0 then
		-- Move ship
		self.x = self.x + self.velocity_v.x * small_mouse2.velocity * dt
		self.y = self.y + self.velocity_v.y * small_mouse2.velocity * dt
		
		-- Update distance
		self.distance_v.x = self.point.x-self.x
		self.distance_v.y = self.point.y-self.y
		
		-- Move collinder
		self.collider:moveTo(self.x, self.y)
	end
end

--- Free current ship
-- @tparam ship self Ship object
function small_mouse2.free(self)
	small_mouse2.super.free(self)

	-- Remove locale variables
	self.distance_v:free()
	self.distance_v = nil
	self.velocity_v:free()
	self.velocity_v = nil

	self = nil
	collectgarbage('collect')
end

-- Return ship module
return setmetatable(small_mouse2, {
		__call = function(module_table, from, point)
			return small_mouse2.new(from, point)
		end})