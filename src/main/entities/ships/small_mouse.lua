--- Enemy ship prototype object.
-- This module construct a ship object that represents a enemy.
--
-- @classmod src.main.entities.ships.small_mouse
-- @see      src.main.entities.ship
-- @author	 Rafael Alcalde Azpiazu (NEKERAFA)
-- @license  GNU General Public License v3

local anim8    = require "lib.kikito.anim8.anim8"
local class    = require "lib.vrld.hump.class"
local vector   = require "lib.vrld.hump.vector"
local entity   = require "src.main.entity"
local ship     = require "src.main.entities.ship"
local blaster  = require "src.main.entities.weapons.blaster"

-- Module
local small_mouse = class {
	--- Create new mouse ship
	-- @tparam ship self A ship to be used
	-- @tparam table path Points where ship must go
	-- @tparam vector wait_point Point in the path where ship will stop to shoot all bullets
	-- @tparam number bullets Number of bullets to shoot
	-- @treturn small_mouse New ship
	init = function(self, path, wait_point, bullets)
		-- Check path points
		if #path < 2 then
			error("Bad argument #2 in init. Path table must have 2 or more points", 2)
		end

		-- Create weapon
		local weapon = blaster(self, vector(-16, 6), vector(-8*app.frameRate, 0))

		-- Velocity vector
		local velocity = (path[2] - path[1]):normalized() * self.max_velocity 

		-- Create ship
		ship.init(self, path[1], velocity, {w = 32, h = 12}, weapon, 1, 0.5, "small_mouse")

		self.path = path
		self.wait_point = wait_point
		self.bullets = bullets
		self.next_point = 2
		self.points = 10

		-- Create animation grid
		local flame_grid = anim8.newGrid(16, 16, 16, 64)
		local explosion_grid = anim8.newGrid(32, 32, 32, 256)

		-- Create animations
		self.flame = anim8.newAnimation(flame_grid(1, '1-4'), 0.05)
		self.explosion = anim8.newAnimation(explosion_grid(1, '1-8'), 0.05, ship.end_explotion)
		self.explosion:pauseAtStart()
		self.explosion.ship = self
	end,
	
	--- Inherit ship class
	__includes = ship,
	
	--- Velocity of ship
	max_velocity = app.frameRate,
	
	--- Update all variables in enemy ship
	-- @tparam ship self Ship object
	-- @tparam number dt Time since the last update in seconds
	update = function(self, dt)
		ship.update(self, dt)
		
		-- Update move if ship have life
		if self.life > 0 then
			-- Get next position
			next_pos = self.position + self.velocity * dt

			-- Check if ship must shoot all bullets
			if math.pointequals(self.position, self.wait_point) and self.bullets > 0 then
				if self.weapon:shoot() then
					self.bullets = self.bullets - 1
					snd.effects.laser:rewind()
					snd.effects.laser:play()
				end
			-- Check if ship must move to next point where it is in shoot wait point
			elseif math.pointequals(self.position, self.wait_point) then
				self.velocity = (self.path[self.next_point] - self.position):normalized() * self.max_velocity
			-- Check if ship must move to next point
			elseif self.next_point < #self.path and math.onsegment(self.position, next_pos, self.path[self.next_point]) then
				-- Get delta time
				dt = (self.path[self.next_point].x - self.position.x) / self.velocity.x
				-- Update current position
				self.position = self.path[self.next_point]
				-- Update next position
				self.next_point = self.next_point + 1
				-- Update velocity movement
				if math.pointequals(self.position, self.wait_point) then
					self.velocity = vector(0,0)
				else
					self.velocity = (self.path[self.next_point] - self.position):normalized() * self.max_velocity
				end
			end

			-- Move ship
			entity.update(self, dt)
		end
	end,
	
	--- Free current ship
	-- @tparam ship self Ship object
	free = function(self)
		self.path = nil
		self.wait_point = nil
		self.bullets = nil
		-- Remove variables
		ship.free(self)
	end
}

return small_mouse