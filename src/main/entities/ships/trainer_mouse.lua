--- Enemy ship prototype object.
-- This module construct a ship object that represents a enemy.
--
-- @module  trainer_mouse
-- @author	Rafael Alcalde Azpiazu (NEKERAFA)
-- @license GNU General Public License v3

local ship = require 'ship'
local bullet = require 'bullet'
local anim8 = require 'kikito.anim8.anim8'
local collider = require 'vrld.HC'

-- Module
local trainer_mouse = ship.extends()

--- Threshold to change path point
trainer_mouse.path_threshold = 1

--- Velocity
trainer_mouse.velocity = 2

--- Create a new enemy
-- @tparam number x New x position
-- @tparam number y New y position
-- @treturn ship A ship to be used
function trainer_mouse.new(x, y)
	local mouse_ship = trainer_mouse.super.new(x, y, 1, "trainer_mouse")
	local meta = getmetatable(mouse_ship)

	-- Mouse collider
	mouse_ship.collider = collider.rectangle(x-10, y-12, 19, 24)
	-- Animation
    local flame_grid = anim8.newGrid(8, 8, 8, 32)
    mouse_ship.flame = anim8.newAnimation(flame_grid(1, '1-4'), 0.05)

	-- Controls float movement
	mouse_ship.movement = 1
	mouse_ship.delta_movement = 0

	-- Overiden methods
	mouse_ship.move = trainer_mouse.move
	mouse_ship.update = trainer_mouse.update

	-- Overiden metamethods
	meta["__gc"] = trainer_mouse.free

	return setmetatable(mouse_ship, meta)
end

--- Update all variables in the ship
-- @tparam ship self Ship object
-- @tparam number dt Time since the last update in seconds
function trainer_mouse.update(self, dt)
	trainer_mouse.super.update(self, dt)

	-- Update float movement
	self.delta_movement = self.delta_movement + self.movement * dt

	if self.delta_movement > 0.1 then
		self.delta_movement = 0.1
		self.movement = -1
	end

	if self.delta_movement < -0.1 then
		self.delta_movement = -0.1
		self.movement = 1
	end
end

--- Move the current ship ship
-- @tparam ship self Ship object
-- @tparam number vx Move in x axis
-- @tparam number vy Move in y axis
-- @tparam boolean float Aplies float movement to y axis
-- @tparam number dt Time since the last update in seconds
function trainer_mouse.move(self, vx, vy, float, dt)
	-- Move ship
	if self.life ~= 0 then
		-- Move ship
		self.x = self.x + vx * dt
		self.y = self.y + vy * dt

		self.y = self.y + self.delta_movement

		-- Move collinder
		self.collider:moveTo(self.x, self.y)
	end
end

-- Return ship module
return setmetatable(trainer_mouse, {
		__call = function(module_table, x, y)
			return trainer_mouse.new(x, y)
		end})
