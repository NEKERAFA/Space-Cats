--- Player prototype object.
-- This module construct a ship object that player controls.
--
-- @module  entities.ships.player
-- @author	Rafael Alcalde Azpiazu (NEKERAFA)
-- @license GNU General Public License v3

local collider = require "lib.vrld.HC"
local anim8    = require "lib.kikito.anim8.anim8"
local class    = require "lib.vrld.hump.class"
local vector   = require "lib.vrld.hump.vector"
local ship     = require "src.main.entities.ship"
local blaster  = require "src.main.entities.weapons.blaster"

-- Module
player = class {
	--- Create new player
	-- @tparam ship self A ship to be used
	-- @tparam number x New x position
	-- @tparam number y New y position
	-- @treturn player New playership
	init = function(self, x, y)
		-- Create animation grid
		local flame_grid = anim8.newGrid(16, 16, 16, 64)
		local explosion_grid = anim8.newGrid(32, 32, 32, 256)
		
		ship.init(self, x, y, 4, "player")
	
		-- Create weapon
		local velocity = vector(8*app.frameRate, 0)
		self.weapon = blaster(self, 14, 1, velocity)
		-- Create collider
		self.collider = collider.rectangle(x-16, y-6, 32, 12)
		
		-- Create animations
		self.flame = anim8.newAnimation(flame_grid(1, '1-4'), 0.05)
		self.explosion = anim8.newAnimation(explosion_grid(1, '1-8'), 0.05, self.end_explotion)
		self.explosion:pauseAtStart()
		self.explosion.ship = self
	end,
	
	--- Inherit ship class
	__includes = ship,
	
	--- Maximun damaged value
	damaged_max = 4,
	
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
		
		local moved = false

		-- Keys to move ship
		if love.keyboard.isDown("up") then
			self.y = self.y - player.velocity*app.frameRate*dt
			moved = true
		elseif love.keyboard.isDown("down") then
			self.y = self.y + player.velocity*app.frameRate*dt
			moved = true
		elseif love.keyboard.isDown("left") then
			self.x = self.x - player.velocity*app.frameRate*dt
			moved = true
		elseif love.keyboard.isDown("right") then
			self.x = self.x + player.velocity*app.frameRate*dt
			moved = true
		end

		if moved then
			-- Screen restrictions
			self.y = math.max(16, math.min(app.height-16, self.y))
			self.x = math.max(16, math.min(app.width-16, self.x))

			-- Update collider
			self.collider:moveTo(math.round(self.x), math.round(self.y))
		end
	end
}

-- Return player module
return player
