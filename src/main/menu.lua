--- Definition of menu functions in Space Cats
--
-- @author	Rafael Alcalde Azpiazu (NEKERAFA)
-- @license GNU General Public License v3

local timer  = require "lib.vrld.hump.timer"
local vector = require "lib.vrld.hump.vector"

menu = {option = 1, y = app.height/4-2, alpha = 255}

--- Move down title
function menu.move_down()
	timer.tween(1, menu, {y = app.height/4+2}, 'out-quad', menu.move_up)
end

--- Move up title
function menu.move_up()
	timer.tween(1, menu, {y = app.height/4-2}, 'out-quad', menu.move_down)
end

--- Increment alpha
function menu.inc_alpha()
	timer.tween(0.5, menu, {alpha = 255}, 'in-quad', menu.dec_alpha)
end

--- Decrement alpha
function menu.dec_alpha()
	timer.tween(0.5, menu, {alpha = 0}, 'in-quad', menu.inc_alpha)
end

--- Load menu
function menu:init()
	menu.move_down()
	menu.dec_alpha()
	
	menu.stars = stars.new(vector(0,-1))
end

--- Update menu variables
function menu:update(dt)
	timer.update(dt)
	stars.update(menu.stars, dt)
end

--- Update menu variable
function menu:keypressed(key, scancode, isrepeat)
	if scancode == "up" and menu.option ~= 1 then
		menu.option = menu.option - 1
	elseif scancode == "down" and menu.option ~= 3 then
		menu.option = menu.option + 1
	end
end

--- Draw menu
function menu:draw()
	-- Draw background
	love.graphics.draw(img.backgrounds.space, 0, 0)
	
	-- Draw stars
	stars.draw(menu.stars)
	
	-- Draw title
	local x0 = math.round(img.space_cats:getWidth()/2)
	local y0 = math.round(img.space_cats:getHeight()/2)
	love.graphics.draw(img.space_cats, math.round(app.width/2), math.round(menu.y), 0, 1, 1, x0, y0)
	
	-- Draw options
	for i = 1, 3 do
		menu.draw_button(i)
	end
end

--- Draw button text
function menu.draw_button(n)
	local text
	
	-- Select text texture
	if n == 1 then
		text = txt.story
	elseif n == 2 then
		text = txt.settings
	else
		text = txt.exit
	end
	
	-- Print background button
	love.graphics.draw(img.menu.option_normal, 96, 108+19*(n-1))
	if menu.option == n then
		love.graphics.setColor(255, 255, 255, menu.alpha)
		love.graphics.draw(img.menu.option_selected, 96, 108+19*(n-1))
		love.graphics.setColor(0, 0, 0)
		love.graphics.draw(txt.select, 100, 116+19*(n-1), 0, 1, 1, 0, math.round(txt.select:getHeight()/2))
	end
	
	-- Print text
	local x0 = math.round(text:getWidth()/2)
	local y0 = math.round(text:getHeight()/2)
	love.graphics.setColor(0, 0, 0)
	love.graphics.draw(text, 160, 116+19*(n-1), 0, 1, 1, x0, y0)
	love.graphics.setColor(255, 255, 255)
end