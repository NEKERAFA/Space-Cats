--- Byte module.
-- The byte is a unsigned 8-bit number, permitting values between 0 to 255.
-- This module also provides methods for converting bytes in string and vice versa.
--
-- @module	list
-- @author	Rafael Alcalde Azpiazu (NEKERAFA) on fri jan 2017 14:46 (CET)
-- @license	Creative Commons Attribution-ShareAlike 4.0
-- @see object

local object = require('object')
local byte = object.extends()

-- #### Module ####

--- Constant that have the maximun value of a byte, (2^8)-1.
byte.MAX_VALUE = (2^8)-1

--- Constant that have the minimun value of a byte, 0.
byte.MIN_VALUE = 0

--- Get current value
-- @tparam byte self Reference to a byte object
function byte.get(self)
    return self.value
end

--- Set a value
-- @tparam byte self Reference to a byte object
-- @tparam number value Number to set
function byte.set(self, value)
    if value > byte.MAX_VALUE or value < byte.MIN_VALUE then
        error("bad argument #1 to 'set' (value out of range)", 2)
    end

    self.value = math.floor(value)
end

--- Convert a string in a byte
-- @tparam string str String to convert
-- @treturn byte Byte object
function byte.valueOf(str)
    local value = tonumber(str)

    if value == nil then
        error("bad argument #1 to 'value' (not parseable string)", 2)
    end

    if value > byte.MAX_VALUE or value < byte.MIN_VALUE then
        error("bad argument #1 to 'value' (value out of range)", 2)
    end

    return byte(value)
end

--- Convert a character in a byte
-- @tparam string char Character to convert
-- @treturn byte Byte object
function byte.value(char)
    return byte(string.byte(char))
end

--- Add two bytes.
-- You can use + to adding bytes too.
-- @tparam byte self Reference to a byte object
-- @tparam byte other Reference to the byte to add
-- @treturn byte Byte object
function byte.add(self, other)
    local value = self.value+other.value

    -- Normalise value
    value = math.max(byte.MIN_VALUE, math.min(byte.MAX_VALUE, value))

    return byte(value)
end

--- Substract two bytes.
-- You can use - instead off.
-- @tparam byte self Reference to a byte object
-- @tparam byte other Reference to the byte to substract
-- @treturn byte Byte object
function byte.sub(self, other)
    local value = self.value-other.value

    -- Normalise value
    value = math.max(byte.MIN_VALUE, math.min(byte.MAX_VALUE, value))

    return byte(value)
end

--- Multiply two bytes.
-- You can use * instead of.
-- @tparam byte self Reference to a byte object
-- @tparam byte other Reference to the byte to multiply
-- @treturn byte Byte object
function byte.multiply(self, other)
    local value = self.value*other.value

    -- Normalise value
    value = math.max(byte.MIN_VALUE, math.min(byte.MAX_VALUE, value))

    return byte(value)
end

--- Divide two bytes.
-- You can use / instead of.
-- @tparam byte self Reference to a byte object
-- @tparam byte other Reference to the byte to divide
-- @treturn byte Byte object
function byte.divide(self, other)
    local value = self.value/other.value

    -- Normalise value
    value = math.max(byte.MIN_VALUE, math.min(byte.MAX_VALUE, value))

    return byte(value)
end

--- Get module of two bytes.
-- You can use % instead of.
-- @tparam byte self Reference to a byte object
-- @tparam byte other Reference to second byte
-- @treturn byte Byte object
function byte.mod(self, other)
    local value = self.value%other.value

    -- Normalise value
    value = math.max(byte.MIN_VALUE, math.min(byte.MAX_VALUE, value))

    return byte(value)
end

--- Get the n-th powe of a byte.
-- You can use * instead of.
-- @tparam byte self Reference to base byte object
-- @tparam byte other Reference to exponent byte object
-- @treturn byte Byte object
function byte.power(self, other)
    local value = self.value^other.value

    -- Normalise value
    value = math.max(byte.MIN_VALUE, math.min(byte.MAX_VALUE, value))

    return byte(value)
end

--- Get if a byte is less that other.
-- You can use < instead of.
-- @tparam byte self Reference to a byte object
-- @tparam byte other Reference to the second byte
-- @return true if first byte is less that second byte.
function byte.lt(self, other)
    return self.value < other.value
end

--- Get if a byte is less equals other.
-- You can use <= instead of.
-- @tparam byte self Reference to a byte object
-- @tparam byte other Reference to the second byte
-- @return true if first byte is less equals second byte.
function byte.le(self, other)
    return self.value <= other.value
end

--- Convert a byte to string
-- @tparam byte self Reference to a byte object
-- @treturn string Converted string byte.
function byte.tostring(self)
    return string.char(self.value)
end

--- Return a string representation the object type
-- @treturn string Class type
function byte.type()
    return "byte"
end

--- Create a new type object that extends from a set
-- @treturn obj_type object_type New object type
function byte.extends()
    return byte.super.extends(byte)
end

--- Compare if a object is equals to a byte
-- @tparam byte self Reference to a byte object
-- @tparam object obj
-- @treturn boolean true if is equals
function byte.equals(self, obj)
	if obj == nil then
		return false
	end

	if type(obj) ~= "table" then
		return false
	end

	if obj.type == nil then
		return false
	end

	if not obj:instanceof(byte) then
		return false
	end

	return self.value == obj.value
end

--- Create a new byte
-- @tparam number value Initial value
-- @treturn byte New byte object
function byte.new(value)
    local instance = object.new(byte)
    local meta = getmetatable(instance)

    instance:set(value)

    -- Aritmethic metamethod
	meta["__add"] = instance.add
	meta["__mul"] = instance.multiply
	meta["__sub"] = instance.sub
	meta["__div"] = instance.divide
    meta["__mod"] = instance.mod
    meta["__pow"] = instance.power
    meta["__lt"] = instance.lt
    meta["__le"] = instance.le
	-- Metamethod for tostring
	meta["__tostring"] = instance.tostring

    return setmetatable(instance, meta)
end

return setmetatable(byte, {
		__call = function(module_table, value)
			return byte.new(value)
		end,
		__tostring = byte.type
	})
