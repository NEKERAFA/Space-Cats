--- Asteroid prototype object.
-- This module construct a asteroid object.
--
-- @module asteroid
-- @author Rafael Alcalde Azpiazu (NEKERAFA)
-- @license GNU General Public License v3

local obstacle = require 'obstacle'
local collider = require 'vrld.HC'

--- Module
local asteroid = obstacle.extends()

--- Create a new asteroid
-- @tparam number x New x position
-- @tparam number y New y position
-- @tparam vector v New velocity
-- @treturn asteroid A asteroid to be used
function asteroid.new(x, y, v)
	local instance = asteroid.super.new(x, y, v, math.random(1, 2), "asteroid")
	return instance
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
