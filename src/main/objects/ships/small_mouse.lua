--- Enemy ship prototype object.
-- This module construct a ship object that represents a enemy.
--
-- @module  small_mouse
-- @author	Rafael Alcalde Azpiazu (NEKERAFA)
-- @license GNU General Public License v3

local ship = require 'ship'
local bullet = require 'bullet'
local vector = require "nekerafa.collections.src.math.vector"
local collider = require 'vldr.hardoncollider'

-- Module
local small_mouse = ship.extends()

--- Threshold to change path point
small_mouse.path_threshold = 1

--- Velocity
small_mouse.velocity = 2

--- Create a new enemy
-- @tparam table path Path to follow
-- @tparam table p_shoot Point where ship will shoot (Must be in the path)
-- @tparam number bullets Number of bullets to shoot
-- @treturn ship A ship to be used
function small_mouse.new(path, p_shoot, bullets)
	local mouse_ship = small_mouse.super.new(path[1].x, path[1].y, 1, "small_mouse")

	-- Variables
    mouse_ship.path = path
    mouse_ship.p_shoot = p_shoot
    mouse_ship.n_bullets = bullets
	mouse_ship.next = 1
	mouse_ship.flame = mouse_ship.flame:flipH()
	mouse_ship.distance = vector(path[2].x-path[1].x, path[2].y-path[1].y, 0)
	mouse_ship.velocity = mouse_ship.distance:unit()

	small_mouse.update_velocity(mouse_ship)

	mouse_ship.collider = collider.rectangle(path[1].x-16, path[1].y-6, 32, 12)

    -- Overiden methods
	mouse_ship.update = small_mouse.update
	mouse_ship.move   = small_mouse.move
	mouse_ship.hitbox = small_mouse.hitbox

	return mouse_ship
end

--- Update all variables in the ship
-- @tparam ship self Ship object
-- @tparam number dt Time since the last update in seconds
function small_mouse.update(self, dt)
	small_mouse.super.update(self, dt)

	-- Check next point
	if self.distance:magnitude() < small_mouse.path_threshold and
	   self.distance:magnitude() > -small_mouse.path_threshold then
		-- Next position in array
		if self.next < #self.path then
			small_mouse.update_velocity(self)
		end
	end
end

--- Move the current ship ship
-- @tparam ship self Ship object
-- @tparam number dt Time since the last update in seconds
function small_mouse.move(self, dt)
	-- Move ship
	if self.life ~= 0 then
		-- Move ship
		self.x = self.x + self.velocity.x * small_mouse.velocity * dt
		self.y = self.y + self.velocity.y * small_mouse.velocity * dt
		-- Update distance
		self.distance.x = self.path[self.next].x-self.x
		self.distance.y = self.path[self.next].y-self.y
		-- Move collinder
		self.collider:moveTo(self.x, self.y)
	end
end

--- Update velocity vector
-- @tparam ship self Ship object
function small_mouse.update_velocity(self)
	-- Next point
	self.next = self.next+1
	-- New unitary vector
	self.distance.x = self.path[self.next].x-self.x
	self.distance.y = self.path[self.next].y-self.y
	-- Update velocity
	self.velocity:free()
	self.velocity = self.distance:unit()*love.game.frameRate()
end

-- Return ship module
return setmetatable(small_mouse, {
		__call = function(module_table, path, p_shoot, bullets)
			return small_mouse.new(path, p_shoot, bullets)
		end})
