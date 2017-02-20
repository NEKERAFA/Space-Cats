--- bullet prototype object.
-- This module construct a bullect object.
--
-- @module  bullet
-- @author	Rafael Alcalde Azpiazu (NEKERAFA)
-- @license GNU General Public License v3

local object = require 'nekerafa.collections.src.object'
local collider = require 'vldr.hardoncollider'

local bullet = object.extends()

--- Create a new bullet
-- @tparam number x New x position
-- @tparam number y New y position
-- @tparam vector v New velocity
-- @tparam number damage Current damage of bullet
-- @tparam string type Type of bullet
-- @treturn bullet A bullet object to be used
function bullet.new(x, y, v, damage, type)
	local instance = object.new(bullet)
    local meta = getmetatable(instance)

    -- Set variables
	instance.x = x
    instance.y = y
    instance.v = v
    instance.damage = damage
    instance.bullet_type = type
	instance.collider = collider.point(x, y)

	return setmetatable(instance, meta)
end

--- Move the current bullet
-- @tparam bullet self Bullet object
-- @tparam number dt Time since the last update in seconds
function bullet.move(self, dt)
	-- Update position
    self.x = self.x + self.v.x * dt
    self.y = self.y + self.v.y * dt

	-- Update collider
	self.collider:moveTo(self.x, self.y)
end

--- Compare if a object is equals to bullet
-- @tparam bullet self Bullet object
-- @tparam object obj
-- @treturn boolean true if is equals
function bullet.equals(self, obj)
	if obj == nil then
		return false
	end

	if type(obj) ~= "table" then
		return false
	end

	if obj.type == nil then
		return false
	end

	if not obj:instanceof(bullet) then
		return false
	end

    -- Check atributes
	return self.x == obj.x and self.y == obj.y and self.vx == obj.vx and self.vy == obj.vy
            and self.type == obj.type and self.damage == obj.damage
end

--- Return a string representation the object type
-- @treturn string Class type
function bullet.type()
	return "bullet"
end

--- Create a new type object that extends from a bullet object
-- @treturn obj_type object_type New object type
function bullet.extends()
	return object.extends(bullet)
end

-- Return bullet module
return setmetatable(bullet, {
		__call = function(module_table, from, x, y, vx, vy, damage, type)
			return bullet.new(from, x, y, vx, vy, damage, type)
		end})
