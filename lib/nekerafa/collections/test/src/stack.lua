--- Test of stack type
local object = require('object')
local stack = require('stack')

test = {}

-- Test of size method
function test.size()
	instance = stack()
	zero = instance:size()
	instance:push(1)

	assert(zero == 0)
	assert(instance:size() == 1)
end

-- Test of empty method
function test.empty()
	instance = stack()
	empty = instance:empty()
	instance:push("hello")

	assert(empty)
	assert(not instance:empty())
end

-- Test of clear method
function test.clear()
	instance = stack()
	instance:push(3)
	instance:push(4)
	instance:clear()

	assert(instance.data_size == 0)
	assert(#instance.data == 0)
end

-- Test of push method
function test.push()
	instance = stack()
	instance:push(2)
	instance:push(0)

	assert(instance.data[2] == 0)
	assert(instance.data_size == 2)
end

-- Test of push method with nil element
test.pushNilElementAssert = {
	expected = "bad argument #2 to push (attempt to add nil)"
}
function test.pushNilElementAssert.assert()
	instance = stack()
	instance:push(nil)
end

-- Test of pop method
function test.pop()
	instance = stack()
	instance:push(2)
	instance:push(1)

	elem = instance:pop()

	assert(elem == 1)
	assert(instance.data_size == 1)
end

-- Test of pop method with empty stack
test.popEmptyAssert = {
	expected = "attempt to remove empty stack"
}
function test.popEmptyAssert.assert()
	instance = stack()
	instance:pop()
end

-- Test of peek method
function test.peek()
	instance = stack()
	instance:push(2)
	elem1 = instance:peek()
	instance:push(4)
	elem2 = instance:peek()

	assert(elem1 == 2)
	assert(elem2 == 4)
end

-- Test of peek method with empty stack
test.peekEmptyAssert = {
	expected = "attempt to get front element from empty stack"
}
function test.peekEmptyAssert.assert()
	instance = stack()
	instance:peek()
end

-- Test of set method
function test.set()
	instance = stack()
	instance:push(1)
	instance:set(4)

	assert(instance.data[1] == 4)
end

-- Test of set method with empty stack
test.setEmptyAssert = {
	expected = "attempt to set element from empty stack"
}
function test.setEmptyAssert.assert()
	instance = stack()
	instance:set(3)
end

-- Test of set method with nil element
test.setNilElementAssert = {
	expected = "bad argument #2 to set (attempt to set nil)"
}
function test.setNilElementAssert.assert()
	instance = stack()
	instance:push(1)
	instance:set(nil)
end

-- Test of find method
function test.find()
	instance = stack()
	instance:push(4)

	assert(instance:find(4))
	assert(not instance:find(2))
end

-- Test of swap method
function test.swap()
	instance = stack()
	instance:push(1)
	instance:push(2)
	instance:push(3)
	instance:swap()

	assert(instance.data[1] == 3)
	assert(instance.data[2] == 2)
	assert(instance.data[3] == 1)
	assert(instance.data_size == 3)
end

-- Test of pack method
function test.pack()
	instance = stack()
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
	instance1 = stack()
	instance1:push(3)
	instance1:push(1)
	instance1:push(4)

	instance2 = stack()
	instance2:push(2)
	instance2:push(6)
	instance2:push(9)

	instance3 = stack()
	instance3:push(3)
	instance3:push(1)
	instance3:push(4)

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
	type_object = stack.extends()

	assert(type_object.instanceof)
	assert(type_object.clone)
	assert(type_object.equals)
	assert(type_object.type)
	assert(type_object.new)
	assert(type_object.extends)
	assert(type_object.push)
	assert(type_object.pop)
	assert(type_object.peek)
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
	instance = stack.new()

	assert(instance.instanceof)
	assert(instance.clone)
	assert(instance.equals)
	assert(instance.type)
	assert(instance.push)
	assert(instance.pop)
	assert(instance.peek)
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
