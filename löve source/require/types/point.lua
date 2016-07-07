--[[
	Created by NEKERAFA on fri 2 jul 2016 13:10 (CEST)
	License by Creative Commons Attribution-ShareAlike 4.0
	http://creativecommons.org/licenses/by-sa/4.0/
	
	**** MODULE POINT ****
	
	point.new( x, y ) : point
	-- Create a new point
	
	point:x() : number
	-- Return coordenate x
	
	point:y() : number
	-- Return coordenate y
	
	point:show() : nil
	-- Render a point
]]

point = {}

function point.new(x, y)
	
	local x = x
	local y = y
	
	-- Metodos públicos
	public = {}
	
	function public:x()
		return x
	end
	
	function public:y()
		return y
	end
	
	function public:show()
		local size = love.graphics.getPointSize()
		local style = love.graphics.getPointStyle()
		local r, g, b, a = love.graphics.getColor()
		love.graphics.setPointSize(4)
		love.graphics.setPointStyle("smooth")
		love.graphics.setColor(32, 128, 255, 255)
		love.graphics.point(x, y)
		love.graphics.setPointSize(size)
		love.graphics.setPointStyle(style)
		love.graphics.setColor(r, g, b, a)
	end

	function public:type()
		return "point"
	end

	return public
end

return point