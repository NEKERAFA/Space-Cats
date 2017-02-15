-- Load all tests

package.path = "./src/?.lua;"

-- Object test
arg = {"object", "test/src/object.lua"}
dofile("test/lunit.lua")

print()

-- Stack test
arg = {"stack", "test/src/stack.lua"}
dofile("test/lunit.lua")

print()

-- List test
arg = {"list", "test/src/list.lua"}
dofile("test/lunit.lua")

print()

-- Set test
arg = {"set", "test/src/math/set.lua"}
dofile("test/lunit.lua")

-- Byte test
arg = {"byte", "test/src/math/byte.lua"}
dofile("test/lunit.lua")
