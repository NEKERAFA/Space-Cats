--- This module is resposible for draw player ship
--
-- @author	Rafael Alcalde Azpiazu (NEKERAFA)
-- @license GNU General Public License v3

local weapon_painter = require "src.main.painters.weapon"
local ship_painter   = require "src.main.painters.ship"

-- Module player
local player = {}

--- Draw player ship textures
-- @tparam player ship ship to draw
function player.draw(ship)
	-- Draw bullets
	if ship.weapon then
		if ship.weapon.type == "ray_blaster" then
			weapon_painter.draw_ray(ship.weapon)
		else
			weapon_painter.draw_bullets(ship.weapon)
		end
	end

	if ship.life > 0 then
		-- If ship is damaged, show damaged animation
		-- Get current colors
		local r, g, b, a = love.graphics.getColor()

		-- Draw damage effect
		if ship.damaged then
			-- Alpha value
			local alpha = math.round(math.abs(math.cos(ship.damaged_time*2*math.pi))) * 255
			-- Color value
			local color = 255 * ship.damaged_time / 4
			-- Set effect
			love.graphics.setColor(255, color, color, alpha)
		end

		-- Draw flame and ship
		x = math.round(ship.position.x)
		y = math.round(ship.position.y)
		ship.flame:draw(img.animations.flame_medium, x-24, y, 0, 1, 1, 8, 8)
		love.graphics.draw(img.ships.allies[ship.type], x, y, 0, 1, 1, 16, 16)

		-- Reset colors
		love.graphics.setColor(r, g, b, a)
	elseif not ship.destroyed then
		ship_painter.draw_explosion(ship)
	end

	-- Draw hitbox
	if app.debug then
		ship_painter.draw_hitbox(ship)
	end
end

return player
