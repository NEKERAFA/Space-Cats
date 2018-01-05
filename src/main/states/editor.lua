--- Definition of level editor functions
--
-- @author	Rafael Alcalde Azpiazu (NEKERAFA)
-- @license GNU General Public License v3

local utf8          = require "utf8"

local gamestate     = require "lib.vrld.hump.gamestate"

local level_manager = require "src.main.managers.levels"
local gui           = require "src.main.managers.interface"

editor = {}

function editor:init()
	tools = gui.hbox({margin = 0, padding = 2})
	
	tools:add(gui.button({icon = img.editor.new}))
	tools:add(gui.button({icon = img.editor.load}))
	tools:add(gui.button({icon = img.editor.save}))
	tools:add(gui.button({icon = img.editor.run}))
	tools:add(gui.input({placeholder = "Map title", width = 190}))
	
	back = gui.button({text = "Back"})
	back.event = function()
		gamestate.switch(menu)
	end
	
	tools:add(back)
	
	level = gui.hbox({margin = 0})
	
	level:add(gui.item(312, 148))
	
	vbox = gui.vbox({margin = 4, padding = 4})
	
	vbox:add(tools)
	vbox:add(level)
	
	editor.layout = gui.layout({margin = 0})
	
	editor.layout:add(vbox)
end

function editor:leave()
	gui.release(editor.layout)
end

function editor:keypressed(key, scancode)
	gui.keypressed(editor.layout, scancode)
end

function editor:keyreleased(key, scancode)
	gui.keyreleased(editor.layout, scancode)
end

function editor:mousepressed(x, y, button)
	gui.mousepressed(editor.layout, x, y, button)
end

function editor:mousereleased(x, y, button)
	gui.mousereleased(editor.layout, x, y, button)
end

function editor:textinput(text)
	gui.textinput(editor.layout, text)
end

function editor:draw()
	gui.draw(editor.layout)
end