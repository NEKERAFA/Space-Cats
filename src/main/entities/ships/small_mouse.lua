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
local small_mouse = ship.extends()

--- Threshold to change path point
small_mouse.path_threshold = 1

--- Velocity
small_mouse.velocity = 2

--- Update velocity vector
-- @tparam ship self Ship object
function small_mouse.update_velocity(self)
	-- Next point
	self.next = self.next+1
	-- New unitary vector
	self.distance_v.x = self.path[self.next].x-self.x
	self.distance_v.y = self.path[self.next].y-self.y
	-- Update velocity
	self.velocity_v:free()
	self.velocity_v = self.distance_v:unit()*love.game.frameRate
end

--- Create a new enemy
-- @tparam table path Path to follow
-- @tparam table p_shoot Point where ship will shoot (Must be in the path)
-- @tparam number bullets Number of bullets to shoot
-- @treturn ship A ship to be used
function small_mouse.new(path, p_shoot, bullets)
	local mouse_ship = small_mouse.super.new(path[1].x, path[1].y, 1, "small_mouse")
	local meta = getmetatable(mouse_ship)

	-- Variables
    mouse_ship.path = path -- Path to follow
    mouse_ship.p_shoot = p_shoot -- Point where ship must shoot
    mouse_ship.n_bullets = bullets -- Number of bullets
	mouse_ship.next = 1 -- Next point to go
	mouse_ship.flame = mouse_ship.flame:flipH() -- Flips flame
	-- distance vector
	mouse_ship.distance_v = vector(path[2].x-path[1].x, path[2].y-path[1].y, 0)
	-- velocity vector
	mouse_ship.velocity_v = mouse_ship.distance_v:unit()

	-- Update current velocity
	small_mouse.update_velocity(mouse_ship)

	-- Mouse collider
	mouse_ship.collider = collider.rectangle(path[1].x-16, path[1].y-6, 32, 12)

	-- Points
	mouse_ship.points = 10

    -- Overiden methods
	mouse_ship.update = small_mouse.update
	mouse_ship.move   = small_mouse.move

	-- Overiden metamethods
	meta["__gc"] = small_mouse.free

	return setmetatable(mouse_ship, meta)
end

--- Update all variables in the ship
-- @tparam ship self Ship object
-- @tparam number dt Time since the last update in seconds
function small_mouse.update(self, dt)
	small_mouse.super.update(self, dt)

	-- Check next point
	if self.life > 0 then
		if self.distance_v:magnitude() < small_mouse.path_threshold and
		   self.distance_v:magnitude() > -small_mouse.path_threshold then
			
			-- Check if is in point to shoot
			if (self.path[self.next] == self.p_shoot) and (self.n_bullets > 0) and (self.threshold:getTime() == 0) then
				-- Stop mouse
				self.velocity_v:free()
				self.velocity_v = vector(0, 0, 0)
				
				-- Sound effect
				game.sfx.laser:rewind()
				game.sfx.laser:play()
				
				-- Create new bullet
				--distance = vector(game.player.x-self.x, game.player.y-self.y, 0)
				--velocity = distance:unit()*(8*love.game.frameRate)
				velocity = vector(-4*love.game.frameRate, 0, 0)
				table.insert(self.bullets, bullet(self.x-14, self.y-1, velocity, 1, "blaster"))
				
				-- Wait to shoot
				self.threshold:start(300)
				self.n_bullets = self.n_bullets-1
			-- Next position in array
			elseif ((self.path[self.next] == self.p_shoot) and (self.n_bullets == 0)) or self.next < #self.path then
				small_mouse.update_velocity(self)
			end
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
		self.x = self.x + self.velocity_v.x * small_mouse.velocity * dt
		self.y = self.y + self.velocity_v.y * small_mouse.velocity * dt
		
		-- Update distance
		self.distance_v.x = self.path[self.next].x-self.x
		self.distance_v.y = self.path[self.next].y-self.y
		
		-- Move collinder
		self.collider:moveTo(self.x, self.y)
	end
end

--- Free current ship
-- @tparam ship self Ship object
function small_mouse.free(self)
	small_mouse.super.free(self)

	-- Remove locale variables
	self.distance_v:free()
	self.distance_v = nil
	self.velocity_v:free()
	self.velocity_v = nil

	self = nil
	collectgarbage('collect')
end

-- Return ship module
return setmetatable(small_mouse, {
		__call = function(module_table, path, p_shoot, bullets)
			return small_mouse.new(path, p_shoot, bullets)
		end})