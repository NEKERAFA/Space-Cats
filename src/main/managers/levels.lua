--- Level manager prototype.
-- This module constructs a level manager prototype class
--
-- @classmod src.main.level
-- @author	 Rafael Alcalde Azpiazu (NEKERAFA)
-- @license  GNU General Public License v3

local class = require "lib.vrld.hump.class"

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
		lvl = level_chunk()
		
		-- Override variables
		for k, v in pairs(lvl) do
			self[k] = v
		end

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
		level_file:write("\tname = \"" .. level.name .. "\",\n")
		level_file:write("\tbgi = " .. files.get_full_name(level.bgi) .. ",\n")
		level_file:write("\tbgm = " .. files.get_full_name(level.bgm) .. ",\n")
		level_file:write("\tstars = " .. level.stars .. ",\n")
		level_file:write("\tobjetive = \"" .. level.objetive .. "\",\n")
		level_file:write("\tentities = {\n")
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

	--- Pop new entity from stack level
	-- @tparam level self Level manager
	-- @treturn entity New entity to add level if it can poped or nil in other case
	pop_entity = function(self)
		if self.entities_stacked > 0 then
			-- If it are waiting and now we could pop a entity
			if self.entities[1].wait and self.poped_entities_destroyed then
				self.entities[1].wait = false
				self.delta_time = 0
			end
			
			-- If we aren't waiting and delta time is more or equals than entity wait time
			if not self.entities[1].wait and self.delta_time >= self.entities[1].time then
				-- Restart delta time
				self.delta_time = self.delta_time - self.entities[1].time
				-- Remove stacked entities
				self.entities_stacked = self.entities_stacked - 1
				
				-- Check pop condition if next have wait flag
				if self.entities_stacked > 1 and self.entities[2].wait then
					self.poped_entities_destroyed = false
				end
				
				-- Pop entity
				return table.remove(self.entities, 1)
			end
		end
	end,

	--- Update entity variables
	-- tparam level self Level manager
	-- @tparam number dt Time since the last update in seconds
	update = function(self, dt)
		-- Update delta time
		if self.entities_stacked > 0 and not self.entities[1].wait then
			self.delta_time = self.delta_time + dt
		end
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

	--- Check if level is ending
	-- @tparam level self Level manager
	-- @tparam table entities Table with game entities
	-- @treturn boolean True if player finish level giving level objetive
	is_finished = function(self, entities)
		if self.objetive == "finish" and self.entities_stacked == 0 and #entities == 0 then
			return true
		end
		return false
	end,

	--- Free all level variables an remove current level from level manager
	-- @tparam level self Level manager
	free = function(self)
		-- Clear entities table
		if self.entities ~= nil then
			while self.entities_stacked > 0 do
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