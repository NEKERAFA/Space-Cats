--- Asteroid prototype object.
-- This module construct a asteroid object that have this variables
--    asteroid.x    : x screen position
--    asteroid.y    : y screen position
--    asteroid.vx     : x velocity of asteroid
--    asteroid.vy     : y velocity of asteroid
--    asteroid.strength : Level of damage resistance (randomized)
--    asteroid.obstacle_type : Type of current asteroid
--    asteroid.explosion : Animation of explosion
--    asteroid.damage : Return if asteroid is damaged
--    asteroid.collider : Save the collinder of asteroid
--
-- @module asteroid
-- @author Rafael Alcalde Azpiazu (NEKERAFA)
-- @license GNU General Public License v3

local obstacle = require 'obstacle'
local collider = require 'vldr.hardoncollider'

--- Module
local asteroid = obstacle.extends()

--- Create a new asteroid
-- @tparam number x New x position
-- @tparam number y New y position
-- @tparam vector v New velocity
-- @treturn asteroid A asteroid to be used
function asteroid.new(x, y, v)
	local instance = asteroid.super.new(x, y, v, math.math.random(1, 3), "asteroid")
	return instance
end

--- Move the current asteroid asteroid
-- @tparam asteroid self asteroid object
-- @tparam number dt Time since the last update in seconds
function asteroid.move(self, dt)
	asteroid.super.move(self)
	-- Update collider
	self.collider:moveTo(math.round(self.x), math.round(self.y))
end

--- Return a string representation the object type
-- @treturn string Class type
function asteroid.type()
	return "asteroid"
end

--- Create a new type object that extends from a asteroid object
-- @treturn obj_type object_type New object type
function asteroid.extends()
	return object.extends(asteroid)
end

-- Return asteroid module
return setmetatable(asteroid, {
		__call = function(module_table, x, y, v)
			return asteroid.new(x, y, v)
		end})
