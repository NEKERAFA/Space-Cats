--- Some rubish and other things :3
--
-- @author	Rafael Alcalde Azpiazu (NEKERAFA)
-- @license GNU General Public License v3

-- MATH UTILITIES

--- Round a number
function math.round(num)
    if num >= 0 then
        return math.floor(num + 0.5)
    end
    return math.ceil(num - 0.5)
end

--- Check if a point r is in the segment pq
-- @param p Start point of segment
-- @param q End point of segment
-- @param r Point to check
function math.onsegment(p, q, r)
	return r.x <= math.max(p.x, q.x) and r.x >= math.min(p.x, q.x) and
	       r.y <= math.max(p.y, q.y) and r.y >= math.min(p.y, q.y)
end

--- Check if a point p is equals q
function math.pointequals(p, q)
	return p.x == q.x and p.y == q.y
end

--- TABLE UTILITIES

function table.val_to_str ( v )
	if "string" == type( v ) then
		v = string.gsub( v, "\n", "\\n" )
		if string.match( string.gsub(v,"[^'\"]",""), '^"+$' ) then
			return "'" .. v .. "'"
		end
		return '"' .. string.gsub(v,'"', '\\"' ) .. '"'
	else
		return "table" == type( v ) and table.tostring( v ) or
		tostring( v )
	end
end

function table.key_to_str ( k )
	if "string" == type( k ) and string.match( k, "^[_%a][_%a%d]*$" ) then
		return k
	else
		return "[" .. table.val_to_str( k ) .. "]"
	end
end

function table.tostring( tbl )
	local result, done = {}, {}
	for k, v in ipairs( tbl ) do
		table.insert( result, table.val_to_str( v ) )
		done[ k ] = true
	end
	for k, v in pairs( tbl ) do
		if not done[ k ] then
		table.insert( result,
			table.key_to_str( k ) .. "=" .. table.val_to_str( v ) )
		end
	end
	return "{" .. table.concat( result, "," ) .. "}"
end

--- Module to represent file system in node tree
files = {}

--- Create new node file
-- @tparam string name Name of node
-- @tparam string path Absolute path of node
-- @tparam table source Table where load resources
-- @tparam string source_name Name of table source (I use it like table key)
function files.new_node(name, path, source, source_name)
	return {
		path = path,
		name = name,
		source = source,
		source_name = source_name,
		next = nil,
		parent = nil
	}
end

--- Get all children nodes of a node
-- @tparam table node Parent node
function files.get_children(node)
	-- Get children list
	local list = love.filesystem.getDirectoryItems(node.path)
	-- Last used node (To set in next variable)
	local last_node = nil
	-- First child
	local first_node = nil
	
	-- Iterate element list
	for pos, name in ipairs(list) do
		local dot = name:find("%.")
		-- Remove extension
		if dot then source_name = name:sub(1, dot - 1) else source_name = name end
		
		-- Create table in source table
		node.source[source_name] = {}
		
		-- New child node
		new_child = files.new_node(name, node.path .. "/" .. name, node.source[source_name], source_name)
		new_child.parent = node
		
		-- Check if is first node or other
		if last_node == nil then
			first_node = new_child
		else
			last_node.next = new_child
		end
		
		-- Update last node
		last_node = new_child
	end
	
	return first_node
end

--- Get next node
--@tparam table node Node to get next node
function files.next(node)
	while node.parent ~= nil do
		if node.next ~= nil then
			return node.next
		else
			node = node.parent
		end
	end
	
	return nil
end

--- Load one resource node at time
-- @tparam table node Node with represents resource node
-- @tparam string type Type or resource: "img" to load texture resources and "snd" to load sound resources
-- @treturn table Next node to load
function files.load_node(node, type)
	-- If current node is a directory
	if love.filesystem.isDirectory(node.path) then
		-- Move to children list
		return files.get_children(node)
	-- If current node is a file
	elseif love.filesystem.isFile(node.path) then
		print("Loading " .. node.path .. "...")
		
		-- Load texture resource
		if type == "img" then
			node.parent.source[node.source_name] = love.graphics.newImage(node.path)
			node.parent.source[node.source_name]:setFilter("nearest")
		-- Load sound resource
		elseif type == "snd" then
			node.parent.source[node.source_name] = love.audio.newSource(node.path)
		end
		
		return files.next(node)
	-- If isn't a directory or a file, skip it
	else
		return files.next(node)
	end
end

--- Get fullname of source
-- @param source Object source to get name
function files.get_full_name(source)
	-- Recursive function to get full name
	function get_name(src_table)
		for key, value in pairs(src_table) do
			-- If a table, iterate this table to
			if type(value) == "table" then 
				name = get_name(value)
				-- Value obtain, back
				if name ~= nil then 
					return key .. "." .. name
				end
			end
			
			-- If source is pointed like value, get this key
			if value == source then return key end
		end
		
		return nil
	end
	
	-- If is a image
	if source:typeOf("image") then
		return get_name(img)
	else
		return get_name(snd)
	end
end