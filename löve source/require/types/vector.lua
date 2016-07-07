--[[
	Created by NEKERAFA on fri 2 jul 2016 13:10 (CEST)
	License by Creative Commons Attribution-ShareAlike 4.0
	http://creativecommons.org/licenses/by-sa/4.0/
	
	**** MODULE VECTOR ****
	
	vector.new( ... ) : vector
	-- Create a new vector
	
	vector:module() : number
	-- Return module

	vector:x() : number
	-- Return coordenate x

	vector:y() : number
	-- Return coordenate y

	vector:angle() : number
	-- Return angle vector

	vector:show() : nil
	-- Render a vector
]]

local point = require "require/types/point"

vector = {}

function vector.new(...)
	local arg = {...}
	local from 
	local x
	local y
	
	if #arg < 1 then error("Too few arguments in vector.new()", 2)
	elseif #arg > 3 then error("Too much arguments in vector.new()", 2) end
	
	if #arg == 1 then
		if type(arg[1]) ~= "table" then
			error("Bad argument #1 in vector.new(). Expected table, got "..type(arg[1]), 2)
		elseif #arg[1] ~= 2 then
			error("Bad argument #1 in vector.new(). Table must be 2 index, got "..#arg[1], 2)
		elseif (type(arg[1][1]) ~= "number") or (type(arg[1][2]) ~= "number") then
			error("Bad argument #1 in vector.new(). Table must be 2 number index content", 2)
		end
		
		from = point.new(0,0)
		x = arg[1][1]
		y = arg[1][2]
	elseif #arg == 2 then
		if arg[1].type and (arg[1]:type() == "vector") and (type(arg[2]) == "number") then
			from = arg[1]:origin()
			x = arg[2]*math.cos(arg[1]:angle())
			y = arg[2]*math.sin(arg[1]:angle())
		elseif arg[1].type and (arg[1]:type() == "point") and arg[2].type and (arg[2]:type() == "point") then
			from = arg[1]
			x = arg[2]:x()-arg[1]:x()
			y = arg[2]:y()-arg[1]:y()
		elseif not arg[1].type then
			error("Bad argument #1 in vector.new(). Expected vector or point, got "..type(arg[1]), 2)
		elseif not arg[2].type or (type(arg[2]) ~= "number") then
			error("Bad argument #2 in vector.new(). Expected point or number, got "..type(arg[2]), 2)
		end
	elseif #arg == 3 then
		if not arg[1].type then
			error("Bad argument #1 in vector.new(). Expected point, got "..type(arg[1]), 2)
		elseif arg[1].type() ~= "point" then
			error("Bad argument #1 in vector.new(). Expected point, got "..arg[1]:type(), 2)
		elseif not arg[2].type then
			error("Bad argument #2 in vector.new(). Expected point, got "..type(arg[2]), 2)
		elseif arg[1].type() ~= "point" then
			error("Bad argument #2 in vector.new(). Expected point, got "..arg[2]:type(), 2)
		elseif type(arg[3]) ~= "number" then
			error("Bad argument #3 in vector.new(). Expected point, got "..type(arg[3]), 2)
		end
		
		local angle = math.atan2(arg[2]:y()-arg[1]:y(), arg[2]:x()-arg[1]:x())
		from = arg[1]
		x = arg[3]*math.cos(angle)
		y = arg[3]*math.sin(angle)
	end
	
	public = {}
	
	function public:magnitude()
		return math.sqrt(x^2+y^2)
	end
	
	function public:x()
		return x
	end

	function public:y()
		return y
	end
	
	function public:origin()
		return point.new(from:x(), from:y())
	end
	
	function public:angle()
		return math.atan2(y, x)
	end
	
	function public:show()
		local size = love.graphics.getPointSize()
		local width = love.graphics.getLineWidth()
		local style = love.graphics.getLineStyle()
		local r,g,b,a = love.graphics.getColor()
		love.graphics.setLineWidth(1)
		love.graphics.setLineStyle("smooth")
		love.graphics.setPointSize(5)
		love.graphics.setColor(32, 128, 255, 255)
		love.graphics.line(from:x(), from:y(), from:x()+x, from:y()+y)
		love.graphics.points(from:x()+x, from:y()+y)
		love.graphics.setPointSize(size)
		love.graphics.getLineWidth(width)
		love.graphics.setLineStyle(style)
		love.graphics.setColor(r, g, b, a)
	end
	
	function public:type()
		return "vector"
	end
	
	return public
end

return vector