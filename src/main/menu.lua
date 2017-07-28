--- Definition of menu functions in Space Cats
--
-- @module  menu
-- @author	Rafael Alcalde Azpiazu (NEKERAFA)
-- @license GNU General Public License v3

local timer  = require "lib.vrld.hump.timer"
local vector = require "lib.vrld.hump.vector"

-- Menu module
menu = {}

--- Current menu
menu.current = "start"
--- Current option selected in start menu
menu.start_opt = 1
--- Current option selected in settings menu
menu.settings_opt = 1
--- Current level selected
menu.level_opt = {x = 1, y = 1}
--- Current button alpha
menu.alpha = 255
--- Current title delta movement
menu.title_delta = -2
--- This delta move all menu objects
menu.x_delta = 0

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

--- Change to start menu
function menu.change_start()
	menu.current = "change start"
	timer.tween(0.5, menu, {x_delta = 0}, 'out-quad', function() menu.current = "start" end)
	timer.tween(0.5, menu, {planet = {x0 = 92}}, 'out-expo')
end

--- Change to settings menu
function menu.change_settings()
	menu.current = "change settings"
	timer.tween(0.5, menu, {x_delta = app.width}, 'out-quad', function() menu.current = "settings" end)
	timer.tween(0.5, menu, {planet = {x0 = 32}}, 'out-expo')
end

--- Change to level selection menu
function menu.change_levels()
	menu.current = "change levels"
	timer.tween(0.5, menu, {x_delta = -app.width}, 'out-quad', function() menu.current = "levels" end)
	timer.tween(0.5, menu, {planet = {x0 = 0}}, 'out-expo')
end

--- Load menu variable and resources
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
	
	-- Center of mark texture
	menu.m_x0 = math.round(txt.mark:getWidth()/2)
	menu.m_y0 = math.round(txt.mark:getHeight()/2)
	
	-- Create text button texture
	menu.buttons = {}
	
	-- Center of button texture
	menu.b_x0 = math.round(img.menu.option_normal:getWidth()/2)
	menu.b_y0 = math.round(img.menu.option_normal:getHeight()/2)
	
	-- Story button
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
	
	-- Settings button
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
	
	-- Exit button
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
	
	-- Load installed list languages
	menu.list_languages = love.filesystem.getDirectoryItems("lang")

	-- Load all resolutions
	menu.list_resolutions = {3, 3.2, 4, 4.2666, 5, 6, 8, 10, 12, 12.8}
	
	-- Load variables
	menu.get_settings()
end

--- Update menu variables
--- Draw splash animation
function menu:update(dt)
	timer.update(dt)
	stars.update(menu.stars, dt)
end

--- Get current variable settings
function menu.get_settings()
	-- Set settings
	menu.music_value = app.music_value
	menu.sfx_value = app.sfx_value
	menu.fullscreen = app.fullscreen
	
	-- Get current language
	for pos, language in ipairs(menu.list_languages) do
		dot = language:find("%.")
		if app.language == string.sub(language, 1, dot-1) then
			menu.set_language = pos
		end
	end
	
	-- Get current resolution
	for pos, resolution in ipairs(menu.list_resolutions) do
		if app.scalefactor == resolution then
			menu.set_resolution = pos
		end
	end
end

--- Update settings file
function menu.update_settings()
	-- Update variables
	app.music_value = menu.music_value
	app.sfx_value = menu.sfx_value
	app.fullscreen = menu.sfx_value
	
	-- Update file
	settings_file = io.open("settings.lua", "w+")
	settings_file:write("-- App settings\n")
	settings_file:write("app = {\n")
	settings_file:write("\tmusic_value = " .. app.music_value .. ",\n")
	settings_file:write("\tsfx_value = " .. app.sfx_value .. ",\n")
	settings_file:write("\tscalefactor = " .. menu.list_resolutions[menu.set_resolution] .. ",\n")
	settings_file:write("\tfullscreen = " .. tostring(app.fullscreen) .. ",\n")
	dot = string.find(menu.list_languages[menu.set_language], "%.")
	language = string.sub(menu.list_languages[menu.set_language], 1, dot-1)
	settings_file:write("\tlanguage = \"" .. language .. "\"\n")
	settings_file:write("}\n")
	settings_file:flush()
	settings_file:close()
	
	-- Update window size
	love.window.setFullscreen(app.fullscreen)
	if app.fullscreen then
		width = love.window.getDesktopDimensions()
		app.scalefactor = width / app.width
	else
		app.scalefactor = menu.list_resolutions[menu.set_resolution]
	end
	new_width = app.width * app.scalefactor
	new_height = app.height * app.scalefactor
	love.window.setMode(new_width, new_height, {fullscreen = app.fullscreen})
	
	-- Load language
	dofile("lang/" .. menu.list_languages[menu.set_language])
end

--- Update menu variable
-- @tparam KeyConstant key Character of the pressed key
-- @tparam Scancode scancode The scancode representing the pressed key
-- @tparam bolean isrepeat Whether this key press event is a repeat. The delay between key depends on the user's system settings
function menu:keypressed(key, scancode, isrepeat)
	-- Start controls
	if menu.current == "start" then
		menu.start_menu_controls(scancode)
	-- Settings controls
	elseif menu.current == "settings" then
		menu.settings_menu_control(scancode)
	end
end

--- Control start menu
-- @tparam Scancode scancode The scancode representing the pressed key
function menu.start_menu_controls(scancode)
	-- Move menu up and down
	if scancode == "up" and menu.start_opt ~= 1 then
		menu.start_opt = menu.start_opt - 1
	elseif scancode == "down" and menu.start_opt ~= 3 then
		menu.start_opt = menu.start_opt + 1
	end
	
	-- Enter in other menus
	if scancode == "return" then
		-- Level menu
		if menu.start_opt == 1 then
		-- Settings menu
		elseif menu.start_opt == 2 then
			menu.change_settings()
		-- Exit game
		elseif menu.start_opt == 3 then
			love.event.quit(0)
		end
	end
end

--- Control settings menu
-- @tparam Scancode scancode The scancode representing the pressed key
function menu.settings_menu_control(scancode)
	-- Move menu up an down
	if scancode == "up" and menu.settings_opt ~= 1 then
		menu.settings_opt = menu.settings_opt - 1
	elseif scancode == "down" and menu.settings_opt ~= 6 then
		menu.settings_opt = menu.settings_opt + 1
	end
	
	-- Change settings variables
	-- Set music volume
	if menu.settings_opt == 1 then
		if scancode == "right" and menu.music_value ~= 100 then
			menu.music_value = menu.music_value + 1
		elseif scancode == "left" and menu.music_value ~= 0 then
			menu.music_value = menu.music_value - 1
		end
	-- Set sound effects volume
	elseif menu.settings_opt == 2 then
		if scancode == "right" and menu.sfx_value ~= 100 then
			menu.sfx_value = menu.sfx_value + 1
		elseif scancode == "left" and menu.sfx_value ~= 0 then
			menu.sfx_value = menu.sfx_value - 1
		end
	-- Set current resolution
	elseif menu.settings_opt == 3 and not menu.fullscreen then
		if scancode == "right" and menu.set_resolution ~= #menu.list_resolutions then
			menu.set_resolution = menu.set_resolution + 1
		elseif scancode == "left" and menu.set_resolution ~= 1 then
			menu.set_resolution = menu.set_resolution - 1
		end
	-- Set fullscreen mode
	elseif menu.settings_opt == 4 then
		if scancode == "right" and not menu.fullscreen then
			menu.fullscreen = true
		elseif scancode == "left" and menu.fullscreen then
			menu.fullscreen = false
		end
	-- Set language
	elseif menu.settings_opt == 5 then
		if scancode == "right" and menu.set_language ~= #menu.list_languages then
			menu.sfx_value = menu.sfx_value + 1
		elseif scancode == "left" and menu.set_language ~= 1 then
			menu.sfx_value = menu.sfx_value - 1
		end
	end
	
	-- Make acction
	if scancode == "return" then
		-- Save settings
		if menu.settings_opt ~= 6 then
			menu.settings_opt = 1
			menu.update_settings()
			menu.change_start()
		-- Show credits and licenses
		else
		end
	-- Return to start menu
	elseif scancode == "backspace" then
		menu.settings_opt = 1
		menu.update_variables()
		menu.change_start()
	end
end

--- Draw menu function
function menu:draw()
	-- Draw background
	love.graphics.draw(img.backgrounds.space, 0, 0)
	
	-- Draw stars
	stars.draw(menu.stars)
	
	-- Draw planet
	love.graphics.draw(img.planets.big_red, menu.planet.x-menu.x_delta, app.height, 0, 1, 1, menu.planet.x0, 96)
	
	-- Draw start menu
	menu.draw_start_menu()
	
	-- Draw settings menu
	menu.draw_settings_menu()
end

--- Draw start menu
function menu.draw_start_menu()
	-- Draw title
	local x = app.width/2-menu.x_delta
	local y = menu.title.y-menu.title_delta
	love.graphics.draw(img.space_cats, x, y, 0, 1, 1, menu.title.x0, menu.title.y0)
	
	-- Draw buttons
	for _, button in pairs(menu.buttons) do
		menu.draw_button(button)
	end
end

--- Draw settings menu
function menu.draw_settings_menu()
	-- Delta of menu
	delta = app.width - menu.x_delta
	-- Resolution
	width = math.ceil(app.width * menu.list_resolutions[menu.set_resolution])
	height = math.ceil(app.height * menu.list_resolutions[menu.set_resolution])
	-- Language
	dot = string.find(menu.list_languages[menu.set_language], "%.")
	language = string.sub(menu.list_languages[menu.set_language], 1, dot-1):gsub("^%l", string.upper)
	
	-- Draw selection mark
	love.graphics.setColor(0, 0, 0)
	love.graphics.draw(txt.mark, 20 + delta, 32 + (menu.settings_opt - 1) * 24, 0, 1, 1, 0, menu.m_y0)
	
	-- Draw music volume label
	love.graphics.setColor(0, 0, 0)
	love.graphics.draw(txt.music, 41 + delta, 27)
	love.graphics.setColor(255, 224, 0)
	love.graphics.draw(txt.music, 40 + delta, 26)
	-- Draw current music volume
	love.graphics.setColor(255, 255, 255)
	love.graphics.printf("< " .. menu.music_value .. " % >", 140 + delta, 27, 160, "center")
	
	-- Draw sound effects volume lavel
	love.graphics.setColor(0, 0, 0)
	love.graphics.draw(txt.sfx, 41 + delta, 51)
	love.graphics.setColor(255, 224, 0)
	love.graphics.draw(txt.sfx, 40 + delta, 50)
	-- Draw current sound effects volume
	love.graphics.setColor(255, 255, 255)
	love.graphics.printf("< " .. menu.sfx_value .. " % >", 140 + delta, 51, 160, "center")
	
	-- Draw resolution volume label
	love.graphics.setColor(0, 0, 0)
	love.graphics.draw(txt.resolution, 41 + delta, 75)
	love.graphics.setColor(255, 224, 0)
	love.graphics.draw(txt.resolution, 40 + delta, 74)
	-- If fullscreen, show disable color
	if menu.fullscreen then
		love.graphics.setColor(128, 128, 128)
	else
		love.graphics.setColor(255, 255, 255)
	end
	-- Draw current resolution value
	love.graphics.printf("< " .. width .. "x" .. height .. " >", 140 + delta, 75, 160, "center")
	
	-- Draw fullscreen label
	love.graphics.setColor(0, 0, 0)
	love.graphics.draw(txt.fullscreen, 41 + delta, 99)
	love.graphics.setColor(255, 224, 0)
	love.graphics.draw(txt.fullscreen, 40 + delta, 98)
	love.graphics.setColor(255, 255, 255)
	-- Draw if fullscreen is enable or disable
	if menu.fullscreen then
		love.graphics.printf("< " .. msg_string.enabled .. " >", 140 + delta, 99, 160, "center")
	else
		love.graphics.printf("< " .. msg_string.disabled .. " >", 140 + delta, 99, 160, "center")
	end

	-- Draw language label
	love.graphics.setColor(0, 0, 0)
	love.graphics.draw(txt.language, 41 + delta, 123)
	love.graphics.setColor(255, 224, 0)
	love.graphics.draw(txt.language, 40 + delta, 122)
	love.graphics.setColor(255, 255, 255)
	-- Draw current language
	love.graphics.printf("< " .. language .. " >", 140 + delta, 123, 160, "center")

	-- Draw credits label
	love.graphics.setColor(0, 0, 0)
	love.graphics.draw(txt.credits, 41 + delta, 147)
	love.graphics.setColor(255, 224, 0)
	love.graphics.draw(txt.credits, 40 + delta, 146)
end

--- Draw levels menu
function menu.draw_levels_menu()
end

--- Draw button backgrond and text
-- @tparam table elem Current button
function menu.draw_button(elem)
	-- Print background button
	local b_x = app.width/2-menu.x_delta
	local m_x = app.width/2-58-menu.x_delta
	love.graphics.draw(img.menu.option_normal, b_x, elem.button.y, 0, 1, 1, menu.b_x0, menu.b_y0)
	
	-- Print selected background mark
	if menu.start_opt == elem.option then
		love.graphics.setColor(255, 255, 255, menu.alpha)
		love.graphics.draw(img.menu.option_selected, b_x, elem.button.y, 0, 1, 1, menu.b_x0, menu.b_y0)
		love.graphics.setColor(0, 0, 0)
		love.graphics.draw(txt.mark, m_x, elem.button.y+2, 0, 1, 1, menu.m_x0, menu.m_y0)
	end
	
	-- Print button text
	love.graphics.setColor(0, 0, 0)
	love.graphics.draw(elem.text.img, b_x, elem.button.y+1, 0, 1, 1, elem.text.x0, elem.text.y0)
	love.graphics.setColor(255, 255, 255)
end