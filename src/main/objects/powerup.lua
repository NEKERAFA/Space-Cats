--- Powerup prototype object.
-- This module construct a powerup object.
--
-- @module  powerup
-- @author	Rafael Alcalde Azpiazu (NEKERAFA)
-- @license GNU General Public License v3

local object = require 'nekerafa.collections.src.object'
local collider = require 'vrld.HC'

local powerup = object.extends()

--- Create a new powerup
-- @tparam number x New x position
-- @tparam number y New y position
-- @tparam vector velocity New velocity
-- @tparam string type Type of powerup
-- @treturn powerup A powerup object to be used
function powerup.new(x, y, velocity, type)
	local instance = object.new(powerup)
    local meta = getmetatable(instance)

    -- Set variables
	instance.x = x
    instance.y = y
    instance.velocity = velocity
    instance.powerup_type = type
	instance.collider = collider.point(x, y)

	return setmetatable(instance, meta)
end

--- Move the current powerup
-- @tparam powerup self powerup object
-- @tparam number dt Time since the last update in seconds
function powerup.move(self, dt)
	-- Update position
    self.x = self.x + self.velocity.x * dt
    self.y = self.y + self.velocity.y * dt

	-- Update collider
	self.collider:moveTo(self.x, self.y)
end

--- Compare if a object is equals to powerup
-- @tparam powerup self powerup object
-- @tparam object obj
-- @treturn boolean true if is equals
function powerup.equals(self, obj)
	if obj == nil then
		return false
	end

	if type(obj) ~= "table" then
		return false
	end

	if obj.type == nil then
		return false
	end

	if not obj:instanceof(powerup) then
		return false
	end

    -- Check atributes
	if self.x ~= obj.x then
		return false
	end

	if self.y ~= obj.y then
		return false
	end

	if self.velocity.x ~= obj.velocity.x then
		return false
	end

	if self.velocity.y ~= obj.velocity.y then
		return false
	end

    if self.obstacle_type ~= obj.obstacle_type then
		return false
	end

	if self.damage ~= obj.damage then
		return false
	end

	return true
end

--- Free current ship
-- @tparam ship self Ship object
function powerup.free(self)
	powerup.super.free(self)

	-- Remove local variables
	self.velocity:free()
	collider.remove(self.collider)
end

--- Return a string representation the object type
-- @treturn string Class type
function powerup.type()
	return "powerup"
end

--- Create a new type object that extends from a powerup object
-- @treturn obj_type object_type New object type
function powerup.extends()
	return object.extends(powerup)
end

-- Return powerup module
return setmetatable(powerup, {
		__call = function(module_table, x, y, velocity, type)
			return powerup.new(x, y, velocity, type)
		end})
