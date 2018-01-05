--- Text input box interface prototype object.
--
-- @classmod src.main.ui.input
-- @see      src.main.manager.interface
-- @author	 Rafael Alcalde Azpiazu (NEKERAFA)
-- @license  GNU General Public License v3

local class = require "lib.vrld.hump.class"

local input = class {
	--- Create new text input box object
	-- @tparam button self New button object
	-- @tparam table flags Table with flags value of new text input: text, placeholder, width, height, padding between text, border, background, pressed_background, color, placeholder_color, cursor
	init = function(self, flags)
		self.x = 0
		self.y = 0
		
		self.text = {next = love.graphics.newText(app.font, "")}
		self.string = {next = ""}
		
		if flags and flags.text then
			self.text.prev = love.graphics.newText(app.font, flags.text)
			self.string.prev = flags.text
		else
			self.text.prev = love.graphics.newText(app.font, "")
			self.string.prev = ""
		end
		
		if flags and flags.placeholder then
			self.placeholder = love.graphics.newText(app.font, flags.placeholder)
		end
		
		if flags and flags.padding then
			self.padding = flags.padding
		else
			self.padding = 2
		end
		
		local m_text = love.graphics.newText(app.font, "mm") 
		
		local min_width, min_height = self.padding*2 + m_text:getWidth(), self.padding*2 + m_text:getHeight()
		
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
		
		if flags and flags.placeholder_color then
			self.placeholder_color = flags.placeholder_color
		else
			self.placeholder_color = {128, 128, 128}
		end
		
		if flags and flags.cursor then
			self.cursor = flags.cursor
		else
			self.cursor = {0, 0, 0}
		end

		self.type = "input"
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
		
		-- Cut dimensions
		local x_cut = (self.x + self.padding) * app.scalefactor
		local y_cut = (self.y + self.padding) * app.scalefactor
		local width_cut = (self.width - self.padding * 2) * app.scalefactor
		local height_cut = (self.height - self.padding * 2) * app.scalefactor
		
		love.graphics.setScissor(x_cut, y_cut, width_cut, height_cut)
		
		-- Draw placeholder
		if self.placeholder and self.string.prev == "" and self.string.next == "" then
			love.graphics.setColor(self.placeholder_color)
			love.graphics.draw(self.placeholder, self.x + self.padding, self.y + self.height/2 - self.placeholder:getHeight()/2)
		-- Draw text
		else
			local offset = math.max(0, self.text.prev:getWidth() - self.width + self.padding * 2)
			
			love.graphics.setColor(self.color)
			love.graphics.draw(self.text.prev, self.x + self.padding - offset, self.y + self.padding)
			love.graphics.draw(self.text.next, self.x + self.padding + self.text.prev:getWidth() - offset, self.y + self.padding)
		end
		
		-- Draw cursor
		if self.focus then
			local offset = math.max(self.padding, self.text.prev:getWidth() - self.width + self.padding)
			local x = math.min(self.x + self.padding * 2 - offset + self.text.prev:getWidth(), self.x + self.width - self.padding * 2)
			love.graphics.setColor(self.cursor)
			love.graphics.rectangle("fill", x, self.y + self.padding, 1, self.height - self.padding * 2)
		end
		
		love.graphics.setScissor()
	end
}

return input