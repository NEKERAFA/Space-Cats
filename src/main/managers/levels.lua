--- Level manager prototype.
-- This module constructs a level manager prototype class
--
-- @classmod src.main.level
-- @author	 Rafael Alcalde Azpiazu (NEKERAFA)
-- @license  GNU General Public License v3

local class       = require "lib.vrld.hump.class"
local vector      = require "lib.vrld.hump.vector"
local mouse       = require "src.main.entities.ships.mouse"
local small_mouse = require "src.main.entities.ships.small_mouse"

local level = class {
	--- Path where levels are saved
	save_path = love.filesystem.getSaveDirectory() .. "/levels",
	
	--- Load new file level and put like current level
	-- @tparam level self Level manager
	-- @tparam string path Path to level file
	load = function(self, path)
		-- Open level file
		level_file, msg = io.open(path)
		
		-- Check level file exist
		if level_file == nil then
			error("Error loading level. " .. msg, 2)
		end
		
		-- Read level data
		level_data = level_file:read("*a")
		
		-- Check if level file is empty
		if #level_data == 0 then
			error("Error reading level. Level file is empty", 2)
		end
		
		-- Load level chunk
		level_chunk, msg = loadstring("return " .. level_data)
		
		-- Check if chuck are loaded
		if level_chunk == nil then
			error("Error parsing level. " .. msg, 2)
		end
		
		-- Save values
		self = level_chunk()
		self.entities_stacked = #self.entities
		self.poped_entities_destroyed = true
		self.delta_time = 0
	end,

	--- Save current level into a file in save directory. Check löve documentation to know save directory
	-- @tparam level self Level manager
	-- @tparam string name Name of new level
	save = function(self, name)
		-- Check variable levels
		if self.bgi == nil or self.bgm == nil or self.stars == nil or
		   self.objetive == nil or self.entities == nil or #self.entities == 0 then
			error("Error: Level not initialized", 2)
		end
		
		-- Create save directory if isn't exists
		if not love.filesystem.exists(level.save_path) then
			love.filesystem.createDirectory(level.save_path)
		end
		
		level_file = io.open(level.save_path .. "/" .. name, "w+")
		
		level_file:write("{\n")
		-- Level arguments
		level_file:write("\tbgi = " .. files.get_full_name(level.bgi) .. ",\n")
		level_file:write("\tbgm = " .. files.get_full_name(level.bgm) .. ",\n")
		level_file:write("\tstars = " .. level.stars .. ",\n")
		level_file:write("\tobjetive = \"" .. level.objetive .. "\",\n")
		level_file:write("\entities = {\n")
		for pos, entity in ipairs(level.entities) do
			-- Entities co-arguments
			level_file:write("\t\t{\n")
			level_file:write("\t\t\ttype = \"" .. entity.type .. "\",\n")
			level_file:write("\t\t\twait = \"" .. entity.wait .. "\",\n")
			level_file:write("\t\t\ttime = " .. entity.time .. "\",\n")
			level_file:write("\t\t\targs = " .. table.tostring(entity) .. "\n")
			
			if pos < level.entities_stacked then
				level_file:write("\t\t},\n")
			else
				level_file:write("\t\t}\n")
			end
		end
		level_file:write("\t}\n}")
		
		level_file:flush()
		level_file:close()
	end,

	--- Create new mouse
	create_mouse = function(entity)
		from    = vector(entity.args[1].x, entity.args[1].y)
		to      = vector(entity.args[2].x, entity.args[2].y)
		pointed = game.player
		return mouse(from, to, pointed)
	end

	--- Pop new entity from stack level
	-- @tparam level self Level manager
	-- @treturn entity New entity to add level if it can poped or nil in other case
	pop_entity = function(self)

	end,

	--[[ Add new entity to level structure
	-- tparam level self Level manager
	-- tparam string Type entity type
	-- tparam boolean wait If is true, this entity must wait to pop until all previous entities are destroyed
	-- tparam number time Time to pop between previus entity
	-- param ... Arguments to pass when entity will be created (See pop_entity)
	add_entity = function(self, type, wait, time, ...)
	end,
	]]

	--- Free all level variables an remove current level from level manager
	-- @tparam level self Level manager
	free = function(self)
		-- Clear entities table
		if self.entities ~= nil then
			while self.entities_stacked > 0 then
				table.remove(self.entities, self.entities_stacked)
				self.entities_stacked = self.entities_stacked - 1
			end
		end
		
		-- Clear variables
		self.bgi = nil
		self.bgm = nil
		self.stars = nil
		self.objetive = nil
		self.entities = nil
		self.entities_stacked = nil
		self.poped_entities_destroyed = nil
		self.delta_time = nil
		
		collectgarbage("collect")
	end
}

return level