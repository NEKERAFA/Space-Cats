--- Enemy ship prototype object.
-- This module construct a ship object that represents a enemy a bit stronger.
--
-- @classmod src.main.entities.ships.mouse
-- @see      src.main.entities.ship
-- @author	 Rafael Alcalde Azpiazu (NEKERAFA)
-- @license  GNU General Public License v3

local anim8          = require "lib.kikito.anim8.anim8"

local class          = require "lib.vrld.hump.class"
local vector         = require "lib.vrld.hump.vector"

local entity         = require "src.main.entities.entity"
local ship           = require "src.main.entities.ship"
local guided_blaster = require "src.main.entities.weapons.guided_blaster"

local mouse = class {
	--- Create new mouse ship
	-- @tparam ship self A ship to be used
	-- @tparam vector from Point where ship appears
	-- @tparam vector to Point where ship going to shoot
	-- @tparam ship pointed Ship to shoot
	-- @treturn mouse New ship
	init = function(self, from, to, pointed)
		-- Create weapon
		local weapon = guided_blaster(self, pointed, vector(-16, 6))

		-- Velocity vector
		local velocity = (to - from):normalized() * self.max_velocity 

		-- Create ship
		ship.init(self, from, velocity, {w = 32, h = 12}, weapon, 2, 1, "mouse")
		self.to = to
		self.points = 30

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
	max_velocity = 2*app.frameRate,

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
			if math.pointequals(self.position, self.to) then
				if self.weapon:shoot() then
					snd.effects.laser:rewind()
					snd.effects.laser:play()
				end
			-- Check if ship must move to next point
			elseif math.onsegment(self.position, next_pos, self.to) then
				-- Update current position
				self.position = self.to
				-- Update velocity movement
				self.velocity = vector(0,0)
			end

			-- Move ship
			entity.update(self, dt)
		end
	end,

	--- Free current ship
	-- @tparam ship self Ship object
	free = function(self)
		self.to = nil
		-- Remove variables
		ship.free(self)
	end
}

return mouse