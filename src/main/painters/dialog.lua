--- This module is resposible for draw dialogs
--
-- @author	 Rafael Alcalde Azpiazu (NEKERAFA)
-- @license  GNU General Public License v3

local dialog = {}

--- Draw dialog
-- @tparam dialog dialog_m Dialog manager object to draw
function dialog.draw(dialog_m)
	if #dialog_m.script > 0 then
		r, g, b, a = love.graphics.getColor()
		
		-- Draw box
		love.graphics.draw(img.hud.dialog, 0, app.height-35)
		
		-- Draw title al message
		if dialog_m.current_line.title then
			love.graphics.setColor(255, 192, 0, 255)
			love.graphics.print(dialog_m.current_line.title, 4, app.height-31)
			love.graphics.setColor(255, 255, 255, 255)
			love.graphics.printf(dialog_m.current_line.message, 4, app.height-21, app.width-8, "left")
		-- Draw message
		else
			love.graphics.setColor(255, 255, 255, 255)
			love.graphics.printf(dialog_m.current_line.message, 4, app.height-31, app.width-8, "left")
		end
		
		love.graphics.setColor(r, g, b, a)
	end
end

return dialog