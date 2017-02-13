--- Vector Module.
-- A Euclidean vector is a geometric object that represents the "carrier" from point A to point B..
--
-- @module	math.vector
-- @author	Rafael Alcalde Azpiazu (NEKERAFA) on mon 28 nov 2016, 23:03
-- @license	Creative Commons Attribution-ShareAlike 4.0
-- @see object

local object = require('nekerafa.collections.object')
local vector = object.extends()

--- Get the magnitude of vector
-- @tparam vector self Reference to vector object
-- @treturn number Module of vector
function vector.magnitude(self)
	return math.sqrt(self.x*self.x + self.y*self.y + self.z*self.z)
end

--- Get vector angles
-- @tparam vector self Reference to vector object
-- @treturn number Azimuth of vector in radians
-- @treturn number Zenith of vector in radians
function vector.angle(self)
	return math.atan2(self.y, self.x), math.atan2(self.y, self.z)
end

--- Get the normalized vector
-- @tparam vector self Reference to vector object
-- @treturn vector Unitary vector
function vector.unit(self)
	unit = vector(self.x, self.y, self.z)
	length = math.sqrt(self.x*self.x + self.y*self.y + self.z*self.z)
	unit.x = unit.x/length
	unit.y = unit.y/length
	unit.z = unit.z/length

	return unit
end

--- Add two vectors
-- @tparam vector self Reference to vector object
-- @tparam vector other Reference to other vector to add
-- @treturn vector Added vector
function vector.add(self, other)
	return vector.new(self.x+other.x, self.y+other.y, self.z+other.z)
end

--- Substract two vectors
-- @tparam vector self Reference to vector object
-- @tparam vector other Reference to other vector to substract
-- @treturn vector Substracted vector
function vector.subtract(self, other)
	return vector.new(self.x-other.x, self.y-other.y, self.z-other.z)
end

--- Divide a vector by a scalar
-- @tparam vector self Reference to vector object
-- @tparam number c Scalar to divide
-- @treturn vector Divided vector
function vector.divide(self, c)
	return vector.new(self.x/c, self.y/c, self.z/c)
end

--- Multiply two vectors or a vector by a scalar
-- @tparam vector self Reference to vector object
-- @param other Scalar to multiply or other vector
-- @treturn vector Multiplied vector
function vector.multiply(self, other)
	if type(other) == "number" then
		return vector.new(self.x*other, self.y*other, self.z*other)
	else
		return vector.new(self.y*other.z-self.z*other.y, self.z*other.x-self.x*other.z, self.x*other.y-self.y*other.x)
	end
end

--- Get the scalar product of tho vectors
-- @tparam vector self Reference to vector object
-- @tparam vector other Vector to multiply or other vector
-- @treturn number Scalar product
function vector.dotproduct(self, other)
	return self.x*other.x+self.y*other.y+self.z*other.z
end

--- Create a new type object that extends from a vector
-- @treturn obj_type object_type New object type
function vector.extends()
	return vector.super.extends(vector)
end

--- Return a string representation the object type
-- @treturn string Class type
function vector.type()
	return "vector"
end

--- Compare if a object is equals to vector
-- @tparam vector self Reference to a vector object
-- @tparam object obj
-- @treturn boolean true if is equals
function vector.equals(self, obj)
	if obj == nil then
		return false
	end

	if type(obj) ~= "table" then
		return false
	end

	if obj.type == nil then
		return false
	end

	if not obj:instanceof(vector) then
		return false
	end

	return self.x == obj.x and self.y == obj.y and self.z == obj.z
end

--- Create a new vector
-- @tparam number x Coordenate of x axis
-- @tparam number y Coordenate of y axis
-- @tparam number z Coordenate of z axis
-- @treturn set New object vector
function vector.new(x, y, z)
	local instance = object.new(vector)
	local meta = getmetatable(instance)

	if type(x) ~= "number" then
		error("Bad argument #1 in new. Expected number, got "..type(x), 2)
	elseif type(y) ~= "number" then
		error("Bad argument #2 in new. Expected number, got "..type(y), 2)
	elseif type(z) ~= "number" then
		error("Bad argument #3 in new. Expected number, got "..type(z), 2)
	end

	instance.x = x
	instance.y = y
	instance.z = z

	-- Metamethod for size
	meta["__len"] = instance.magnitude
	-- Aritmethic metamethods
	meta["__add"] = instance.add
	meta["__sub"] = instance.subtract
	meta["__mul"] = instance.multiply
	meta["__div"] = instance.divide
	-- Metamethod for print
	oldstring = meta["__tostring"]
	meta["__tostring"] = function(self)
		return oldstring() .. " ("..self.x..", "..self.y..", "..self.z..")"
	end

	return setmetatable(instance, meta)
end

return setmetatable(vector, {
		__call = function(mod, ...)
			return vector.new(...)
		end,
		__tostring = vector
	})
