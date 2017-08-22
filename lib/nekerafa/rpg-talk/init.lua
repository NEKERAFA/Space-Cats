--- RPG Talk
-- RPG dialogues manager for LÖVE
--
-- @module rpg-talk
-- @author Rafael Alcalde Azpiazu
-- @release 0.1
-- @license MIT License

rpg_talk = {
	_VERSION = "0.1",
	_AUTHOR = "Rafael Alcalde Azpiazu",
	_DESCRIPTION = "RPG dialogues manager for LÖVE",
	_URL = "https://github.com/NEKERAFA/rpg-talk",
	_LICENSE = [[MIT License

	Copyright (c) 2017 Rafael Alcalde Azpiazu

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all
	copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
	SOFTWARE.]],
}

local current_module = (...):gsub("%.init$", "")

local tastytext = require("lib.nekerafa.rpg-talk.tastytext")
local timer = require("lib.vrld.hump.timer")

local manager = {}

-- Check if an argument is a concrete type
function manager.check_argument(name, arg, type_arg, pos)	
	if type(arg) ~= type_arg then
		error("bad argument #" .. pos .. " to " .. name .. " (" .. type_arg .. " expected, got " .. type(arg) .. ")", 3)
	end
end

-- Check if an love argument is a concrete type
function manager.check_love_argument(name, arg, type_arg, pos)
	if not arg:typeOf(type_arg) then
		error("bad argument #" .. pos .. " to " .. name .. " (" .. type_arg .. " expected, got " .. arg:type() .. ")", 3)
	end
end

-- Return new in tween animation
function manager.in_trasition(target, character_table)
	local objetive = {}
	
	-- Set alpha value
	if manager.transition:find("fade") then
		objetive.alpha = 255
	end
	
	-- Set replace value
	if manager.transition:find("replace") and character_table.align == "left" then
		objetive.x = manager.margin
	elseif manager.transition:find("replace") and character_table.align == "right" then
		objetive.x = manager.width-manager.margin-character_table.image:getWidth()
	end
	
	timer.new(0.5, target, objetive, "out-quad")
end

-- Return new out tween animation
function manager.out_trasition(target, character_table)
	local objetive = {}
	
	-- Set alpha value
	if manager.transition:find("fade") then
		objetive.alpha = 0
	end
	
	-- Set replace value
	if manager.transition:find("replace") and character_table.align == "left" then
		objetive.x = -character_table.image:getWidth()
	elseif manager.transition:find("replace") and character_table.align == "right" then
		objetive.x = manager.width+character_table.image:getWidth()
	end
	
	timer.new(0.5, target, objetive, "in-quad")
end

-- Add new image to character table
function manager.new_character_image(character_table)
	-- Check if character has an old image
	if #manager.characters[character_table.align] == 1 then
		character = manager.characters[character_table.align][1]
		character.tween = manager.out_trasition(character, character_table)
		character.remove = true
	end

	-- New charater image
	local character = {
		alpha = 0,
		image = character_table.image,
		remove = false,
	}
	
	if character_table.align == "left" then
		character.x = -character_table.image:getWidth()
	elseif character_table.align == "right" then
		character.x = manager.width + character_table.image:getWidth()
	end
	
	character.tween = manager.in_trasition(character, character_table)
	
	table.insert(manager.characters[character_table.align], character)
end

-- Pop a dialogue line from script table and put it in current dialogue
function manager.pop_line()
	-- Pop dialogue
	manager.dialogue = manager.script[1].text
	-- Add new image
	if manager.script[1].image then
		manager.new_character_image(manager.script[1])
	end
end

-- Push a dialogue from script table
function manager.push_line(text, character, image, align)
	text = "<text>" .. text
	
	if character ~= nil then
		text = "<character>" .. character .. "\n" .. text
	end
	
	local warp = manager.width - manager.margin * 2
	
	if image and manager.format == "icon" then
		warp = warp - image:getWidth() - manager.margin
	end
	
	local interline = manager.font:getHeight()
	
	dialogue = tastytext.new(text, warp, manager.font, manager.tags, interline)
	
	local dialogue_max = manager.height - manager.margin * 2
	local dialogue_height = dialogue.lines * dialogue.line_height
	
	if dialogue_height > dialogue_max then
		error("dialog text exceeds dialogue height box (maximun " .. dialogue_max .. ", got " .. dialogue_height .. ")", 3)
	end
	
	dialogue:setSub(1, 0)
	manager.lines = manager.lines + 1
	table.insert(manager.script, {text = dialogue, character = character, image = image, align = align})
end

-- Draw character images
function manager.draw_characters(align)
	local pos, max = 1, #manager.characters[align]
	
	while pos <= max do
		--  Get character
		local character = manager.characters[align][pos]
		
		-- Get alpha value
		local alpha = 255
		if manager.transition:find("fade") then
			alpha = character.alpha
		end
		-- Set color to print
		if pos < max then
			love.graphics.setColor(128, 128, 128, alpha)
		else
			love.graphics.setColor(255, 255, 255, alpha)
		end
		-- Get x position
		local x = manager.margin
		if manager.transition:find("replace") then
			x = character.x
		end
		-- Draw character image
		if manager.format == "background" then
			love.graphics.draw(character.image, x, - character.image:getHeight() + manager.height)
		elseif manager.format == "icon" then
			love.graphics.draw(character.image, x, manager.height/2 - character.image:getHeight()/2)
		end
		pos = pos+1
	end
end

--- Initialize manager variables
-- @tparam number cps Characters per second showed. 16 by default
-- @tparam boolean skip Set auto skip. false by default
-- @tparam number delay Delay of auto skip dialogue in seconds. 2 by default
-- @tparam Font font Font used to print dialogue. 14 pixel LÖVE standard by default
-- @tparam ImageFormat format Format of charater image. "background" (default) for a complete character image and "icon" for small character image.
-- @tparam ImageTransition transition Transition between character image. "fade" (default), "replace" and "fade-replace".
function rpg_talk.init(cps, skip, delay, font, format, transition)
	if cps == nil then
		cps = 16
	else
		manager.check_argument("init", cps, "number", 1)
	end
	
	if skip == nil then
		skip = false
	else
		manager.check_argument("init", skip, "boolean", 2)
	end

	if delay == nil then
		delay = 2
	else
		manager.check_argument("init", delay, "number", 3)
	end
	
	if font == nil then
		font = love.graphics.newFont(14)
	else
		manager.check_love_argument("init", font, "Font", 4)
	end

	if format == nil then
		format = "background"
	else
		manager.check_argument("init", format, "string", 5)
		if format ~= "background" and format ~= "icon" then
			error("bad argument #5 to init (must be \"background\" or \"icon\" string)", 2)
		end
	end

	if transition == nil then
		transition = "fade"
	else
		manager.check_argument("init", transition, "string", 6)
		if transition ~= "fade" and transition ~= "replace" and transition ~= "fade-replace" then
			error("bad argument #6 to init (must be \"fade\", \"replace\" or \"fade-replace\" string)", 2)
		end
	end

	manager.script = {}
	manager.characters = {left = {}, right = {}}
	manager.tags = {
		character = {192, 192, 192},
		text = {255, 255, 255}
	}
	manager.lines = 0
	manager.cps = cps
	manager.skip = skip
	manager.delay = delay
	manager.delta = 0
	manager.bg = {0, 0, 0, 128}
	manager.width = love.window.getMode()
	manager.height = 60
	manager.font = font
	manager.format = format
	manager.transition = transition
	manager.margin = 5
	manager.interline = 5
	manager.scale = 1
end

--- Set characters per second value
-- @tparam number cps Characters per second showed
function rpg_talk.setCPS(cps)
	manager.check_argument("setCPS", skip, "number", 1)
	manager.cps = cps
end

--- Set delay of auto skip
-- @tparam number delay Delay of auto skip dialogue in seconds
function rpg_talk.setDelay(delay)
	manager.check_argument("setDelay", delay, "number", 1)
	manager.delay = delay
end

--- Set auto skip
-- @tparam boolean skip Set auto skip
function rpg_talk.setSkip(skip)
	manager.check_argument("setSkip", skip, "boolean", 1)
	manager.skip = skip
end

--- Set dialogue background
-- @param bg A table with rgba color or a Image object
function rpg_talk.setBackground(bg)
	ok, err = pcall(manager.check_love_argument, "setBackground", bg, "Image", 1)
	if not ok and err:find("bad argument #1 to setBackground (Image expected") then
		error(err, 2)
	elseif not ok then
		manager.check_argument("setBackground", bg, "table", 1)
		manager.width = love.window.getMode()
		manager.height = 60
	else
		manager.width = bg:getWidth()
		manager.height = bg:getHeight()
	end
	manager.bg = bg
end

--- Set width of colored background
-- @tparam number width Width of background
function rpg_talk.setWidth(width)
	manager.check_argument("setWidth", width, "number", 1)
	manager.width = width
end

--- Set height of colored background
-- @tparam number height Heigth of background
function rpg_talk.setHeight(height)
	manager.check_argument("setHeight", height, "number", 1)
	manager.height = height
end

--- Set dialogue font
-- @tparam Font font Font to be used in dialogue text
function rpg_talk.setFont(font)
	manager.check_love_argument("setFont", font, "Font", 1)
	manager.font = font
end

--- Set text color
-- @tparam table color A table with rgba color
function rpg_talk.setColor(color)
	manager.check_argument("setColor", color, "table", 1)
	manager.tags.text = color
end

--- Set character color
-- @tparam table color A table with rgba color
function rpg_talk.setCharacterColor(color)
	manager.check_argument("setCharacterColor", color, "table", 1)
	manager.tags.character = color
end

--- Set format of character image
-- @tparam ImageFormat format "background" for a complete character image or "icon" for small character image.
function rpg_talk.setImageFormat(format)
	manager.check_argument("setImageFormat", format, "string", 1)
	if format ~= "background" and format ~= "icon" then
		error("bad argument #1 to setImageFormat (must be \"background\" or \"icon\" string)", 2)
	end
	if manager.format ~= format then
		manager.characters = {left = {}, right = {}}
	end
	manager.format = format
end

--- Set transition of character image
-- @tparam ImageTransition transition "fade" (default), "replace" or "fade-replace"
function rpg_talk.setImageTransition(transition)
	manager.check_argument("setImageTransition", transition, "string", 1)
	if transition ~= "fade" and transition ~= "replace" and transition ~= "fade-replace" then
		error("bad argument #1 to setImageFormat (must be \"fade\", \"replace\" or \"fade-replace\" string)", 2)
	end
	manager.transition = transition
end

--- Set margin of dialogue box
-- @tparam number margin Margin of dialogue box in pixel
function rpg_talk.setMargin(margin)
	manager.check_argument("setMargin", margin, "number", 1)
	manager.margin = margin
end

--- Set interline of text in dialogue box
-- @tparam number interline Interline of dialogue box in pixel
function rpg_talk.setInterline(interline)
	manager.check_argument("setInterline", interline, "number", 1)
	manager.interline = interline
end

--- Set scale factor of dialogue box. Used in low-graphics representation
-- @tparam number scale Scale of dialogue box
function rpg_talk.setScale(scale)
	manager.check_argument("setScale", scale, "number", 1)
	manager.scale = scale
	if not manager.bg.typeOf then
		manager.width = love.window.getMode()/scale
	end
end

--- Check if manager script is empty
function rpg_talk.isEmpty()
	return manager.lines == 0
end

--- Get if auto skip is enabled
function rpg_talk.isSkip()
	return manager.skip == true
end


--- Get current characters per second value
function rpg_talk.getCPS()
	return tonumber(manager.cps)
end

--- Get current delay of auto skip
function rpg_talk.getDelay()
	return tonumber(manager.delay)
end

--- Get width of current background
function rpg_talk.setWidth()
	return tonumber(manager.width)
end

--- Get height of current background
function rpg_talk.getHeight()
	return tonumber(manager.height)
end

--- Get current format of character image
function rpg_talk.getImageFormat()
	return tostring(manager.format)
end

--- Get current transition of character image
function rpg_talk.getImageTransition()
	return tostring(manager.transition)
end

--- Get current margin of dialogue box
function rpg_talk.getMargin()
	return tostring(manager.margin)
end

--- Get current interline of text in dialogue box
function rpg_talk.getInterline()
	return tostring(manager.interline)
end

--- Get current scale factor of dialogue box
function rpg_talk.getScale()
	return tostring(manager.scale)
end

--- Get current number of lines in script dialogue
function rpg_talk.getLines()
	return tonumber(manager.lines)
end

--- Add new tag to text.
-- RPG Talk uses tastytext for printing dialogue text, and this library permits tags in text using &lt;tag&gt; element. By default are defined &lt;title&gt; and &lt;text&gt;
-- @tparam string name Name of tag
-- @param text Value of text tag
function rpg_talk.addTag(name, text)
	manager.tags[name] = text
end

--- Add new character line to script
-- @tparam string text The text that character said
-- @tparam string character Name of character. Optional
-- @tparam Drawable image Image of character. Optional
-- @tparam Align align Align of character used in background format.
function rpg_talk.addLine(text, character, image, align)
	manager.check_argument("addLine", text, "string", 1)
	if character ~= nil then
		manager.check_argument("addLine", character, "string", 2)
	end
	if image ~= nil then
		manager.check_love_argument("addLine", image, "Image", 3)
		manager.check_argument("addLine", align, "string", 4)
		
		if align ~= "left" and align ~= "right" then
			error("bad argument #4 to aling (must be \"left\" or \"right\" string)", 3)
		end
		
		if manager.format == "icon" then
			align = "left"
		end
	end
	-- Create new text object
	manager.push_line(text, character, image, align)
end

--- Clear all dialogs
function rpg_talk.clear()
	manager.dialogue = nil
	manager.characters = {left = {}, right = {}}
	manager.script = {}
	manager.lines = 0
end

--- Skip current dialogue line
function rpg_talk.skip()
	if manager.lines > 0 and manager.dialogue then
		-- Complete all title and message
		if manager.dialogue.last < manager.dialogue.length then
			manager.dialogue:setSub(1, manager.dialogue.length)
		-- Change line
		else
			table.remove(manager.script, 1)
			manager.lines = manager.lines - 1
			manager.dialogue = nil
			manager.delta = 0
		end
	end
end

--- Update dialogue variables
-- @tparam number dt Time since the last update in seconds
-- @treturn boolean True if have new word, false in other case
function rpg_talk.update(dt)
	if manager.lines > 0 then
		-- Update delta time
		manager.delta = manager.delta + dt
		-- Pop new dialogue if it isn't poped
		if manager.dialogue == nil then
			manager.pop_line()
		end
		-- Check pop word condition
		if (manager.dialogue.last < manager.dialogue.length) and (manager.delta >= 1/manager.cps) then
			manager.dialogue:setSub(1, manager.dialogue.last+1)
			manager.delta = manager.delta - 1/manager.cps
			return true
		end
		-- Check auto skip condition
		if manager.skip and (manager.dialogue.last == manager.dialogue.length) and (manager.delta >= manager.delay) and (manager.lines > 1) then
			rpg_talk.skip()
		end
	end
end

--- Draw current dialogue
-- @tparam number x The position to draw the dialogue (x-axis). 0 by default
-- @tparam number y The position to draw the dialogue (y-axis). Bottom-screen by default
function rpg_talk.draw(x, y)
	if manager.dialogue then
		local r, g, b, a = love.graphics.getColor()
		local width, height = love.window.getMode()
		width = width/manager.scale
		height = height/manager.scale
		
		if x == nil then
			x = width/2 - manager.width/2
		end
		if y == nil then
			y = height - manager.height
		end
		
		-- Change love perspective
		love.graphics.push()
		love.graphics.scale(manager.scale, manager.scale)
		love.graphics.translate(x, y)
		
		-- Draw images
		if manager.format == "background" then
			manager.draw_characters("left")
			manager.draw_characters("right")
		end
		-- Draw background
		if manager.bg.type then
			love.graphics.setColor(255, 255, 255)
			love.graphics.draw(manager.bg, 0, 0)
		else
			love.graphics.setColor(manager.bg)
			love.graphics.rectangle("fill", 0, 0, manager.width, manager.height)
		end
		-- Draw images
		if manager.format == "icon" then
			manager.draw_characters("left")
		end
		-- Draw text
		if manager.format == "icon" and manager.script[1].image then
			love.graphics.translate(manager.margin*2+manager.script[1].image:getWidth(), manager.margin)
		else
			love.graphics.translate(manager.margin, manager.margin)
		end
		love.graphics.setColor(255, 255, 255)
		manager.dialogue:draw()
		love.graphics.pop()
		love.graphics.setColor(r, g, b, a)
	end
end

return rpg_talk