--- Player prototype object.
-- This module construct a ship object that player controls.
--
-- @classmod entities.ships.player
-- @see      entities.ship
-- @author	 Rafael Alcalde Azpiazu (NEKERAFA)
-- @license  GNU General Public License v3

local anim8   = require "lib.kikito.anim8.anim8"
local class   = require "lib.vrld.hump.class"
local vector  = require "lib.vrld.hump.vector"
local ship    = require "src.main.entities.ship"
local entity  = require "src.main.entity"
local blaster = require "src.main.entities.weapons.blaster"

-- Module
local player = class {
	--- Create new player
	-- @tparam ship self A ship to be used
	-- @tparam vector position Start position
	init = function(self, position)
		-- Create animation grid
		local flame_grid = anim8.newGrid(16, 16, 16, 64)
		local explosion_grid = anim8.newGrid(32, 32, 32, 256)

		-- Create weapon
		local delta    = vector(14, 1)
		local velocity = vector(8*app.frameRate, 0)
		local weapon = blaster(self, delta, velocity)
		
		ship.init(self, position, vector(0,0), {w = 32, h = 12}, weapon, 4, 4, "player")
		
		-- Create animations
		self.flame = anim8.newAnimation(flame_grid(1, '1-4'), 0.05)
		self.explosion = anim8.newAnimation(explosion_grid(1, '1-8'), 0.05, ship.end_explotion)
		self.explosion:pauseAtStart()
		self.explosion.ship = self
	end,
	
	--- Inherit ship class
	__includes = ship,
	
	--- Velocity vector
	max_velocity = 3*app.frameRate,
	
	--- Update all variables in the player
	-- @tparam ship self Ship object
	-- @tparam number dt Time since the last update in seconds
	update = function(self, dt)
		ship.update(self, dt)
		
		-- Shoot a bullet
		if love.keyboard.isDown("space") then
			-- If we shoot a bullet, sound a effect
			if self.weapon:shoot() then
				snd.effects.laser:rewind()
				snd.effects.laser:play()
			end
		end

		-- Keys to move ship
		local delta = vector(0,0)
		if love.keyboard.isDown("up")    then delta.y = -1 end
		if love.keyboard.isDown("down")  then delta.y =  1 end
		if love.keyboard.isDown("left")  then delta.x = -1 end
		if love.keyboard.isDown("right") then delta.x =  1 end

		-- Move ship
		self.velocity = delta * self.max_velocity
		entity.update(self, dt)

		-- Screen restrictions
		self.position.y = math.max(16, math.min(app.height-16, self.position.y))
		self.position.x = math.max(16, math.min(app.width-16, self.position.x))
	end
}

-- Return player module
return player
