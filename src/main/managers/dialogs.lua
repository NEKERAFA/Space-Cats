--- Dialog system prototype.
-- This module constructs a dialog system prototype class
--
-- @classmod src.main.dialog
-- @author	 Rafael Alcalde Azpiazu (NEKERAFA)
-- @license  GNU General Public License v3

local class = require "lib.vrld.hump.class"
local utf8  = require "utf8"

local dialog = class {
	--- Create a new dialog system
	-- @tparam dialog self New dialog object
	-- @tparam number delay Delay between words
	-- @tparam boolean auto Set dialogs that change automatic
	-- @tparam table codes Table with scancodes to control dialogs, where 'next' key has scancode to pass dialog and 'auto' key has scancode to put dialogs automatic
	init = function(self, delay, auto, codes)
		self.script = {}
		self.current_line = {message = ""}
		self.max_delay = delay or 16
		self.delay = 0
		self.auto = auto or false
		self.codes = codes or {next = "return", auto = "space"}
	end,
	
	--- Add new charater line to script
	-- @tparam dialog self Dialog system
	-- @tparam string title Title of new message. Put the name of charater
	-- @tparam string message The text that character said
	add_line = function(self, title, message)
		table.insert(self.script, {title = title, message = message})
	end,

	--- Add more text to script. Use this if you can add more lines to a character.
	-- @tparam dialog self Dialog system
	-- @tparam string message The text that character said
	add_text = function(self, message)
		table.insert(self.script, {message = message})
	end,
	
	-- Update dialog variables
	-- @tparam dialog self Dialog system
	-- @tparam number dt Time since the last update in seconds
	-- @treturn boolean True if have new word, false in other case
	update = function(self, dt)
		if #self.script > 0 then
			-- Update title time
			self.delay = self.delay + dt
			
			-- Check if top script have title text to pop new world
			if self.delay > 1/self.max_delay then
				self.delay = self.delay - 1/self.max_delay
				-- Pop from title
				if self.script[1].title	then
					-- Get word offset
					offset_word = utf8.offset(self.script[1].title, 2)
					-- Set new line title if it isn't
					if not self.current_line.title then 
						self.current_line.title = ""
					end
					-- Add new word
					self.current_line.title = self.current_line.title .. self.script[1].title:sub(1, offset_word-1)
					-- Remove word
					self.script[1].title = self.script[1].title:sub(offset_word)
					-- Remove title if it isn't text
					if #self.script[1].title == 0 then
						self.script[1].title = nil
					end
					
					return true
				-- Pop from message
				elseif #self.script[1].message > 0 then
					-- Get world offset
					offset_word = utf8.offset(self.script[1].message, 2)
					-- Add new word
					self.current_line.message = self.current_line.message .. self.script[1].message:sub(1, offset_word-1)
					-- Remove word
					self.script[1].message = self.script[1].message:sub(offset_word)
					-- Remove line if is in auto
					if #self.script[1].message == 0 and self.auto then
						table.remove(self.script, 1)
						self.current_line = {message = ""}
					end
					
					return true
				end
			end
		end
		
		return false
	end,

	--- Update menu variable
	-- @tparam dialog self Dialog system
	-- @tparam KeyConstant key Character of the pressed key
	-- @tparam Scancode scancode The scancode representing the pressed key
	-- @tparam bolean isrepeat Whether this key press event is a repeat. The delay between key depends on the user's system settings
	keypressed = function(self, key, scancode, isrepeat)
		if #self.script > 0 then
			-- Show all line or pass next dialog
			if scancode == self.codes.next then
				-- Complete all title and message
				if self.script[1].title then
					self.current_line.title = self.current_line.title .. self.script[1].title
					self.current_line.message = self.script[1].message
					self.script[1].title = nil
					self.script[1].message = ""
				-- Complete all message
				elseif #self.script[1].message > 0 then
					self.current_line.message = self.current_line.message .. self.script[1].message
					self.script[1].message = ""
				-- Change line
				else
					table.remove(self.script, 1)
					self.current_line = {title = "", message = ""}
				end
			-- Enable/Disable auto
			elseif scancode == self.codes.auto then
				self.auto = not self.auto
			end
		end
	end
}

return dialog