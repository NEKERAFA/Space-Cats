--- Player prototype object.
-- This module construct a ship object that player controls
--
-- @module  player
-- @author	Rafael Alcalde Azpiazu (NEKERAFA)
-- @license GNU General Public License v3

local object = require 'nekerafa.collections.object'
local ship = require 'objects.ship'
local bullet = require 'objects.bullet'
local timer = require 'nekerafa.timer'
local collider = require 'vldr.hardoncollider'

-- Module
local player = ship.extends()

-- Global player velocity
player.velocity = 3*love.game.frameRate() -- 3 pixel in each frame (Limiting 60 fps)

--- Create a new player
-- @tparam number x New x position
-- @tparam number y New y position
-- @treturn ship A ship to be used
function player.new(x, y)
	local p_ship = player.super.new(x, y, 4, "player")

    p_ship.invulnerability = timer.new()
	p_ship.collider = collider.rectangle(x-16, y-6, 32, 12)

	-- Overiden methods
	p_ship.damage = player.damage
	p_ship.update = player.update
	p_ship.move   = player.move

	return p_ship
end

--- Set damage to current ship
-- @tparam ship self Ship object
-- @tparam number damage Damage to make
function player.damage(self, damage)
	if self.life > 0 and self.invulnerabity:getTime() == 0 then
		player.super.damage(self, damage)
		self.invulnerability:start(2000)
	end
end

--- Update all variables in the player
-- @tparam ship self Ship object
-- @tparam number dt Time since the last update in seconds
function player.update(self, dt)
	player.super.update(self, dt)

    -- Update invulnerabity
    if self.invulnerability:isFinished() then
        self.invulnerability:stop()
    end

	-- Shoot a bullet
	if love.keyboard.isDown("space") and self.threshold:getTime() == 0 then
		-- Create new bullet
		table.insert(self.bullets, bullet(self, self.x+14, self.y+1, 8*love.game.frameRate(), 0, 1, "blaster"))
		-- Wait to shoot
		self.threshold:start(250)
	end
end

--- Move the current ship ship
-- @tparam ship self Ship object
-- @tparam number dt Time since the last update in seconds
function player.move(self, dt)
	local moved = false

	-- Keys to move ship
	if love.keyboard.isDown("up") then
		self.y = self.y - player.velocity*dt
		moved = true
	elseif love.keyboard.isDown("down") then
		self.y = self.y + player.velocity*dt
		moved = true
	elseif love.keyboard.isDown("left") then
		self.x = self.x - player.velocity*dt
		moved = true
	elseif love.keyboard.isDown("right") then
		self.x = self.x + player.velocity*dt
		moved = true
	end

	if moved then
		-- Screen restrictions
		self.y = math.max(16, math.min(love.game.getHeight()-16, self.y))
		self.x = math.max(16, math.min(love.game.getWidth()-16, self.x))

		-- Update collider
		self.collider:moveTo(math.round(self.x), math.round(self.y))
	end
end

-- Return ship module
return setmetatable(player, {
		__call = function(module_table, x, y)
			return player.new(x, y)
		end})
