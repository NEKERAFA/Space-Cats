--- Test of byte type
local object = require('object')
local byte = require('math.byte')

test = {}

function test.add()
    local instance1 = byte(4)
    local instance2 = byte(2)
    local expected = byte(6)

    local result = instance1 + instance2

    assert(result == expected)
end

function test.sub()
    local instance1 = byte(4)
    local instance2 = byte(2)
    local expected = byte(2)

    local result = instance1 - instance2

    assert(result == expected)
end

function test.multiply()
    local instance1 = byte(4)
    local instance2 = byte(2)
    local expected = byte(8)

    local result = instance1 * instance2

    assert(result == expected)
end

function test.divide()
    local instance1 = byte(6)
    local instance2 = byte(2)
    local expected = byte(3)

    local result = instance1 / instance2

    assert(result == expected)
end

function test.module()
    local instance1 = byte(4)
    local instance2 = byte(2)
    local expected = byte(0)

    local result = instance1 % instance2

    assert(result == expected)
end

function test.power()
    local instance1 = byte(4)
    local instance2 = byte(2)
    local expected = byte(16)

    local result = instance1 ^ instance2

    assert(result == expected)
end

function test.lt()
    local instance1 = byte(2)
    local instance2 = byte(4)

    assert(instance1 < instance2)
    assert(not (instance2 < instance1))
    assert(not (instance2 < instance2))
end

function test.gt()
    local instance1 = byte(2)
    local instance2 = byte(4)

    assert(not (instance1 > instance2))
    assert(not (instance2 > instance2))
    assert(instance2 > instance1)
end

function test.le()
    local instance1 = byte(2)
    local instance2 = byte(4)

    assert(instance1 <= instance2)
    assert(instance2 <= instance2)
    assert(not (instance2 <= instance1))
end

function test.ge()
    local instance1 = byte(2)
    local instance2 = byte(4)

    assert(not (instance1 >= instance2))
    assert(instance2 >= instance2)
    assert(instance2 >= instance1)
end

function test.equals()
    local instance1 = byte(2)
    local instance2 = byte(4)
    local instance3 = byte(4)

    assert(not (instance1 == instance2))
    assert(instance2 == instance3)
end
