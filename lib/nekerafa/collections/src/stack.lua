--- Stack Module.
-- Stack is the represention of LIFO (last-in, first-out) list. You can only
-- get or remove the last element add.
--
-- @module	stack
-- @author	Rafael Alcalde Azpiazu (NEKERAFA) on mon 14 nov 2016, 23:30
-- @license	Creative Commons Attribution-ShareAlike 4.0
-- @see object

local object = require('object')
local stack = object.extends()

-- #### Module ####

--- Get the number of elements in the stack object.
-- You can uses # method for get stack size
-- @tparam stack self Reference to a stack object
-- @treturn number size of the collection
function stack.size(self)
	return self.data_size
end

--- Check if the stack is empty
-- @tparam collection self Reference to a stack object
-- @treturn boolean true if is empty
function stack.empty(self)
	return self.data_size == 0
end

--- Removes all elements in the stack
-- @tparam collection self Reference to a stack object
function stack.clear(self)
	self.data = {}
	self.data_size = 0
	collectgarbage()
end

--- Insert a element in the stack
-- @tparam stack self Reference to a stack object
-- @param elem Element to adding
function stack.push(self, elem)
	if elem == nil then
		error("bad argument #2 to push (attempt to add nil)", 2)
	end

	self.data_size = self.data_size+1
	table.insert(self.data, elem)
end

--- Remove the first element in the stack
-- @tparam stack self Reference to a tack object
-- @return Element removed
function stack.pop(self)
	if self.data_size == 0 then
		error("attempt to remove empty stack", 2)
	end

	self.data_size = self.data_size-1
	return table.remove(self.data)
end

--- Get the last element in the stack
-- @tparam stack self Reference to a stack object
-- @return Element at the last position
function stack.peek(self)
	if self.data_size == 0 then
		error("attempt to get front element from empty stack", 2)
	end

	return self.data[self.data_size]
end

--- Set a element at front of the stack
-- @tparam stack self Reference to a stack object
-- @param elem Element to put
function stack.set(self, elem)
	if self.data_size == 0 then
		error("attempt to set element from empty stack", 2)
	end

	if elem == nil then
		error("bad argument #2 to set (attempt to set nil)", 2)
	end

	self.data[self.data_size] = elem
end

--- Look up an element in the stack
-- @tparam stack self Reference to a stack object
-- @param elem Element to search for
-- @treturn bolean true if the element exists in the stack
function stack.find(self, elem)
	if not self:empty() then
		local n = 1

		while (n <= self.data_size) and (self.data[n] ~= elem) do
			n=n+1
		end

		if n > self.data_size then
			return false
		end

		return true
	end

	return false
end

--- Swap all content in the stack
-- @tparam stack self Reference to a stack object
function stack.swap(self)
	self.newdata = setmetatable({}, {__mode = "kv"})

	for k, v in ipairs(self.data) do
		self.newdata[self.data_size-k+1] = v
	end

	self.data = self.newdata
end

--- Packet a list of elements in the collection
-- @tparam stack self Reference to a stack object
function stack.pack(self, ...)
	list = {...}

	for k, v in pairs(list) do
		self.data_size = self.data_size+1
		table.insert(self.data, v)
	end
end

--- Compare if a object is equals to stack
-- @tparam stack self Reference to a stack object
-- @tparam object obj
-- @treturn boolean true if is equals
function stack.equals(self, obj)
	if obj == nil then
		return false
	end

	if type(obj) ~= "table" then
		return false
	end

	if obj.type == nil then
		return false
	end

	if not obj:instanceof(stack) then
		return false
	end

	if self.data_size ~= obj.data_size then
		return false
	end

	for i, value in ipairs(self.data) do
		if obj.data[i] ~= value then
			return false
		end
	end

	return true
end

--- Return a string representation the object type
-- @treturn string Class type
function stack.type()
	return "stack"
end

--- Create a new type object that extends from a list object
-- @treturn obj_type object_type New object type
function stack.extends()
	return stack.super.extends(stack)
end

--- Create a new stack
-- @treturn stack New object stack
function stack.new(t)
	local instance = object.new(stack)
	local meta = getmetatable(instance)

	instance.data = {}
	instance.data_size = 0

	-- Metamethod for get len
	meta["__len"] = instance.size

	-- Si exite una tabla, se rellena la información de esta
	if t and type(t) == "table" then
		for k, v in ipairs(t) do
			table.insert(instance.data, v)
			instance.data_size = instance.data_size+1
		end
	end

	return setmetatable(instance, meta)
end

-- Return stack module
return setmetatable(stack, {
		__call = function(module_table, t)
			return stack.new(t)
		end,
		__tostring = stack.type
	})
