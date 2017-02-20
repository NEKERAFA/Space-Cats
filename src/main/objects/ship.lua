--- Ship prototype object.
-- This module construct a ship object. See diagram for know atributes.
--
-- @module  ship
-- @author	Rafael Alcalde Azpiazu (NEKERAFA)
-- @license GNU General Public License v3

local object = require 'nekerafa.collections.src.object'
local anim8 = require 'kikito.anim8.anim8'
local collider = require 'vldr.hardoncollider'
local timer = require 'nekerafa.timer'

local ship = object.extends()

--- Update status after explosion Animation
local function end_explotion(animation, loops)
	animation:pause()
	animation.ship.destroyed = true
end

--- Create a new ship
-- @tparam number x New x position
-- @tparam number y New y position
-- @tparam number life Current life
-- @tparam string type Type of ship
-- @treturn ship A ship to be used
function ship.new(x, y, life, type)
	local instance = object.new(ship)
    local meta = getmetatable(instance)
	local flame_grid = anim8.newGrid(16, 16, 16, 64)
	local explosion_grid = anim8.newGrid(32, 32, 32, 256)

    -- Set variables of ship
	instance.x = x
    instance.y = y
    instance.life = life
	instance.destroyed = false
    instance.ship_type = type
    instance.bullets = {}
    instance.threshold = timer.new()
	instance.flame = anim8.newAnimation(flame_grid(1, '1-4'), 0.05)
	instance.explosion = anim8.newAnimation(explosion_grid(1, '1-8'), 0.1, end_explotion)
	instance.explosion:pauseAtStart()
	instance.explosion.ship = instance

    meta["__gc"] = ship.free

	return setmetatable(instance, meta)
end

--- Set damage to current ship
-- @tparam ship self Ship object
-- @tparam number damage Damage to make
function ship.damage(self, damage)
	if self.life > 0 then
        self.life = math.max(self.life - damage, 0)
		self.damaged = true
    end

	if self.life == 0 then
		self.explosion:resume()
	end
end

--- Update all variables in the ship
-- @tparam ship self Ship object
-- @tparam number dt Time since the last update in seconds
function ship.update(self, dt)
	-- Update flame animation
	self.flame:update(dt)

	-- Update explosion
	self.explosion:update(dt)

	-- Update bullets
	for i, bullet in ipairs(self.bullets) do
		-- Move bullet
		bullet:move(dt)

		-- Check if bullet needs to remove it
		if (bullet.x < 0) or (bullet.x > love.game.getWidth())
				or (bullet.y < 0) or (bullet.y > love.game.getHeight()) then
		   	-- Remove bullet from collider space
		   	collider.remove(bullet.collider)
		   	-- Remove from bullet table
		   	bullet:free()
			table.remove(self.bullets, i)
			break
		end
	end

	-- Update bullet threshold
	if self.threshold:isFinished() then
		self.threshold:stop()
	end
end

--- Move the current ship ship
-- @tparam ship self Ship object
-- @tparam number dt Time since the last update in seconds
function ship.move(self, dt)
end

--- Compare if a object is equals to ship
-- @tparam ship self Ship object
-- @tparam object obj
-- @treturn boolean true if is equals
function ship.equals(self, obj)
	if obj == nil then
		return false
	end

	if type(obj) ~= "table" then
		return false
	end

	if obj.type == nil then
		return false
	end

	if not obj:instanceof(ship) then
		return false
	end

    -- Check atributes
	if self.x ~= obj.x or self.y ~= obj.y or self.life ~= obj.life or self.type ~= obj.type then
        return false
    else
        -- Check bullets
        for i, value in ipairs(self.bullets) do
            if obj.bullets[i] ~= value then
                return false
            end
        end
    end

	return true
end

--- Return a string representation the object type
-- @treturn string Class type
function ship.type()
	return "ship"
end

--- Create a new type object that extends from a ship object
-- @treturn obj_type object_type New object type
function ship.extends()
	return object.extends(ship)
end

--- Free current ship
-- @tparam ship self Ship object
function ship.free(self)
	ship.super.free(self)

	self.bullets = nil
	self.flame = nil
	self.explosion = nil
	self.threshold = nil
	self = nil
	collectgarbage('collect')
end

-- Return ship module
return setmetatable(ship, {
		__call = function(module_table, x, y, life, type)
			return ship.new(x, y, life, type)
		end})
