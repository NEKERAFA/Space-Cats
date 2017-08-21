--- Definition of game interface in Space Cats
--
-- @author	Rafael Alcalde Azpiazu (NEKERAFA)
-- @license GNU General Public License v3

-- Module hud
local hud = {}

-- Points texture
hud.points = nil

--- Update points texture
-- @tparam number points Number of current points
function hud:update_points(points)
	if hud.points == nil then
		hud.points = love.graphics.newText(app.font_points, string.format("%0.8i", points))
	else
		hud.points:set(string.format("%0.8i", points))
	end
end

--- Draw hud
function hud:draw(max_life, weapon)
	-- Draw weapon
	love.graphics.draw(img.hud.ammo, 5, 5)
	local mid_width = math.round(img.hud[weapon.type]:getWidth()/2)
	local mid_heigth = math.round(img.hud[weapon.type]:getHeight()/2)
	love.graphics.draw(img.hud[weapon.type], 12, 16, -math.pi/4-math.pi/2, 1, 1, mid_width, mid_heigth)
	
	-- Draw lifes
	-- First point life texture
	local x0 = app.width / 2 - (16 + 18 * (max_life - 1)) / 2
	-- Draw life
	for i = 1, max_life do
		-- Set grayscale life if life is lost
		if i > game.player.life then
			love.graphics.setShader(shaders.grayscale)
		end
		-- Draw life
		love.graphics.draw(img.hud.life, x0 + (i-1)*18, 5)
		love.graphics.setShader()
	end
	
	-- Draw points
	love.graphics.draw(hud.points, app.width-5, 2, 0, 1, 1, hud.points:getWidth(), 0)
end

return hud