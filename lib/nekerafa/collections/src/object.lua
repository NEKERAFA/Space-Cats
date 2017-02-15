--- Object module.
-- This is the basic representation of an object prototype-oriented in Lua,
-- defining basic behavour of object single extension hierarchy.
-- Although being a module, instances of object type can be used with Lua
-- object oriented written.
-- Passing an object to tostring return a representation of the object.
--
-- @module	object
-- @author	Rafael Alcalde Azpiazu (NEKERAFA) on tue 15 nov, 21:00
-- @license	Creative Commons Attribution-ShareAlike 4.0

local object = {}

local object_id = {}

--- Get if is instance of object
-- @tparam object self Reference to an object
-- @tparam obj_type object_type Reference to an object type
-- @treturn boolean True if is a instance
function object.instanceof(self, object_type)
	if type(self) ~= "table" or self.type == nil then
		error("bad argument #1 in instanceof (expected object, got " .. type(self) .. ")", 2)
	end
	if type(object_type) ~= "table" or object_type.type == nil then
		error("bad argument #2 in instanceof (expected object, got " .. type(object_type) .. ")", 2)
	end

	instance = self
	while instance.type() ~= object_type.type() do
		if instance.super ~= nil then
			instance = instance.super()
		else
			return false
		end
	end

	return true
end

--- Create a copy of current object
-- @tparam object self Reference to an object
-- @treturn object New object
function object.clone(self)
	meta = getmetatable(self)
	copy = {}

	for key, value in pairs(self) do
		if type(value) == "table" then
			copy[key] = {}
			for k, v in pairs(value) do
				copy[key][k] = v
			end
		else
			copy[key] = value
		end
	end

	return setmetatable(copy, meta)
end

--- Compare a object with other
-- @tparam object self First object to compare
-- @tparam object obj Second object to compare
-- @treturn boolean true if object are equals
function object.equals(self, obj)
	return rawequal(self, obj)
end

--- Return a string representation the object type
-- @treturn string Object type
function object.type()
	return "object"
end

--- Return object from id
-- @tparam number id Refecence to an id object
-- @treturn object current object associate to id
function object.object(id)
	if type(id) ~= "number" then
		error("Bad argument #1 to id, expected number, got "..type(id)..")", 2)
	end

	return object_id[id]
end

--- Clear a object al free their content
-- @tparam object self Refecence to an object
function object.free(self)
	object_id[self.id] = nil
end

--- Creates a new instance of object type.
-- You can instance a new object type using object()
-- @tparam obj_type object_type Type object that create new instance. If is null, it will create a instance of object
-- @treturn object New object
function object.new(object_type)
	if object_type == nil then
		object_type = object
	end

	-- ID del objeto
	local id

	-- Se comprueba que ese ID no se haya introducido
	repeat
		equal = false
		id = math.random(0, 2^32)
		equal = (object_id[id] ~= nil)
	until not equal

	local instance = {id = id}

	object_id[id] = instance

	-- Se recorren todos los métodos para incluirlos en la nueva instancia
	for method, func in pairs(object_type) do
		if method ~= "extends" and method ~= "new" and method ~= "check" and method ~= "object" then
			--print(method)
			instance[method] = func
		end
	end

	-- Se devuelve la instancia junto a una metatabla
	return setmetatable(instance, {
			__eq = instance.equals,
			__gc = object.free,
			__tostring = function()
				return string.format("%s 0x%x", instance.type(), id)
			end
		})
end

--- Create a new type object that extends from other type object
-- @tparam obj_type object_type Type object that extends the new type. If you pass a nil, it will extend from object
-- @treturn obj_type object_type New object type
function object.extends(object_type)
	if object_type == nil then
		object_type = object
	end

	local new_type = {}
	for method, func in pairs(object_type) do
		if method ~= "check" and method ~= "object" then
			new_type[method] = func
		end
	end

	new_type.super = object_type

	return new_type
end

-- Return module
return setmetatable(object, {
		__call = object.new,
		__tostring = object.type
	})
