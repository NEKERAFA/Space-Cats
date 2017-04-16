--- Test of set type
local object = require('object')
local set = require('math.set')

test = {}

-- Test of contains method
function test.contains()
	instance = set {1, 4, 9}

	assert(instance:contains(4))
	assert(not instance:contains(2))
end

-- Test of add metamethod
function test.add()
	instance1 = set {1, 2, 3}
	instance2 = set {2, 4, 5}
	expected = set {1, 2, 3, 4, 5}

	result = instance1 + instance2

	assert(result == expected)
	assert(result.data_size == 5)
end

-- Test of sub metamethod
function test.sub()
	instance1 = set {1, 2, 3}
	instance2 = set {2, 4, 5}
	expected = set {1, 3}

	result = instance1 - instance2

	assert(result == expected)
	assert(result.data_size == 2)
end

-- Test of mul metamethod
function test.mul()
	instance1 = set {1, 2, 3}
	instance2 = set {2, 4, 5}
	expected = set {2}

	result = instance1 * instance2

	assert(result == expected)
	assert(result.data_size == 1)
end

-- Test of div metamethod
function test.div()
	instance1 = set {1, 2, 3}
	instance2 = set {2, 4, 5}
	expected = set {1, 3, 4, 5}

	result = instance1 / instance2

	assert(result == expected)
	assert(result.data_size == 4)
end

-- Test of subset method
function test.subset()
	instance1 = set {3, 4, 5, 6}
	instance2 = set {3, 4}
	instance3 = set {1, 5, 9}

	assert(instance1:subset(instance1))
	assert(instance1:subset(instance2))
	assert(not instance1:subset(instance3))
end
