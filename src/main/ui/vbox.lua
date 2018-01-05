--- Vertical box container interface prototype object.
--
-- @classmod src.main.ui.vbox
-- @see      src.main.manager.interface
-- @author	 Rafael Alcalde Azpiazu (NEKERAFA)
-- @license  GNU General Public License v3

local class = require "lib.vrld.hump.class"

local vbox = class {
	--- Create new vertical container
	-- @tparam vbox self New vertical container object
	-- @tparam table flags Table with flags value of new vertical container: width, height, homogeneus, margin, padding between children
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

		self.type = "vbox"
	end,
	
	--- Add new child to vertical box container
	-- @tparam vbox self Container to add children
	-- @tparam object child Child to add to box container
	add = function(self, child)
		table.insert(self.children, child)

		self:update()
	end,

	--- Update dimensions of vertical box and children. This function could be very slow if there are more children, use only if a child change of size.
	-- @tparam vbox self Vertical box container
	update = function(self)
		local content_height = 0
		local max_width = 0
		
		-- Get maximun width and height of children container
		for pos, child in ipairs(self.children) do
			-- Get maximun width
			if max_width < child.width then
				max_width = child.width
			end
			-- Get height
			if pos < #self.children then
				content_height = content_height + child.height + self.padding
			else
				content_height = content_height + child.height
			end
		end
		
		local offset = 0
		local homogeneus_height = (self.height - self.margin * 2 - (#self.children-1) * self.padding) / #self.children
		
		-- Update all child variables
		for pos, child in ipairs(self.children) do
			-- Static width value
			if self.width_type == "static" then
				-- If child width exceeds parent dimensions or parent children is homogeneus
				if self.homogeneus or child.width > self.width - self.margin * 2 then
					child.width = self.width - self.margin * 2
					child.width_type = "static"
				end
			end
			
			-- Static height value
			if self.width_type == "static" then
				-- If child width exceeds parent dimensions or parent children is homogeneus
				if self.homogeneus or content_height > self.height - self.margin * 2 then
					child.height = homogeneus_height
					child.height_type = "static"
				end
			end
			
			-- Update child position
			if self.align == "center" then
				child.x = self.x + self.margin + (self.width - self.margin*2)/2 - child.width/2
			elseif self.align == "right" then
				child.x = self.x + self.margin + self.width - self.margin*2 - child.width
			else
				child.x = self.x + self.margin
			end

			child.y = self.y + self.margin + offset
			
			-- Update child values
			if child.update then child:update() end
			
			-- New offset
			offset = offset + child.height + self.padding
			
			--print("vbox", pos, child.x, child.y, child.width, child.height)
		end
		
		-- Dynamic width variable
		if self.width_type == "dynamic" then
			-- If width box are smaller than maximun width, update it
			if self.width - self.margin * 2 < max_width then
				self.width = max_width + self.margin * 2
			end
		end
		
		-- Dinamic height variables
		if self.height_type == "dynamic" then
			-- If height box are smaller than height child container, update it
			if self.height - self.margin * 2 < content_height then
				self.height = content_height + self.margin * 2
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

return vbox