--- This module is resposible for draw bullets weapon
--
-- @author	Rafael Alcalde Azpiazu (NEKERAFA)
-- @license GNU General Public License v3

-- Module weapon
local weapon = {}

--- Draw all weapon bullets
-- @tparam weapon weapon Weapon to draw bullets
function weapon.draw_bullets(weapon)
	for i, bullet in pairs(weapon.bullets) do
		-- Get rotation angle
		local angle = math.atan2(bullet.velocity.x, -bullet.velocity.y)
		-- Get centered of image
		local x_pos = img.weapons[bullet.type]:getWidth()/2
		local y_pos = 0

		-- Get y_pos centered
		if bullet.type == "baster" then
			y_pos = img.weapons[bullet.type]:getHeight()-2
		elseif bullet.type == "guided_blaster" then
			y_pos = img.weapons[bullet.type]:getHeight()-4
		elseif bullet.type == "balistic" then
			y_pos = img.weapons[bullet.type]:getHeight()-1
		end
	
		-- Draw weapon
		local x = math.round(bullet.position.x)
		local y = math.round(bullet.position.y)
		love.graphics.draw(img.weapons[bullet.type], x, y, angle, 1, -1, x_pos, y_pos)
		
		if bullet.collider and app.debug then
			local r, g, b, a = love.graphics.getColor()
			love.graphics.setColor(255, 0, 0, 128)
			bullet.collider:draw('fill')
			love.graphics.setColor(r, g, b, a)
		end
	end
end

--- Draw ray of ray weapon
-- @tparam ray_blaster weapon Weapon to draw ray
function weapon.draw_ray(weapon)
	-- Get current colors
	r, g, b, a = love.graphics.getColor()

	love.graphics.setLineWidth(weapon.size)
	love.graphics.setColor(0, 255, 255, 255)
	love.graphics.line(weapon.ray)
	
	-- Return values
	love.graphics.setColor(r, g, b, a)
end

return weapon