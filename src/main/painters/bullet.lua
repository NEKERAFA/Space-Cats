--- This module is resposible for draw bullets weapon
--
-- @module painters.weapon
-- @author	Rafael Alcalde Azpiazu (NEKERAFA)
-- @license GNU General Public License v3

-- Module
local weapon = {}

function weapon.draw_bullets(weapon)
	for i, bullet in pairs(weapon.bullets) do
		-- Get rotation angle
		local angle = math.atan2(bullet.velocity.x, -bullet.velocity.y)
		-- Get centered of image
		local x_pos = img.weapons[bullet.type]:getWidth()/2
		local y_pos = 0
		
		if bullet.type == "baster" then
			y_pos = img.weapons[bullet.type]:getHeight()-2
		elseif bullet.type == "baster2" then
			y_pos = img.weapons[bullet.type]:getHeight()-4
		elseif bullet.type == "balistic" then
			y_pos = img.weapons[bullet.type]:getHeight()-1
		end
	
		-- Draw weapon
		love.graphics.draw(img.weapons[bullet.type], math.round(bullet.x), math.round(bullet.y), angle, 1, -1, x_pos, y_pos)
	end
end

function weapon.draw_ray_tracer(weapon)
	-- Get current colors
	r, g, b, a = love.graphics.getColor()

	love.graphics.setLineWidth(weapon.size)
	love.graphics.setColor(0, 255, 255, 255)
	love.graphics.line(weapon.ray)
	
	-- Return values
	love.graphics.setColor(r, g, b, a)
end

return weapon