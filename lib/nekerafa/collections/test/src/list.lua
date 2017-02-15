--- Test of list type
local object = require('object')
local list = require('list')

test = {}

-- Test of size method
function test.size()
	instance = list()
	zero = instance:size()
	instance:add(1)

	assert(zero == 0)
	assert(instance:size() == 1)
end

-- Test of size metamethod
function test.len()
	instance = list()
	zero = #instance
	instance:add(1)

	assert(zero == 0)
	assert(#instance == 1)
end

-- Test of empty method
function test.empty()
	instance = list()
	empty = instance:empty()
	instance:add("hello")

	assert(empty)
	assert(not instance:empty())
end

-- Test of clear method
function test.clear()
	instance = list()
	instance:add(3)
	instance:add(4)
	instance:clear()

	assert(instance.data_size == 0)
	assert(#instance.data == 0)
end

-- Test of add method
function test.add()
	instance = list()
	instance:add(2)
	instance:add(0)

	assert(instance.data[2] == 0 and instance.data_size == 2)
end

-- Test of add method with nil element
test.addNilElementAssert = {
	expected = "bad argument #2 to add (attempt to add nil)"
}
function test.addNilElementAssert.assert()
	instance = list()
	instance:add(nil)
end

-- Test of set method
function test.set()
	instance = list()
	instance:add(1)
	instance:add(2)
	instance:set(1, 4)
	instance:set(2, 3)

	assert(instance.data[1] == 4)
	assert(instance.data[2] == 3)
end

-- Test of set method with empty list
test.setEmptyAssert = {
	expected = "attempt to set element from empty list"
}
function test.setEmptyAssert.assert()
	instance = list()
	instance:set(1, 3)
end

-- Test of set method with nil element
test.setNilElementAssert = {
	expected = "bad argument #3 to set (attempt to set nil)"
}
function test.setNilElementAssert.assert()
	instance = list()
	instance:add(1)
	instance:set(1, nil)
end

-- Test of find method
function test.find()
	instance = list()
	instance:add(4)

	assert(instance:find(4))
	assert(not instance:find(2))
end

-- Test of swap method
function test.swap()
	instance = list()
	instance:add(1)
	instance:add(2)
	instance:add(3)
	instance:swap()

	assert(instance.data[1] == 3)
	assert(instance.data[2] == 2)
	assert(instance.data[3] == 1)
	assert(instance.data_size == 3)
end

-- Test of pack method
function test.pack()
	instance = list()
	instance:pack(1, 2, 3, 4)

	assert(instance.data[1] == 1)
	assert(instance.data[2] == 2)
	assert(instance.data[3] == 3)
	assert(instance.data[4] == 4)
	assert(instance.data_size == 4)
end

-- Test of equals method
function test.equals()
	-- Create instances
	instance1 = list()
	instance1:add(3)
	instance1:add(1)
	instance1:add(4)

	instance2 = list()
	instance2:add(2)
	instance2:add(6)
	instance2:add(9)

	instance3 = list()
	instance3:add(3)
	instance3:add(1)
	instance3:add(4)

	-- equals with nul
	assert(not instance1:equals(nil))

	-- equals with not object
	assert(not instance1:equals(1))

	-- equals with table
	assert(not instance1:equals({}))

	-- equals with a object
	assert(not instance1:equals(object()))

	-- equals with not same
	assert(not instance1:equals(instance2))

	-- equals with the same
	assert(instance1:equals(instance3))

	-- equals with himself
	assert(instance1:equals(instance1))
end

--- Test of extends method
function test.extends()
	type_object = list.extends()

	assert(type_object.instanceof)
	assert(type_object.clone)
	assert(type_object.equals)
	assert(type_object.type)
	assert(type_object.new)
	assert(type_object.extends)
	assert(type_object.add)
	assert(type_object.remove)
	assert(type_object.get)
	assert(type_object.set)
	assert(type_object.find)
	assert(type_object.swap)
	assert(type_object.pack)
	assert(type_object.size)
	assert(type_object.empty)
	assert(type_object.clear)
	assert(type_object.check == nil)
end

--- Test of new method
function test.new()
	instance = list.new()

	assert(instance.instanceof)
	assert(instance.clone)
	assert(instance.equals)
	assert(instance.type)
	assert(instance.add)
	assert(instance.remove)
	assert(instance.get)
	assert(instance.set)
	assert(instance.find)
	assert(instance.swap)
	assert(instance.pack)
	assert(instance.size)
	assert(instance.empty)
	assert(instance.clear)
	assert(instance.new == nil)
	assert(instance.extends == nil)
	assert(instance.check == nil)
end
