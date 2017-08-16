--- This module is resposible for draw ship
--
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

--- Draw explosion
-- @tparam ship ship Ship to paint explosion animation
function ship.draw_explosion(ship)
	-- Draw explosion
	x = math.round(ship.position.x)
	y = math.round(ship.position.y)
	draw = img.animations.explosion
	ship.explosion:draw(draw, x, y, 0, 1, 1, 16, 16)
end

return ship