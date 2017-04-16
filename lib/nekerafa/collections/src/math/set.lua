--- Set Module.
-- Set is a collection of distinct objects, that's to say, it contains no duplicate elements.
--
-- @module	math.set
-- @author	Rafael Alcalde Azpiazu (NEKERAFA) on mon 28 nov 2016, 23:03
-- @license	Creative Commons Attribution-ShareAlike 4.0
-- @see object

local object = require('object')
local set = object.extends()

-- #### Module ####

--- Get the cardinality of set
-- You can uses # method for get set size
-- @tparam set self Reference to a set object
-- @treturn number size of the set
function set.size(self)
	return self.data_size
end

--- Check if the set is empty
-- @tparam collection self Reference to a stack object
-- @treturn boolean true if is empty
function set.empty(self)
	return self.data_size == 0
end

--- Removes all elements in the set
-- @tparam set self Reference to a set object
function set.clear(self)
	self.data = {}
	self.data_size = 0
	collectgarbage()
end

--- Insert a element in the set.
-- @tparam set self Reference to a set object
-- @param elem Element to adding
function set.add(self, elem)
	if elem == nil then
		error("bad argument #1 to add (attempt to add nil)", 2)
	end

	if not self.data[elem] then
		self.data[elem] = true
		self.data_size = self.data_size+1
	end
end

--- Remove a element
-- @tparam set self Reference to a set object
-- @param elem Element to remove
function set.remove(self, elem)
	if elem == nil then
		error("bad argument #1 to remove (attempt to remove nil)", 2)
	end

	if not self.data[elem] then
		error("attempt to remove not belong element", 2)
	end

	collectgarbage()
	self.data_size = self.data_size-1
	self.data[elem] = nil
end

--- Get if a set have a element
function set.contains(self, elem)
	return self.data[elem] == true
end

--- Union two sets.
-- You can use + to union sets too.
-- @tparam set self Reference to a set object
-- @tparam set obj Reference to the set to union
-- @treturn set A set that contents all elements
function set.union(self, obj)
	local union = set()

	for e in pairs(self.data) do
		union.data[e] = true
		union.data_size = union.data_size+1
	end
	for e in pairs(obj.data) do
		if not union.data[e] then
			union.data[e] = true
			union.data_size = union.data_size+1
		end
	end

	return union
end

-- Intersect two sets.
-- You can use * to intersect sets too
-- @tparam set self Reference to a set object
-- @tparam set obj Reference to the set to intersect
-- @treturn set A set that contents elements that have both sets
function set.intersect(self, obj)
	local intersect = set()

	for e in pairs(self.data) do
		if obj.data[e] then
			intersect.data[e] = true
			intersect.data_size = intersect.data_size+1
		end
	end

	return intersect
end

-- Get complementary set of other sets
-- You can use - to get complementary set too.
-- @tparam set self Reference to a set object
-- @tparam set obj Reference to the set to intersect
-- @treturn set A set that contents elements that is in self and not in obj
function set.complement(self, obj)
	local complement = set()

	for e in pairs(self.data) do
		complement.data[e] = true
		complement.data_size = complement.data_size+1
	end
	for e in pairs(obj.data) do
		if complement.data[e] then
			complement.data[e] = nil
			complement.data_size = complement.data_size-1
		end
	end

	collectgarbage()
	return complement
end

-- Get symetric difference set of other sets
-- You can use / to get symetric set differences
-- @tparam set self Reference to a set object
-- @tparam set obj Reference to the set to intersect
-- @treturn set A set that contents elements that are in self and obj and are uniques
function set.difference(self, obj)
	local difference = set()

	for e in pairs(self.data) do
		difference.data[e] = true
		difference.data_size = difference.data_size+1
	end
	for e in pairs(obj.data) do
		if difference.data[e] then
			difference.data[e] = nil
			difference.data_size = difference.data_size-1
		else
			difference.data[e] = true
			difference.data_size = difference.data_size+1
		end
	end

	collectgarbage()
	return difference
end

--- Checks if obj is a subset of self
-- @tparam set self Reference to a set object
-- @tparam set obj Reference to a subset
-- @treturn boolean true if obj is a subset of self
function set.subset(self, obj)
	if obj.data_size > self.data_size then return false end
	for e in pairs(obj.data) do
		if not self.data[e] then return false end
	end
	return true
end

--- Gets a iterator. Use in for ... in loops
-- @tparam set self Reference to a set object
-- @return A iterator function with one value
function set.iterate(self)
	local e = nil
	return function()
		e = next(self.data, e)
		return e
	end
end

--- Packet a list of elements in the set
-- @tparam set self Reference to a set object
function set.pack(self, ...)
	arg = {...}

	for k in ipairs(arg) do
		self.data_size = self.data_size+1
		self.data[v] = true
	end
end

--- Return a list of elements inside the set
-- @tparam set self Reference to a set object
function set.unpack(self)
	local pack = {}
	for k in pairs(self.data) do
		table.insert(pack, k)
	end

	return pack
end

--- Return a string representation the object type
-- @treturn string Class type
function set.type()
	return "set"
end

--- Create a new type object that extends from a set
-- @treturn obj_type object_type New object type
function set.extends()
	return set.super.extends(set)
end

--- Compare if a object is equals to set
-- @tparam set self Reference to a set object
-- @tparam object obj
-- @treturn boolean true if is equals
function set.equals(self, obj)
	if obj == nil then
		return false
	end

	if type(obj) ~= "table" then
		return false
	end

	if obj.type == nil then
		return false
	end

	if not obj:instanceof(set) then
		return false
	end

	if self.data_size ~= obj.data_size then
		return false
	end

	for elem in pairs(self.data) do
		if not obj.data[elem] then
			return false
		end
	end

	return true
end

--- Create a new set
-- @treturn set New object set
function set.new(t)
	local instance = object.new(set)
	local meta = getmetatable(instance)

	instance.data = {}
	instance.data_size = 0

	-- Si exite una tabla, se rellena la información de esta
	if t and type(t) == "table" then
		for k, v in ipairs(t) do
			instance.data[v] = true
			instance.data_size = instance.data_size+1
		end
	end

	-- Aritmethic metamethod
	meta["__add"] = instance.union
	meta["__mul"] = instance.intersect
	meta["__sub"] = instance.complement
	meta["__div"] = instance.difference

	-- Metamethod for get len
	meta["__len"] = instance.size

	-- Metamethod for concatenate
	meta["__concat"] = function(self, other)
		object.check(other, set, "concat")
		for k in other:iterate() do self:add(k) end
	end
	-- Metamethod for tostring
	oldstring = meta["__tostring"]
	meta["__tostring"] = function(self)
		str = oldstring() .. " {"

		key = 1
		for v in pairs(self.data) do
			str = str .. tostring(v)
			if key ~= self.data_size then
				str = str .. ", "
			end
			key = key+1
		end

		return str .. "}"
	end

	return setmetatable(instance, meta)
end

return setmetatable(set, {
		__call = function(module_table, t)
			return set.new(t)
		end,
		__tostring = set.type
	})
