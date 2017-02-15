--- bullet prototype object.
-- This module construct a bullect object that have this variables
--    bullet.x      : x screen position
--    bullet.y      : y screen position
--    bullet.vx     : x velocity of bullet
--    bullet.vy     : y velocity of bullet
--    bullet.damage : current damage of bullet
--    bullet.bullet_type : Type of current bullet
--    bullet.collider : Save the collinder of bullet
--
-- @module  bullet
-- @author	Rafael Alcalde Azpiazu (NEKERAFA)
-- @license GNU General Public License v3

local object = require 'nekerafa.collections.src.object'
local collider = require 'vldr.hardoncollider'

local bullet = object.extends()

--- Create a new bullet
-- @tparam object from Object that creates the bullet
-- @tparam number x New x position
-- @tparam number y New y position
-- @tparam number vx New x velocity
-- @tparam number vy New y velocity
-- @tparam number damage Current damage of bullet
-- @tparam string type Type of bullet
-- @treturn bullet A bullet object to be used
function bullet.new(from, x, y, vx, vy, damage, type)
	local instance = object.new(bullet)
    local meta = getmetatable(instance)

    -- Set variables
	instance.from = from
	instance.x = x
    instance.y = y
    instance.vx = vx
    instance.vy = vy
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
    self.x = self.x + self.vx * dt
    self.y = self.y + self.vy * dt

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
