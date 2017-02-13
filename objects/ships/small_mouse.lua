--- Enemy ship prototype object.
-- This module construct a ship object that represents a enemy.
--
-- @Module  small_mouse
-- @author	Rafael Alcalde Azpiazu (NEKERAFA)
-- @license GNU General Public License v3
-- @see object

local object = require 'nekerafa.collections.object'
local ship = require 'objects.ship'
local bullet = require 'objects.bullet'
local vector = require "nekerafa.collections.math.vector"
local collider = require 'vldr.hardoncollider'

-- Module
local small_mouse = ship.extends()

--- Threshold to change path point
small_mouse.threshold = 1

--- Velocity
small_mouse.velocity = 2

--- Update velocity vector
local function update_velocity(self)
	-- Next point
	self.next = self.next+1
	-- New unitary vector
	u = vector(self.path[self.next].x-self.x, self.path[self.next].y-self.y, 0):unit()
	-- Update velocity
	self.vx = u.x * love.game.frameRate()
	self.vy = u.y * love.game.frameRate()
end

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

	update_velocity(mouse_ship)

	mouse_ship.collider = collider.rectangle(mouse_ship.x-16, mouse_ship.y-6, 32, 12)

    -- Overiden methods
	mouse_ship.update = small_mouse.update
	mouse_ship.move   = small_mouse.move
	mouse_ship.hitbox = small_mouse.hitbox

	return mouse_ship
end

--- Update all variables in the ship
-- @tparam self ship Ship object
-- @tparam number dt Time since the last update in seconds
function small_mouse.update(self, dt)
	small_mouse.super.update(self, dt)

	-- Distance vector
	local d = vector(self.path[self.next].x-self.x, self.path[self.next].y-self.y, 0)

	-- Check next point
	if d:magnitude() < small_mouse.threshold and d:magnitude() > -small_mouse.threshold then
		if self.next < #self.path then
			update_velocity(self)
		end
	end
end

--- Move the current ship ship
-- @tparam self ship Ship object
function small_mouse.move(self, dt)
	-- Move ship
	if self.life ~= 0 then
		self.x = self.x + self.vx * small_mouse.velocity * dt
		self.y = self.y + self.vy * small_mouse.velocity * dt
		-- Move collinder
		self.collider:moveTo(self.x, self.y)
	end
end

-- Return ship module
return setmetatable(small_mouse, {
		__call = function(module_table, path, p_shoot, bullets)
			return small_mouse.new(path, p_shoot, bullets)
		end})
