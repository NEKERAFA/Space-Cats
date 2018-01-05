--- Button interface prototype object.
--
-- @classmod src.main.ui.button
-- @see      src.main.manager.interface
-- @author	 Rafael Alcalde Azpiazu (NEKERAFA)
-- @license  GNU General Public License v3

local class = require "lib.vrld.hump.class"

local button = class {
	--- Create new button object
	-- @tparam button self New button object
	-- @tparam table flags Table with flags value of new vertical container: width, height, padding between contain, text, icon, border, background, pressed_background, color
	init = function(self, flags)
		self.x = 0
		self.y = 0
		
		if flags and flags.text then
			self.text = love.graphics.newText(app.font, flags.text)
		end
		
		if flags and flags.icon then
			self.icon = flags.icon
		end
		
		if flags and flags.padding then
			self.padding = flags.padding
		else
			self.padding = 2
		end
		
		local min_width, min_height = self.padding*2, self.padding*2
		
		if self.text then 
			min_width = min_width + self.text:getWidth()
			min_height = min_height + self.text:getHeight()
		end
		
		if self.icon then
			min_width = min_width + self.icon:getWidth()
			min_height = min_height + self.icon:getHeight()
		end
		
		if flags and flags.width then
			self.width = math.max(flags.width, min_width)
		else
			self.width = min_width
		end
		
		if flags and flags.height then
			self.height = math.max(flags.height, min_height)
		else
			self.height = min_height
		end
		
		if flags and flags.border then
			self.border = flags.border
		else
			self.border = {0, 0, 0}
		end
		
		if flags and flags.background then
			self.background = flags.background
		else
			self.background = {255, 255, 255}
		end
		
		if flags and flags.pressed_background then
			self.pressed_background = flags.pressed_background
		else
			self.pressed_background = {224, 224, 224}
		end
		
		if flags and flags.color then
			self.color = flags.color
		else
			self.color = {0, 0, 0}
		end

		self.type = "button"
	end,
	
	--- Draw current button
	-- @tparam button self Button to draw
	draw = function(self)
		-- Draw background
		if self.pressed then
			love.graphics.setColor(self.pressed_background)
		else
			love.graphics.setColor(self.background)
		end
		love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
		-- Draw border
		love.graphics.setColor(self.border)
		love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
		
		local offset_x = 0
		
		if self.icon then
			love.graphics.setColor(255, 255, 255)
			love.graphics.draw(self.icon, self.x + self.padding, self.y + self.height/2 - self.icon:getHeight()/2)
			
			offset_x = self.icon:getWidth()
		end
		
		if self.text then
			love.graphics.setColor(self.color)
			love.graphics.draw(self.text, self.x + self.padding + offset_x, self.y + self.height/2 - self.text:getHeight()/2)
		end
	end
}

return button