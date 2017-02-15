--- Asteroid prototype object.
-- This module construct a asteroid object that have this variables
--    asteroid.x    : x screen position
--    asteroid.y    : y screen position
--    asteroid.vx     : x velocity of asteroid
--    asteroid.vy     : y velocity of asteroid
--    asteroid.strength : Level of damage resistance
--    asteroid.asteroid_type : Type of current asteroid (randomized)
--    asteroid.explosion : Animation of explosion
--    asteroid.damage : Return if asteroid is damaged
--    asteroid.collider : Save the collinder of asteroid
--
-- @module asteroid
-- @author Rafael Alcalde Azpiazu (NEKERAFA)
-- @license GNU General Public License v3

local object = require 'nekerafa.collections.src.object'
local anim8 = require 'kikito.anim8.anim8'
local collider = require 'vldr.hardoncollider'
local timer = require 'nekerafa.timer'

--- Module
local asteroid = object.extends()

--- Create a new asteroid
-- @tparam number x New x position
-- @tparam number y New y position
-- @tparam number vx New x velocity
-- @tparam number vy New y velocity
-- @tparam number strength Level of damage resistance
-- @treturn asteroid A asteroid to be used
function asteroid.new(x, y, vx, vy, strength)
	local instance = object.new(asteroid)
	local explosion_grid = anim8.newGrid(32, 32, 32, 256)

    -- Set variables of asteroid
	instance.x = x
    instance.y = y
    instance.vx = vx
    instance.vy = vy
    instance.strength = strength
    instance.asteroid_type = "normal" -- In this moment I have 1 type of asteroid
    instance.damaged = false
	instance.explosion = anim8.newAnimation(explosion_grid(1, '1-8'), 0.01)
	instance.explosion:pauseAtEnd()
	instance.collider = collider.rectangle(x-16, y-15, 32, 30)

	return instance
end

--- Set damage to current asteroid
-- @tparam asteroid self asteroid object
-- @tparam number damage Damage to make
function asteroid.damage(self, damage)
	if self.strength > 0 then
        self.strength = math.max(self.strength - damage, 0)
        self.damaged = true
    end
end

--- Get if asteroid is destroyed
-- @tparam asteroid self asteroid object
-- @treturn boolean true if current asteroid is destroyed.
function asteroid.destroyed(self)
	return self.life == 0
end

--- Move the current asteroid asteroid
-- @tparam asteroid self asteroid object
-- @tparam number dt Time since the last update in seconds
function asteroid.move(self, dt)
	-- Update position
    self.x = self.x + self.vx*dt
    self.y = self.y + self.vy*dt

	-- Update collider
	self.collider:moveTo(math.round(self.x), math.round(self.y))
end

--- Compare if a object is equals to asteroid
-- @tparam asteroid self asteroid object
-- @tparam object obj
-- @treturn boolean true if is equals
function asteroid.equals(self, obj)
	if obj == nil then
		return false
	end

	if type(obj) ~= "table" then
		return false
	end

	if obj.type == nil then
		return false
	end

	if not obj:instanceof(asteroid) then
		return false
	end

    -- Check atributes
	if self.x ~= obj.x then
        return false
    end

    if self.y ~= obj.y then
        return false
    end

    if self.vx ~= obj.vx then
        return false
    end

    if self.vy ~= obj.vy then
        return false
    end

    if self.strength ~= obj.strength then
        return false
    end

    if self.asteroid_type ~= obj.asteroid_type then
        return false
    end

    return true
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
		__call = function(module_table, x, y, vx, vy, strength)
			return asteroid.new(x, y, vx, vy, strength)
		end})
