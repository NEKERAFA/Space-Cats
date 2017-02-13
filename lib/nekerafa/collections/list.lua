--- List module.
-- A list is a representation of an unordened group of elements. This type has
-- methods for get, put and extract new elements in the list, and others
-- advanced functions to append, sort and navigate for the list.
--
-- @module	list
-- @author	Rafael Alcalde Azpiazu (NEKERAFA) on sun 13 nov 2016 11:24 (CET)
-- @license	Creative Commons Attribution-ShareAlike 4.0
-- @see object

local object = require('nekerafa.collections.object')
local list = object.extends()

-- #### Module ####

--- Checks if the list is empty
-- @tparam list self Reference to a list object
-- @treturn boolean true if is empty
function list.empty(self)
	return self.data_size == 0
end

--- Removes all elements in the list
-- @tparam list self Reference to a list object
function list.clear(self)
	self.data = {}
	self.data_size = 0
	collectgarbage()
end

--- Gets the number of elements in the list.
-- You can uses # method for get stack size.
-- @tparam list self Reference to a list object
-- @treturn number size of the list
function list.size(self)
	return self.data_size
end

--- Inserts a element in the list
-- @tparam list self Reference to a list object
-- @param elem Element to adding
-- @tparam number pos (Optional) Position to insert
function list.add(self, elem, pos)
	if elem == nil then
		error("bad argument #2 to add (attempt to add nil)", 2)
	end
	if pos and (type(pos) ~= "number") then
		error("bad argument #3 to add (number expected, got "..type(pos)..")", 2)
	end
	if pos and ((pos > self.data_size) or (pos < 1)) then
		error("bad argument #3 to add (position out of bounds)", 2)
	end

	self.data_size = self.data_size+1
	table.insert(self.data, pos or self.data_size, elem)
end

--- Replaces the element in the position with a new element
-- @tparam list self Reference to a list object
-- @tparam number pos Position to put
-- @param elem New element to insert
function list.set(self, pos, elem)
	if type(pos) ~= "number" then
		error("bad argument #2 to set (number expected, got "..type(pos)..")", 2)
	end
	if(self.data_size == 0) then
		error("attempt to set element from empty list", 2)
	end
	if (pos > self.data_size) or (pos < 1) then
		error("bad argument #2 to set (position out of bounds)", 2)
	end
	if elem == nil then
		error("bad argument #3 to set (attempt to set nil)", 2)
	end

	self.data[pos] = elem
end

--- Gets a element at the specified position in the list
-- @tparam list self Reference to a list object
-- @tparam number pos Index of the element
-- @return Element at the position
function list.get(self, pos)
	if type(pos) ~= "number" then
		error("bad argument #2 to get (number expected, got "..type(pos)..")", 2)
	end
	if(self.data_size == 0) then
		error("attemp to get element from empty list", 2)
	end
	if (pos > self.data_size) or (pos < 1) then
		error("bad argument #2 to get (position out of bounds)", 2)
	end

	return self.data[pos]
end

--- Removes a element in the list
-- @tparam list self Reference to a list object
-- @tparam number pos Position of the element to remove
-- @return Removed element
function list.remove(self, pos)
	if type(pos) ~= "number" then
		error("bad argument #2 to remove (number expected, got "..type(pos)..")", 2)
	end
	if self.size == 0 then
		error("attemp to remove element from empty list", 2)
	end
	if (pos > self.data_size) or (pos < 1) then
		error("bad argument #2 to remove (position out of bounds)", 2)
	end

	self.data_size = self.data_size-1
	return table.remove(self.data, pos or self.data_size+1)
end

--- Looks up an element in the list
-- @tparam list self Reference to a list object
-- @param elem Element to look
-- @return Position of the element or false if it not exists in the list
function list.find(self, elem)
	if not self:empty() then
		local n = 1
		while (n <= self.data_size) and (self.data[n] ~= elem) do
			n=n+1
		end
		if n > self.data_size then
			return false
		end
		return n
	end

	return false
end

--- Gets the next element in the list
-- @tparam list self Reference to a list object
-- @tparam number pos Position in the list
-- @return Next element or nil if is the last position
function list.next(self, pos)
	if type(pos) ~= "number" then
		error("bad argument #2 to get (number expected, got "..type(pos)..")", 2)
	end
	if (pos > self.data_size) or (pos < 1) then
		error("bad argument #2 to get (position out of bounds)", 2)
	end
	if self.size == 0 then
		error("attemp to remove element from empty list", 2)
	end

	if pos == self.data_size then
		return nil
	end
	return self.data[pos+1]
end

--- Gets the previous element in the list
-- @tparam list self Reference to a list object
-- @tparam number pos Position in the list
-- @return Previous element or nil if is the first position
function list.prev(self, pos)
	if type(pos) ~= "number" then
		error("bad argument #2 to get (number expected, got "..type(pos)..")", 2)
	end
	if (pos > self.data_size) or (pos < 1) then
		error("bad argument #2 to get (position out of bounds)", 2)
	end
	if self.size == 0 then
		error("attemp to remove element from empty list", 2)
	end

	if pos == 1 then
		return nil
	end
	return self.data[pos-1]
end

-- Gets the first element in the list
-- @tparam list self Reference to a list object
-- @return First element in the list or nil if list is empty
function list.first(self)
	if self.data_size == 0 then
		return nil
	end
	return self.data[1]
end

-- Gets the last element in the list
-- @tparam list self Reference to a list object
-- @return Last element in the list or nil if list is empty
function list.last(self)
	if self.data_size == 0 then
		return nil
	end
	return self.data[self.data_size]
end

--- Gets a iterator. Use in for ... in loops
-- @tparam list self Reference to a list object
-- @return A iterator function with two params: key and value
function list.iterate(self)
	return pairs(self.data)
end

---  Sort all elements in the list with a compare function
-- @tparam list self Reference to a list object
-- @tparam function comp A compare function
function list.sort(self, comp)
	table.sort(self.data, comp)
end

--- Packet a list of elements in the collection
-- @tparam list self Reference to a list object
function list.pack(self, ...)
	arg = {...}

	for k, v in ipairs(arg) do
		self.data_size = self.data_size+1
		table.insert(self.data, v)
	end
end

--- Concatenate two list.
-- You can use .. to append two lists
-- @tparam list self Reference to a list object
-- @tparam list other Reference to a list object
function list.append(self, other)
	for k, v in other:iterate() do
		self:add(v)
	end
end

--- Swap all content in the list
-- @tparam list self Reference to a list object
function list.swap(self)
	local newdata = {}

	for k, v in ipairs(self.data) do
		newdata[self.data_size-k+1] = v
	end

	self.data = newdata
end

--- Return a list of elements inside the collection
-- @tparam list self Reference to a list object
-- @tparam number i First position of elements. Default is 1
-- @tparam number j Last position of elements. Default is list.size
function list.unpack(self, i, j)
	return table.unpack(list.data, i, j)
end

--- Return a string representation the object type
-- @treturn string Class type
function list.type()
	return "list"
end

--- Compare if a object is equals to list
-- @tparam stack self Reference to a list object
-- @tparam object obj
-- @treturn boolean true if is equals
function list.equals(self, obj)
	if obj == nil then
		return false
	end

	if type(obj) ~= "table" then
		return false
	end

	if obj.type == nil then
		return false
	end

	if not obj:instanceof(list) then
		return false
	end

	if self.data_size ~= obj.data_size then
		return false
	end

	for i, elem_self in ipairs(self.data) do
		equals = false
		for k, elem_obj in ipairs(obj.data) do
			if elem_self == elem_obj then
				equals = true
				break
			end
		end

		if not equals then
			return false
		end
	end

	return true
end

--- Creates a new type object that extends from a list object
-- @treturn obj_type object_type New object type
function list.extends()
	return list.super.extends(list)
end

--- Creates a new list
-- @treturn list New object list
function list.new(t)
	local instance = object.new(list)
	local meta = getmetatable(instance)

	instance.data = {}
	instance.data_size = 0

	-- Si exite una tabla, se rellena la información de esta
	if t and type(t) == "table" then
		for k, v in ipairs(t) do
			table.insert(instance.data, v)
			instance.data_size = instance.data_size+1
		end
	end

	-- Metamethod for size
	meta["__len"] = instance.size
	-- Metamethod for concatenate
	meta["__concat"] = function(self, other)
		self:append(other)
	end
	-- Metamethod for tostring
	oldstring = meta["__tostring"]
	meta["__tostring"] = function(self)
		str = oldstring() .. " ["

		for k, v in ipairs(self.data) do
			str = str .. tostring(v)
			if k ~= self.data_size then
				str = str .. ", "
			end
		end

		return str .. "]"
	end

	return setmetatable(instance, meta)
end

-- Set a metatable with list
return setmetatable(list, {
		__call =  function(module_table, t)
			return list.new(t)
		end,
		__tostring = list.type
	})
