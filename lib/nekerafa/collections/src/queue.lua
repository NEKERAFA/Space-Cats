--- Queue Module.
-- Queue is the represention of FIFO (first-in, first-out) list. You can only
-- get or remove the last element add.
--
-- @module	queue
-- @author	Rafael Alcalde Azpiazu (NEKERAFA) on mon 28 nov 2016, 23:03
-- @license	Creative Commons Attribution-ShareAlike 4.0
-- @see object

local object = require('object')
local queue = object.extends()

-- #### Module ####

--- Get the number of elements in the queue object.
-- You can uses # method for get queue size
-- @tparam queue self Reference to a queue object
-- @treturn number size of the collection
function queue.size(self)
	return self.data_size
end

--- Check if the queue is empty
-- @tparam collection self Reference to a queue object
-- @treturn boolean true if is empty
function queue.empty(self)
	return self.data_size == 0
end

--- Removes all elements in the queue
-- @tparam collection self Reference to a queue object
function queue.clear(self)
	self.data = {}
	self.data_size = 0
	collectgarbage()
end

--- Insert a element in the queue
-- @tparam queue self Reference to a queue object
-- @param elem Element to adding
function queue.push(self, elem)
	if elem == nil then
		error("bad argument #2 to push (attempt to add nil)", 2)
	end

	self.data_size = self.data_size+1
	table.insert(self.data, elem)
end

--- Remove the first element in the queue
-- @tparam queue self Reference to a tack object
-- @return Element removed
function queue.pop(self)
	if self.data_size == 0 then
		error("attempt to remove empty queue", 2)
	end

	self.data_size = self.data_size-1
	return table.remove(self.data, 1)
end

--- Get the front element in the queue
-- @tparam queue self Reference to a queue object
-- @return Element at the last position
function queue.front(self)
	if self.data_size == 0 then
		error("attempt to get front element from empty queue", 2)
	end

	return self.data[1]
end

--- Set a element at front of the queue
-- @tparam queue self Reference to a queue object
-- @param elem Element to put
function queue.set(self, elem)
	if self.data_size == 0 then
		error("attempt to set element from empty queue", 2)
	end
	if elem == nil then
		error("bad argument #2 to set (attempt to set nil)", 2)
	end

	self.data[1] = elem
end

--- Look up an element in the queue
-- @tparam queue self Reference to a queue object
-- @param elem Element to search for
-- @treturn bolean true if the element exists in the queue
function queue.find(self, elem)
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

--- Swap all content in the queue
-- @tparam queue self Reference to a queue object
function queue.swap(self)
	self.newdata = {}

	for k, v in ipairs(self.data) do
		self.newdata[self.data_size-k+1] = v
	end

	self.data = self.newdata
end

--- Packet a list of elements in the collection
-- @tparam queue self Reference to a queue object
function queue.pack(self, ...)
	list = {...}
	for k, v in pairs(list) do
		self.data_size = self.data_size+1
		table.insert(self.data, v)
	end
end

--- Compare if a object is equals to queue
-- @tparam queue self Reference to a queue object
-- @tparam object obj
-- @treturn boolean true if is equals
function queue.equals(self, obj)
	if obj == nil then
		return false
	end

	if type(obj) ~= "table" then
		return false
	end

	if obj.type == nil then
		return false
	end

	if not obj:instanceof(queue) then
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
function queue.type()
	return "queue"
end

--- Create a new type object that extends from a list object
-- @treturn obj_type object_type New object type
function queue.extends()
	return queue.super.extends(queue)
end

--- Create a new queue
-- @treturn queue New object queue
function queue.new(t)
	local instance = object.new(queue)
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

-- Return queue module
return setmetatable(queue, {
		__call = function(module_table, t)
			return queue.new(t)
		end,
		__tostring = queue.type
	})
