local class = require "lib.vrld.hump.class"

local item = class {
	init = function(self, width, height)
		self.x = 0
		self.y = 0
		self.width = width or 4
		self.height = height or 4
		self.type = "item"
	end,
	
	draw = function(self)
		love.graphics.setColor(255, 0, 0)
		love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
	end
}

return item