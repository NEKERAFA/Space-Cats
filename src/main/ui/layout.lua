--- Layout interface prototype object.
--
-- @classmod src.main.ui.layout
-- @see      src.main.manager.interface
-- @author	 Rafael Alcalde Azpiazu (NEKERAFA)
-- @license  GNU General Public License v3

local class = require "lib.vrld.hump.class"

local layout = class {
	--- Create new layout interface
	-- @tparam layout self New layout object
	-- @tparam table flags Table with flags value of new layout: width, height, homogeneus, margin, background and focus (color tables)
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
			self.margin = 1
		end
		
		if flags and flags.background then
			self.background = flags.background
		else
			self.background = {240, 240, 240}
		end

		if flags and flags.focus then
			self.focus_color = flags.focus
		else
			self.focus_color = {0, 192, 255}
		end

		self.type = "layout"
	end,

	--- Add new child to layout object
	-- @tparam layout self Layout to add child
	-- @tparam object child New child interface object
	add = function(self, child)
		if self.children[1] == nil then
			self.children[1] = child
			
			child.x = self.margin
			child.y = self.margin
			
			-- Calculate child proportions
			-- Static values
			if self.width_type == "static" then
				-- If child width exceeds parent dimensions or parent children is homogeneus
				if self.homogeneus or child.width > self.width - self.margin * 2 then
					child.width = self.width - self.margin * 2
					child.width_type = "static"
				end
			-- Dynamic values
			else
				-- If child width exceeds app width, set it in static mode
				if child.width + self.margin * 2 > app.width - self.margin * 2 then
					self.width = app.width
					child.width = self.width - self.margin * 2
					child.width_type = "static"
				-- Set parent width with child dimensions
				else
					self.width = child.width + self.margin * 2
				end
			end
			
			-- Calculate child proportions
			-- Static values
			if self.height_type == "static" then
				-- If child height exceeds parent dimensions or parent children is homogeneus
				if self.homogeneus or child.height > (self.height - self.margin * 2) then
					child.height = self.height - self.margin * 2
					child.height_type = "static"
				end
			-- Dynamic values
			else
				-- If child height exceeds app height, set it in static mode
				if child.height + self.margin * 2 > app.height - self.margin * 2 then
					self.height = app.height
					child.height = self.height - self.margin * 2
					child.height_type = "static"
				-- Set parent width with child dimensions
				else
					self.height = child.height + self.margin * 2
				end
			end
			
			if child.update then
				child:update()
			end
		end
	end,
	
	--- Iterate all children
	-- @tparam layout self Layout object
	iterate = function(self)
		local iterator = nil
		local pos = 0
		
		-- If children is iterate function, get it like iterator
		if self.children[1] ~= nil and self.children[1].iterate then
			iterator = self.children[1]:iterate()
		end
		
		-- Iterator function
		return function()
			if iterator then
				return iterator()
			else
				pos = pos + 1
				return self.children[pos]
			end
		end
	end
}

return layout