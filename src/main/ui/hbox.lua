--- Horizontal box container interface prototype object.
--
-- @classmod src.main.ui.hbox
-- @see      src.main.manager.interface
-- @author	 Rafael Alcalde Azpiazu (NEKERAFA)
-- @license  GNU General Public License v3

local class = require "lib.vrld.hump.class"

local hbox = class {
	--- Create new horizontal container
	-- @tparam hbox self New vertical container object
	-- @tparam table flags Table with flags value of new horizontal container: width, height, homogeneus, margin, padding between children
	init = function(self, flags)
		self.children = {}
		self.x = 0
		self.y = 0

		if flags and flags.width then
			self.width_type = "static"
			self.width = flags.width
		else
			self.width_type = "dynamic"
			self.width = 0
		end

		if flags and flags.height then
			self.height_type = "static"
			self.height = flags.height
		else
			self.height_type = "dynamic"
			self.height = 0
		end

		if flags and flags.homogeneus then
			self.homogeneus = flags.homogeneus
		else
			self.homogeneus = true
		end

		if flags and flags.margin then
			self.margin = flags.margin
		else
			self.margin = 0
		end

		if flags and flags.padding then
			self.padding = flags.padding
		else
			self.padding = 1
		end

		if flags and flags.align then
			self.align = flash.align
		else
			self.align = "center"
		end

		self.type = "hbox"
	end,

	--- Add new child to vertical box container
	-- @tparam vbox self Container to add children
	-- @tparam object child Child to add to box container
	add = function(self, child)
		table.insert(self.children, child)

		self:update()
	end,

	--- Update dimensions of vertical box and children. This function could be very slow if there are more children, use only if a child change of size.
	-- @tparam vbox self Vertical box containers
	update = function(self)
		local content_width = 0
		local max_height = 0
		
		-- Get maximun width and height of children container
		for pos, child in ipairs(self.children) do
			-- Get maximun height
			if max_height < child.height then
				max_height = child.height
			end
			-- Get height
			if pos < #self.children then
				content_width = content_width + child.width + self.padding
			else
				content_width = content_width + child.width
			end
		end
		
		local offset = 0
		local homogeneus_width = (self.width - self.margin * 2 - (#self.children-1) * self.padding) / #self.children
		
		-- Update all child values
		for pos, child in ipairs(self.children) do
			-- Static width value
			if self.width_type == "static" then
				-- If child width exceeds parent dimensions or parent children is homogeneus
				if self.homogeneus or content_width > self.width - self.margin * 2 then
					child.width = homogeneus_width
					child.width_type = "static"
				end
			end
			
			-- Static height values
			if self.width_type == "static" then
				-- If child height exceeds parent dimensions or parent children is homogeneus
				if self.homogeneus or child.height > self.height - self.margin * 2 then
					child.height = self.height - self.margin * 2
					child.height_type = "static"
				end
			end
			
			-- Update child position
			child.x = self.x + self.margin + offset
			
			if self.align == "center" then
				child.y = self.y + self.margin + (self.height - self.margin*2)/2 - child.height/2
			elseif self.align == "right" then
				child.y = self.y + self.margin + self.height - self.margin*2 - child.height
			else
				child.y = self.y + self.margin
			end
			
			-- Update child values
			if child.update then child:update() end
			
			-- New offset
			offset = offset + child.width + self.padding
		end
		
		-- Dynamic width variable
		if self.width_type == "dynamic" then
			-- If width box are smaller than width box container, update it
			if self.width - self.margin * 2 < content_width then
				self.width = content_width + self.margin * 2
			end
		end
		
		-- Dynamic height variable
		if self.height_type == "dynamic" then
			-- If width box are smaller than maximun height, update it
			if self.height - self.margin * 2 < max_height then
				self.height = max_height + self.margin * 2
			end
		end
	end,
	
	--- Iterate all children of box
	-- @tparam vbox self Vertical box object
	iterate = function(self)
		local pos = 1
		local iterator = nil
		
		-- Iterator function
		return function()
			local value = nil
			
			while self.children[pos] ~= nil do
				-- If children are iterator, use it
				if self.children[pos].iterate then
					if iterator == nil then
						iterator = self.children[pos]:iterate()
					end
					
					value = iterator()
					
					-- If finish with child iterator, jump to next position
					if value == nil then
						iterator = nil
						pos = pos + 1
					else
						break
					end
				-- If children aren't iterator, return it
				else
					value = self.children[pos]
					pos = pos + 1
					break
				end
			end
			
			return value
		end
	end,
}

return hbox