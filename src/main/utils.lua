--- Some rubish and other things :3
--
-- @author	Rafael Alcalde Azpiazu (NEKERAFA)
-- @license GNU General Public License v3

local vector = require "lib.vrld.hump.vector"

--- Round a number
function math.round(num)
    if num >= 0 then
        return math.floor(num + 0.5)
    end
    return math.ceil(num - 0.5)
end

-- Module stars
stars = {}

-- Create new stars
function stars.new(dir)
	local stars = {}
	
	for i = 1, app.max_stars do
        stars[i] = {
            x = math.random(8, app.width-8),
            y = math.random(8, app.height-8),
            v = vector(dir.x*math.random(2, 8), dir.y*math.random(2, 8)),
			d = dir
        }
    end
	
	return stars
end

-- Update stars
function stars.update(stars, dt)
	for i, star in ipairs(stars) do
		star.x = star.x + star.v.x * app.frameRate * dt
		star.y = star.y + star.v.y * app.frameRate * dt
		
		-- Restart if star throws out the screen
        if star.x < 0 or star.x > app.width or star.y < 0 or star.y > app.height then
			if math.abs(star.d.y) == 0 then
				star.x = app.width
			else
				star.x = math.random(8, app.width-8) * math.abs(star.d.y)
			end
			
			if math.abs(star.d.x) == 0 then
				star.y = app.height
			else
				star.y = math.random(8, app.height-8) * math.abs(star.d.x)
			end
			
            star.v = vector(star.d.x*math.random(2, 8), star.d.y*math.random(2, 8))
        end
	end
end

-- Draw star
function stars.draw(stars)
	for i, star in ipairs(stars) do
		-- Check if star has low velocity
		if (star.v.x ~= 0 and math.abs(star.v.x) < 5) or 
				((star.v.y ~= 0) and math.abs(star.v.y) < 5) then
			love.graphics.draw(img.particles.star, math.round(star.x), math.round(star.y))
		-- Show star with high velocity
		else
			love.graphics.draw(img.particles.star, math.round(star.x), math.round(star.y), 0, 2, 2, 1, 1)
		end
	end
end

-- Module to represent file system in node tree
files = {}

-- Create new node file
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

-- Get children of a node
function files.get_children(node)
	local list = love.filesystem.getDirectoryItems(node.path)
	local last_node = nil
	local first_node = nil
	
	-- Iterate element list
	for pos, name in ipairs(list) do
		local dot = name:find("%.")
		-- Remove extension
		if dot then source_name = name:sub(1, dot - 1) else source_name = name end
		
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

-- Get next node
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

-- Load node
function files.load_node(node, type)
	-- If current node is a directory
	if love.filesystem.isDirectory(node.path) then
		-- Move to children list
		return files.get_children(node)
	-- If current node is a file
	elseif love.filesystem.isFile(node.path) then
		print("Loading " .. node.path .. "...")
		
		if type == "img" then
			node.parent.source[node.source_name] = love.graphics.newImage(node.path)
			node.parent.source[node.source_name]:setFilter("nearest")
		elseif type == "snd" then
			node.parent.source[node.source_name] = love.audio.newSource(node.path)
		end
		
		return files.next(node)
	else
		print("exiting")
		return files.next(node)
	end
end