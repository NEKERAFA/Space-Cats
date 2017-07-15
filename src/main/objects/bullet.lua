--- bullet prototype object.
-- This module construct a bullect object.
--
-- @module  bullet
-- @author	Rafael Alcalde Azpiazu (NEKERAFA)
-- @license GNU General Public License v3

local object = require 'nekerafa.collections.src.object'
local collider = require 'vrld.HC'

local bullet = object.extends()

--- Create a new bullet
-- @tparam number x New x position
-- @tparam number y New y position
-- @tparam vector velocity New velocity
-- @tparam number damage Current damage of bullet
-- @tparam string type Type of bullet
-- @treturn bullet A bullet object to be used
function bullet.new(x, y, velocity, damage, type)
	local instance = object.new(bullet)
    local meta = getmetatable(instance)

    -- Set variables
	instance.x = x
    instance.y = y
    instance.velocity = velocity
    instance.damage = damage
    instance.bullet_type = type
	
	if type == "baster" then
		instance.collider = collider.circle(x, y, 2)
	elseif type == "baster2" then
		instance.collider = collider.circle(x, y, 4)
	else
		instance.collider = collider.point(x, y)
	end

	return setmetatable(instance, meta)
end

--- Move the current bullet
-- @tparam bullet self Bullet object
-- @tparam number dt Time since the last update in seconds
function bullet.move(self, dt)
	-- Update position
    self.x = self.x + self.velocity.x * dt
    self.y = self.y + self.velocity.y * dt

	-- Update collider
	self.collider:moveTo(self.x, self.y)
end

--- Free current bullet
-- @tparam bullet self Bullet object
function bullet.free(self)
	bullet.super.free(self)

	-- Remove local variables
	self.velocity:free()
	collider.remove(self.collider)
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
		__call = function(module_table, x, y, velocity, damage, type)
			return bullet.new(x, y, velocity, damage, type)
		end})
