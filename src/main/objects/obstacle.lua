--- obstacle prototype object.
-- This module construct a obstacle object.
--
-- @module  obstacle
-- @author	Rafael Alcalde Azpiazu (NEKERAFA)
-- @license GNU General Public License v3

local object = require 'nekerafa.collections.src.object'
local anim8 = require 'kikito.anim8.anim8'
local collider = require 'vrld.HC'
local timer = require 'nekerafa.timer'

local obstacle = object.extends()

--- Update status after explosion Animation
local function end_explotion(animation, loops)
	animation:pause()
	animation.obstacle.destroyed = true
end

--- Create a new obstacle
-- @tparam number x New x position
-- @tparam number y New y position
-- @tparam vector velocity New velocity
-- @tparam number strength Level of damage resistance
-- @tparam string type Type of obstacle
-- @treturn obstacle A obstacle to be used
function obstacle.new(x, y, velocity, strength, type)
	local instance = object.new(obstacle)
    local meta = getmetatable(instance)
	local explosion_grid = anim8.newGrid(32, 32, 32, 256)

    -- Set variables of obstacle
	instance.x = x
    instance.y = y
    instance.velocity = velocity
	instance.strength = strength
	instance.destroyed = false
    instance.obstacle_type = type
	instance.collider = collider.rectangle(x-16, y-16, 32, 32)
	instance.explosion = anim8.newAnimation(explosion_grid(1, '1-8'), 0.1, end_explotion)
	instance.explosion:pauseAtStart()
	instance.explosion.obstacle = instance

    meta["__gc"] = obstacle.free

	return setmetatable(instance, meta)
end

--- Set damage to current obstacle
-- @tparam obstacle self obstacle object
-- @tparam number damage Damage to make
function obstacle.damage(self, damage)
	if self.strength > 0 then
        self.strength = math.max(self.strength - damage, 0)
    end

	if self.strength == 0 then
		self.explosion:resume()
	end
end

--- Update all variables in the obstacle
-- @tparam obstacle self obstacle object
-- @tparam number dt Time since the last update in seconds
function obstacle.update(self, dt)
	-- Update explosion
	self.explosion:update(dt)
end

--- Move the current obstacle obstacle
-- @tparam obstacle self obstacle object
-- @tparam number dt Time since the last update in seconds
function obstacle.move(self, dt)
	if self.strength ~= 0 then
		self.x = self.x + self.velocity.x * dt
		self.y = self.y + self.velocity.y * dt

		self.collider:moveTo(math.round(self.x), math.round(self.y))
	end
end

--- Compare if a object is equals to obstacle
-- @tparam obstacle self obstacle object
-- @tparam object obj
-- @treturn boolean true if is equals
function obstacle.equals(self, obj)
	if obj == nil then
		return false
	end

	if type(obj) ~= "table" then
		return false
	end

	if obj.type == nil then
		return false
	end

	if not obj:instanceof(obstacle) then
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

	if self.strength ~= obj.strength then
		return false
	end

	if self.destroyed ~= obj.destroyed then
		return false
	end

	if self.obstacle_type ~= obj.obstacle_type then
        return false
    end

	return true
end

--- Return a string representation the object type
-- @treturn string Class type
function obstacle.type()
	return "obstacle"
end

--- Create a new type object that extends from a obstacle object
-- @treturn obj_type object_type New object type
function obstacle.extends()
	return object.extends(obstacle)
end

--- Free current obstacle
-- @tparam obstacle self obstacle object
function obstacle.free(self)
	obstacle.super.free(self)

	-- Remove locale variables
	self.explosion = nil
	self = nil
	collectgarbage('collect')
end

-- Return obstacle module
return setmetatable(obstacle, {
		__call = function(module_table, x, y, v, strength, type)
			return obstacle.new(x, y, v, strength, type)
		end})
