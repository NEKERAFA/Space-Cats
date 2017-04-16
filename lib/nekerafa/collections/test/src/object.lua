--- Test of object type
local object = require('object')

test = {}

--- Test instanceOf
function test.instanceOf()
	instance = object()

	assert(instance:instanceof(object))
end

--- Test instanceOf with nil instance
test.instanceOfNilInstanceAssert = {
	expected = "bad argument #1 in instanceof (expected object, got nil)"
}
function test.instanceOfNilInstanceAssert.assert()
	object.instanceof(nil, object)
end

--- Test instanceOf with table instance
test.instanceOfTableInstanceAssert = {
	expected = "bad argument #1 in instanceof (expected object, got table)"
}
function test.instanceOfTableInstanceAssert.assert()
	object.instanceof({}, object)
end

--- Test instanceOf with nil type
test.instanceOfNilTypeAssert = {
	expected = "bad argument #2 in instanceof (expected object, got nil)"
}
function test.instanceOfNilTypeAssert.assert()
	instance = object()
	instance:instanceof(nil)
end

--- Test instanceOf with table type
test.instanceOfTableTypeAssert = {
	expected = "bad argument #2 in instanceof (expected object, got table)"
}
function test.instanceOfTableTypeAssert.assert()
	instance = object()
	instance:instanceof({})
end

--- Test clone
function test.clone()
	instance1 = object()
	instance2 = instance1:clone()

	for k, v in pairs(instance1) do
		if type(v) == "table" then
			assert(table.equals(v, instance2[k]))
		else
			assert(instance2[k] == v)
		end
	end
end

--- Test equals with same object
function test.equalsSame()
	instance = object()
	assert(instance:equals(instance))
end

--- Test equals with other object
function test.equalsOther()
	instance1 = object()
	instance2 = object()

	assert(not instance1:equals(instance2))
end

--- Test extends
function test.extends()
	type_object = object.extends()

	assert(type_object.instanceof)
	assert(type_object.clone)
	assert(type_object.equals)
	assert(type_object.type)
	assert(type_object.new)
	assert(type_object.extends)
	assert(type_object.check == nil)
end

--- Test new
function test.new()
	instance = object.new()

	assert(instance.instanceof)
	assert(instance.clone)
	assert(instance.equals)
	assert(instance.type)
	assert(instance.new == nil)
	assert(instance.extends == nil)
	assert(instance.check == nil)
end
