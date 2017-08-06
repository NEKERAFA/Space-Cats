-- This module is resposible for draw small mouse enemy ship
--
-- @module painters.ships.small_mouse
-- @author	Rafael Alcalde Azpiazu (NEKERAFA)
-- @license GNU General Public License v3

local weapon_painter = require "src.main.painters.weapon"
local ship_painter   = require "src.main.painters.ship"

-- Module small_mouse
local small_mouse = {}

--- Draw ship textures
-- @tparam small_mouse ship ship to draw
function small_mouse.draw(ship)
	-- Draw bullets
	weapon_painter.draw_bullets(ship.weapon)
	
	if ship.life > 0 then
		-- If ship is damaged, show damaged animation
		-- Get current colors
		local r, g, b, a = love.graphics.getColor()
		
		-- Draw damage effect
		if ship.damaged then
			-- Set effect
			love.graphics.setColor(255, 192, 192, 255)
		end
		
		-- Draw flame and ship
		x = math.round(ship.position.x)
		y = math.round(ship.position.y)
		ship.flame:draw(img.animations.flame_medium, x+24, y, 0, -1, 1, 8, 8)
		love.graphics.draw(img.ships[ship.type], x, y, 0, 1, 1, 16, 16)
		
		-- Reset colors
		love.graphics.setColor(r, g, b, a)
	end
	
	-- Draw hitbox
	if app.debug then
		ship_painter.draw_hitbox(ship)
	end
end

return small_mouse