--- This module is resposible for draw ship
--
-- @module painters.ship
-- @author	Rafael Alcalde Azpiazu (NEKERAFA)
-- @license GNU General Public License v3

-- Module
local ship = {}

--- Draw hitbox
-- @tparam ship ship Ship to paint hitbox
function ship.draw_hitbox(ship)
	if ship.collider then
		local r, g, b, a = love.graphics.getColor()
		love.graphics.setColor(255, 0, 0, 128)
		ship.collider:draw('fill')
		love.graphics.setColor(r, g, b, a)
	end
end

return ship