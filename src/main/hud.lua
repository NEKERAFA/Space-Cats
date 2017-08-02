--- Definition of game interface in Space Cats
--
-- @module  entities.ships.player
-- @author	Rafael Alcalde Azpiazu (NEKERAFA)
-- @license GNU General Public License v3

-- Module hud
hud = {}

--- Draw player life
function hud:draw_life()
	for i = 1, 4 do
		-- Set grayscale life if life is lost
		if i > game.player.life then
			love.graphics.setShader(shaders.grayscale)
		end
		
		-- Calculate x position
		local x = (i-1)*18 + app.width/2 - ((18*3)+16)/2
		love.graphics.draw(img.hud.life, x, 5)
		
		love.graphics.setShader()
	end
end

--- Draw player weapon
function hud:draw_weapon()
	love.graphics.draw(img.hud.ammo, 5, 5)
	local weapon = img.hud[game.player.weapon.type]
	local mid_width = math.round(weapon:getWidth()/2)
	local mid_heigth = math.round(weapon:getHeight()/2)
	love.graphics.draw(weapon, 12, 16, -math.pi/4-math.pi/2, 1, 1, mid_width, mid_heigth)
end

--- Draw points
function hud:draw_points()
	love.graphics.printf(string.format("%0.8i", game.points), 5, 5, app.width-10, "right")
end

--- Draw hud
function hud:draw()
	hud:draw_weapon()
	hud:draw_life()
	hud:draw_points()
end