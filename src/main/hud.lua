--- Definition of game interface in Space Cats
--
-- @author	Rafael Alcalde Azpiazu (NEKERAFA)
-- @license GNU General Public License v3

-- Module hud
hud = {}

-- Points texture
hud.points = nil

--- Update points texture
-- @tparam number points Number of current points
function hud:update_points()
	if hud.points == nil then
		hud.points = love.graphics.newText(app.font_points, string.format("%0.8i", game.points))
	else
		hud.points:set(string.format("%0.8i", game.points))
	end
end

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
	love.graphics.draw(hud.points, app.width-5, 2, 0, 1, 1, hud.points:getWidth(), 0)
end

--- Draw hud
function hud:draw()
	hud:draw_weapon()
	hud:draw_life()
	hud:draw_points()
end