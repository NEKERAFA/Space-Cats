--- Definition of menu functions in Space Cats
--
-- @author	Rafael Alcalde Azpiazu (NEKERAFA)
-- @license GNU General Public License v3

local timer  = require "lib.vrld.hump.timer"
local vector = require "lib.vrld.hump.vector"

menu = {
	current = "start", -- Current menu
	start_opt = 1, -- Current option selected in start menu
	settings_opt = 1, -- Current option selected in settings menu
	level_opt = {x = 1, y = 1}, -- Current level selected
	alpha = 255, -- Current button alpha
	title_delta = -2, -- Current title delta movement
	x_delta = 0, -- This delta move all menu objects
}

--- Move down title
function menu.move_down()
	timer.tween(1, menu, {title_delta = 2}, 'out-quad', menu.move_up)
end

--- Move up title
function menu.move_up()
	timer.tween(1, menu, {title_delta = -2}, 'out-quad', menu.move_down)
end

--- Increment alpha
function menu.inc_alpha()
	timer.tween(0.5, menu, {alpha = 255}, 'in-quad', menu.dec_alpha)
end

--- Decrement alpha
function menu.dec_alpha()
	timer.tween(0.5, menu, {alpha = 0}, 'in-quad', menu.inc_alpha)
end

--- Change to settings menu
function menu.change_settings()
	menu.current = "change settings"
	timer.tween(1, menu, {x_delta = app.width}, 'out-quad', function() menu.current = "settings" end)
	timer.tween(1, menu, {planet = {x0 = 32}}, 'out-quad')
end

--- Change to start menu
function menu.change_start()
	menu.current = "change start"
	timer.tween(1, menu, {x_delta = 0}, 'out-quad', function() menu.current = "start" end)
	timer.tween(1, menu, {planet = {x0 = 92}}, 'out-quad')
end

--- Load menu
function menu:init()
	-- Add decrement alpha tween
	menu.dec_alpha()
	-- Add move down delta tween
	menu.move_down()
	
	-- Create stars
	menu.stars = stars.new(vector(0,-1))
	
	-- Create title image texture
	menu.title = {
		img = img.space_cats,
		y = math.round(app.height/4),
		x0 = math.round(img.space_cats:getWidth()/2),
		y0 = math.round(img.space_cats:getHeight()/2)
	}
	
	-- Create planet image texture
	menu.planet = {
		x = app.width,
		x0 = 92,
	}
	
	-- Create text button texture
	menu.buttons = {}
	
	-- Center of button texture
	menu.b_x0 = math.round(img.menu.option_normal:getWidth()/2)
	menu.b_y0 = math.round(img.menu.option_normal:getHeight()/2)
	
	-- Center of mark texture
	menu.m_x0 = math.round(txt.mark:getWidth()/2)
	menu.m_y0 = math.round(txt.mark:getHeight()/2)
	
	menu.buttons.story = {
		option = 1,
		button = {
			y = app.height/2 + 8,
			pos = vector(0, -app.height/2 + 8),
		},
		text = {
			img = txt.story,
			x0 = math.round(txt.story:getWidth()/2),
			y0 = math.round(txt.story:getHeight()/2)
		}
	}
	
	menu.buttons.settings = {
		option = 2,
		button = {
			y = app.height/2 + 14 + 14
		},
		text = {
			img = txt.settings,
			x0 = math.round(txt.settings:getWidth()/2),
			y0 = math.round(txt.settings:getHeight()/2)
		}
	}
	
	menu.buttons.exit = {
		option = 3,
		button = {
			y = app.height/2 + 20 + 28
		},
		text = {
			img = txt.exit,
			x0 = math.round(txt.exit:getWidth()/2),
			y0 = math.round(txt.exit:getHeight()/2)
		}
	}
end

--- Update menu variables
function menu:update(dt)
	timer.update(dt)
	stars.update(menu.stars, dt)
end

--- Update menu variable
function menu:keypressed(key, scancode, isrepeat)
	if scancode == "up" and menu.start_opt ~= 1 then
		menu.start_opt = menu.start_opt - 1
	elseif scancode == "down" and menu.start_opt ~= 3 then
		menu.start_opt = menu.start_opt + 1
	end
	
	if scancode == "return" and menu.current == "start" and menu.start_opt == 2 then
		menu.change_settings()
	end
	
	if scancode == "return" and menu.current == "settings" then
		menu.change_start()
	end
end

--- Draw menu
function menu:draw()
	-- Draw background
	love.graphics.draw(img.backgrounds.space, 0, 0)
	
	-- Draw stars
	stars.draw(menu.stars)
	
	-- Draw planet
	love.graphics.draw(img.planets.big_red, menu.planet.x-menu.x_delta, app.height, 0, 1, 1, menu.planet.x0, 96)
	
	-- Draw start menu
	menu.draw_start_menu()
end

--- Draw start menu
function menu.draw_start_menu()
	-- Draw title
	local x = app.width/2-menu.x_delta
	local y = menu.title.y-menu.title_delta
	love.graphics.draw(img.space_cats, x, y, 0, 1, 1, menu.title.x0, menu.title.y0)
	
	-- Draw buttons
	for _, button in pairs(menu.buttons) do
		menu.draw_button(pos, button)
	end
end

--- Draw settings menu
function menu.draw_settings_menu()
end

--- Draw button text
function menu.draw_button(pos, elem)
	-- Print background button
	local b_x = app.width/2-menu.x_delta
	local m_x = app.width/2-58-menu.x_delta
	love.graphics.draw(img.menu.option_normal, b_x, elem.button.y, 0, 1, 1, menu.b_x0, menu.b_y0)
	-- Print selected background button
	if menu.start_opt == elem.option then
		love.graphics.setColor(255, 255, 255, menu.alpha)
		love.graphics.draw(img.menu.option_selected, b_x, elem.button.y, 0, 1, 1, menu.b_x0, menu.b_y0)
		love.graphics.setColor(0, 0, 0)
		love.graphics.draw(txt.mark, m_x, elem.button.y+1, 0, 1, 1, menu.m_x0, menu.m_y0)
	end
	
	-- Print text
	--love.graphics.setColor(255, 128, 0)
	--love.graphics.draw(elem.text.img, elem.text.pos.x+1, elem.text.pos.y+1, menu.theta, 1, 1, elem.text.x0, elem.text.y0)
	love.graphics.setColor(0, 0, 0)
	love.graphics.draw(elem.text.img, b_x, elem.button.y+1, 0, 1, 1, elem.text.x0, elem.text.y0)
	love.graphics.setColor(255, 255, 255)
end