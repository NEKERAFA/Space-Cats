--- Lua test loader
--
-- @script	test_loader
-- @author	Rafael Alcalde Azpiazu (NEKERAFA) on sun 13 nov 2016 22:03 (CET)
-- @license	Creative Commons Attribution-ShareAlike 4.0
-- @usage	test_loader.lua [name of test] [file]

math.randomseed(os.time())

-- Print a usage message
local function usage()
	print([[Usage: lunit.lua [name of test] [file]

· Test extructuration:
All test must have in global test table. Test with expected error must have in second table with atributes 'expected' and 'assert'.

· Examples:

> test.lua
test = {}

-- Test with assert
function test.table()
	mytable = {}
	table.insert(mytable, "test")
	assert(mytable[1] == "test")
end

-- Test expected an error
test.raiseErrorAssert = {
	expected = "myerror"
}
function test.raiseErrorAssert.assert()
	error("myerror")
end

> Terminal: lunit.lua example test.lua]])
end

if #arg ~= 2 then
	usage()
	return
end

-- Funtions assertion
function assert_true(value)
	assert(value == true)
end

function assert_false(value)
	assert(value == false)
end

-- Check if funtion is a assert
local function is_test_assertion(name)
	if string.find(name:lower(), "%wassert") or string.find(name:lower(), "assert%w") then
		return true
	else
		return false
	end
end

-- Check if element is a test function
local function is_function_test(elem)
	if elem ~= nil and type(elem) == "function" then
		return true
	end
	return false
end

-- Check if element is a assert test
local function is_table_test_assert(elem)
	if type(elem) == "table" and elem.expected ~= nil and type(elem.expected) == "string"
			and is_function_test(elem.assert) then
		return true
	end
	return false
end

-- Parse error in file, line and, msg
local function parse_error(msg)
	return msg:match('^(.-):(%d+): (.+)')
end

-- Randomize a table
local function shuffle(tbl)
	local len = #tbl

	for i = 2, len, 1 do
		j = math.random(i)
		tbl[i], tbl[j] = tbl[j], tbl[i]
	end
end

-- For checking errors
local passed = 0
local failed = 0
local errors = 0
local traceback = ""

local function print_traceback(err)
	traceback = debug.traceback()
	return err
end

-- Load test
local loaded
local msg

loaded, msg = pcall(dofile, arg[2])

-- Error in test file
if not loaded then
	print("Error in "..arg[1].." tests: ".. msg)
	return 0;
end

-- If file not have test table
if not test or type(test) ~= "table" then
	print("Cannot load file, this file not seem have test\n")
	usage()
	return;
else
	print("-- Starting test of "..arg[1].." --")

	-- Randomized all test
	shuffle(test)

	-- Execute test
	if test.beforeTest then test.beforeTest() end

	-- Parsing all test
	for name, testelem in pairs(test) do
		-- If test is a assertion
		if is_test_assertion(name) and is_table_test_assert(testelem) then
			-- Before function
			if test.beforeAssert then test.beforeAssert() end
			-- Execute function
			pass, err = xpcall(testelem.assert, print_traceback)
			-- After function
			if test.afterAssert then test.afterAssert() end

			if not pass then
				file, line, msg = parse_error(err)

				-- Assertion passed
				if msg == testelem.expected then
					print("Test "..name..": Passed")
					passed = passed+1
				-- Assertion error
				else
					errors = errors+1
					print("Test "..name..": "..err)
					print(traceback)
				end
			-- Assertion failed
			else
				print("Test "..name..": Assertion failed!")
				failed = failed+1
			end
		-- If test is not assertion
	elseif is_function_test(testelem) and (name ~= "beforeTest") and (name ~= "afterTest") and (name ~= "beforeAssert") and (name ~= "afterAssert") then
			-- Before function
			if test.beforeAssert then test.beforeAssert() end
			-- Execute function
			pass, err = xpcall(testelem, print_traceback)
			-- After function
			if test.afterAssert then test.afterAssert() end

			if not pass then
				file, line, msg = parse_error(err)

				-- If is a assertion
				if msg == "assertion failed!" then
					failed = failed+1
					print("Test "..name.. ":"..line..": Assertion failed")
					print(traceback)
				-- Test error
				else
					errors = errors+1
					print("Test "..name..": "..err)
					print(traceback)
				end
			-- Test passed
			else
				print("Test "..name..": Passed")
				passed = passed+1
			end
		elseif (name ~= "beforeTest") and (name ~= "afterTest") and (name ~= "beforeAssert") and (name ~= "afterAssert") then
			print(name.." cannot be a test. Avoiding")
		end
	end

	if test.afterTest then test.afterTest() end

	-- Resume
	print('\nAll test finished: '..passed..' passed, '..failed..' failed, '..errors..' errors')
end
