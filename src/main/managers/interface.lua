--- Definition of interface general module
--
-- @author	Rafael Alcalde Azpiazu (NEKERAFA)
-- @license GNU General Public License v3

-- Module interface
local interface = {}

local utf8 = require "utf8"

-- Load elements of interface
interface.layout = require "src.main.ui.layout"
interface.vbox   = require "src.main.ui.vbox"
interface.hbox   = require "src.main.ui.hbox"
interface.button = require "src.main.ui.button"
interface.item   = require "src.main.ui.item"
interface.input  = require "src.main.ui.input"

--- Callback function triggered when a key is pressed
-- @tparam layout layout Layout to update focus
-- @tparam Scancode scancode The scancode representing the pressed key
function interface.keypressed(layout, scancode)
	if layout.focus then
		-- Activate interface element
		if scancode == app.accept then
			layout.focus.pressed = true
			if layout.focus.event then
				layout.focus.event()
			end
		end
		
		-- Move text
		if scancode == "left" and layout.focus.type == "input" then
			-- get the byte offset to the last UTF-8 character in the string
			local byteoffset = utf8.offset(layout.focus.string.prev, -1)
			
			if byteoffset then
				-- remove the last UTF-8 character and put in next characters
				-- string.sub operates on bytes rather than UTF-8 characters, so we couldn't do string.sub(text, 1, -2)
				
				layout.focus.string.next = string.sub(layout.focus.string.prev, byteoffset) .. layout.focus.string.next
				layout.focus.string.prev = string.sub(layout.focus.string.prev, 1, byteoffset - 1)
				
				layout.focus.text.prev:set(layout.focus.string.prev)
				layout.focus.text.next:set(layout.focus.string.next)
			end
		end
		
		if scancode == "right" and layout.focus.type == "input" then
			-- get the byte offset to the last UTF-8 character in the string
			local byteoffset = utf8.offset(layout.focus.string.next, 2)
			
			if byteoffset then
				-- remove the last UTF-8 character and put in prev characters
				-- string.sub operates on bytes rather than UTF-8 characters, so we couldn't do string.sub(text, 1, -2)
				layout.focus.string.prev = layout.focus.string.prev .. string.sub(layout.focus.string.next, 1, byteoffset - 1)
				layout.focus.string.next = string.sub(layout.focus.string.next, byteoffset)
				
				layout.focus.text.prev:set(layout.focus.string.prev)
				layout.focus.text.next:set(layout.focus.string.next)
			end
		end
		
		-- Remove text
		if scancode == "backspace" and layout.focus.type == "input" then
			-- get the byte offset to the last UTF-8 character in the string
			local byteoffset = utf8.offset(layout.focus.string.prev, -1)
	 
			if byteoffset then
				-- remove the last UTF-8 character
				-- string.sub operates on bytes rather than UTF-8 characters, so we couldn't do string.sub(text, 1, -2)
				layout.focus.string.prev = string.sub(layout.focus.string.prev, 1, byteoffset - 1)
				layout.focus.text.prev:set(layout.focus.string.prev)
			end
		end
		
		if scancode == "delete" and layout.focus.type == "input" then
			-- get the byte offset to the last UTF-8 character in the string
			local byteoffset = utf8.offset(layout.focus.string.next, 2)
			
			if byteoffset then
				-- remove the last UTF-8 character and put in prev characters
				-- string.sub operates on bytes rather than UTF-8 characters, so we couldn't do string.sub(text, 1, -2)
				layout.focus.string.next = string.sub(layout.focus.string.next, byteoffset)
				layout.focus.text.next:set(layout.focus.string.next)
			end
		end
	end
end

--- Callback function triggered when a key is released
-- @tparam layout layout Layout to update focus
-- @tparam Scancode scancode The scancode representing the released key
function interface.keyreleased(layout, scancode)
	if layout.focus and scancode == app.accept then
		layout.focus.pressed = false
	end
end

--- Callback function triggered when a mouse button is pressed
-- @tparam layout layout Layout to update focus
-- @tparam number x Mouse x position, in pixels
-- @tparam number y Mouse y position, in pixels
-- @tparam number button The button index that was pressed. 1 is the primary mouse button, 2 is the secondary mouse button and 3 is the middle button. Further buttons are mouse dependent
function interface.mousepressed(layout, x, y, button)
	layout.focus = nil
	local repeat_keys = false
	
	for child in layout:iterate() do
		if button == 1 then
			if x >= child.x and x <= child.x+child.width and y >= child.y and y <= child.y+child.height then
				if child.type == "button" or child.type == "input" then
					child.pressed = true
					child.focus = true
					layout.focus = child
					if child.event then child.event(x, y) end
				end
				
				if child.type == "input" then
					repeat_keys = true
					love.keyboard.setTextInput(true, child.x, child.y, child.width, child.height)
				end
			elseif child.focus then
				child.focus = false
			end
		end
	end
	
	love.keyboard.setKeyRepeat(repeat_keys)
end

--- Callback function triggered when a mouse button is released
-- @tparam layout layout Layout to update focus
-- @tparam number x Mouse x position, in pixels
-- @tparam number y Mouse y position, in pixels
-- @tparam number button The button index that was pressed. 1 is the primary mouse button, 2 is the secondary mouse button and 3 is the middle button. Further buttons are mouse dependent
function interface.mousereleased(layout, x, y, button)
	if layout.focus and layout.focus.pressed then
		layout.focus.pressed = false
	end
end

--- Called when text has been entered by the user
-- @tparam layout layout Layout to update focus
-- @tparam string text The UTF-8 encoded unicode text
function interface.textinput(layout, text)
	if layout.focus and layout.focus.type == "input" then
		layout.focus.string.prev = layout.focus.string.prev .. text
		layout.focus.text.prev:set(layout.focus.string.prev)
	end
end

--- Called when layout release, to clear all contain
function interface.release(layout)
	for child in layout:iterate() do
		child.pressed = false
		child.focus = false
		
		if child.type == "input" then
			child.string.prev = ""
			child.string.next = ""
			child.text.prev:set("")
			child.text.next:set("")
		end
	end
	
	layout.focus = nil
end

--- Draw current layout interface
-- @tparam layout layout Layout interface to draw
function interface.draw(layout)
	love.graphics.setColor(layout.background)
	love.graphics.rectangle("fill", layout.x, layout.y, layout.width, layout.height)
	
	if layout.focus then
		love.graphics.setColor(layout.focus_color)
		love.graphics.rectangle("fill", layout.focus.x-1, layout.focus.y-1, layout.focus.width+2, layout.focus.height+2)
	end
	
	for child in layout:iterate() do
		if child.draw then child:draw() end
	end
end

return interface