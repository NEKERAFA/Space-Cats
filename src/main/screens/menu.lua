--- Definition of menu functions in Space Cats
--
-- @author	Rafael Alcalde Azpiazu (NEKERAFA)
-- @license GNU General Public License v3

local gamestate      = require "lib.vrld.hump.gamestate"
local vector         = require "lib.vrld.hump.vector"
local animation      = require "src.main.animations"
local ship           = require "src.main.entities.ships.mockup_player"
local stars          = require "src.main.entities.stars"
local player_painter = require "src.main.painters.ships.player"
local stars_painter  = require "src.main.painters.stars"

-- Menu module
menu = {}

--- Current menu
menu.current = "animation"
--- Current option selected in start menu
menu.option = 1
--- Current button alpha
menu.b_alpha = 255
--- Current save text alpha
menu.t_alpha = 0
--- Current title delta movement
menu.title_delta = -2
--- This delta move all menu textures when it change of showed menu
menu.delta = 0
--- Delta to move saved message
menu.x_delta = 0
--- Player ship for start animation
menu.ship = nil

--- Load menu variable and resources
function menu:init()
	-- Load menus
	dofile("src/main/menus/levels.lua")
	dofile("src/main/menus/settings.lua")
	
	-- Set started sound theme
	snd.music.space_theme:setLooping(true)
	snd.music.space_theme:play()
	
	-- Create player
	menu.ship = ship(vector(-32, app.height/2))
	
	-- Move player
	animation.show_menu()
	
	-- Add decrement alpha tween
	animation.dec_alpha()
	-- Add move down delta tween
	animation.title_down()
	
	-- Create stars
	self.stars = stars(vector(0, -1))
	
	-- Create title image texture
	self.title = {
		img = img.space_cats,
		y = math.round(app.height/4),
		x0 = math.round(img.space_cats:getWidth()/2),
		y0 = math.round(img.space_cats:getHeight()/2)
	}
	
	-- Create planet image texture
	self.planet = {
		x = app.width,
		x0 = 92,
	}
	
	-- Center of mark texture
	self.m_x0 = math.round(txt.mark:getWidth()/2)
	self.m_y0 = math.round(txt.mark:getHeight()/2)
	
	-- Create text button texture
	self.buttons = {}
	
	-- Center of button texture
	self.b_x0 = math.round(img.menu.option_normal:getWidth()/2)
	self.b_y0 = math.round(img.menu.option_normal:getHeight()/2)
	
	-- Create buttons
	menu:update_buttons()
	
	-- Load settings
	settings:init()
end

--- Create/update main buttons
function menu:update_buttons()
	-- Story button
	if not self.buttons.story then
		self.buttons.story = {
			option = 1,
			button = {
				y = app.height/2 + 8
			},
			text = {
				img = txt.story,
				x0 = math.round(txt.story:getWidth()/2),
				y0 = math.round(txt.story:getHeight()/2)
			}
		}
	else
		self.buttons.story.text.x0 = math.round(txt.story:getWidth()/2)
		self.buttons.story.text.y0 = math.round(txt.story:getHeight()/2)
	end
	
	-- Settings button
	if not self.buttons.settings then
		self.buttons.settings = {
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
	else
		self.buttons.settings.text.x0 = math.round(txt.settings:getWidth()/2)
		self.buttons.settings.text.y0 = math.round(txt.settings:getHeight()/2)
	end
	
	-- Exit button
	if not self.buttons.exit then
		self.buttons.exit = {
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
	else
		self.buttons.exit.text.x0 = math.round(txt.exit:getWidth()/2)
		self.buttons.exit.text.y0 = math.round(txt.exit:getHeight()/2)
	end
end

--- Update menu variables
--- Draw splash animation
function menu:update(dt)
	-- Update stars
	self.stars:update(dt)
	
	-- Update ship
	if self.current == "animation" then
		self.ship:update(dt)
	end
end

--- Update menu variable
-- @tparam KeyConstant key Character of the pressed key
-- @tparam Scancode scancode The scancode representing the pressed key
-- @tparam bolean isrepeat Whether this key press event is a repeat. The delay between key depends on the user's system settings
function menu:keypressed(key, scancode, isrepeat)
	-- Start controls
	if self.current == "start" then
		self:keypressed_start(scancode)
	-- Settings controls
	elseif menu.current == "settings" then
		settings:keypressed(key, scancode, isrepeat)
	end
end

--- Control start menu
-- @tparam Scancode scancode The scancode representing the pressed key
function menu:keypressed_start(scancode)
	-- Move menu up and down
	if scancode == app.up and self.option ~= 1 then
		snd.effects.gui_effects_1:rewind()
		snd.effects.gui_effects_1:play()
		self.option = self.option - 1
	elseif scancode == app.down and self.option ~= 3 then
		snd.effects.gui_effects_1:rewind()
		snd.effects.gui_effects_1:play()
		self.option = self.option + 1
	end
	
	-- Enter in other menus
	if scancode == app.accept then
		snd.effects.gui_effects_3:rewind()
		snd.effects.gui_effects_3:play()
		-- Level menu
		if menu.option == 1 then
			gamestate.switch(game)
		-- Settings menu
		elseif self.option == 2 then
			animation.change_settings()
		-- Exit game
		elseif self.option == 3 then
			love.event.quit(0)
		end
	end
end

--- Draw button backgrond and text
-- @tparam table button Current button
function menu:draw_button(button)
	-- Print background button
	local b_x = app.width/2 - self.delta
	local m_x = app.width/2 - 58 - self.delta
	love.graphics.draw(img.menu.option_normal, b_x, button.button.y, 0, 1, 1, self.b_x0, self.b_y0)
	
	-- Print selected background mark
	if self.option == button.option then
		love.graphics.setColor(255, 255, 255, self.b_alpha)
		love.graphics.draw(img.menu.option_selected, b_x, button.button.y, 0, 1, 1, self.b_x0, self.b_y0)
		love.graphics.setColor(0, 0, 0)
		love.graphics.draw(txt.mark, m_x, button.button.y + 2, 0, 1, 1, self.m_x0, self.m_y0)
	end
	
	-- Print button text
	love.graphics.setColor(0, 0, 0)
	love.graphics.draw(button.text.img, b_x, button.button.y+1, 0, 1, 1, button.text.x0, button.text.y0)
	love.graphics.setColor(255, 255, 255)
end

--- Draw start menu
function menu:draw_start_menu()
	-- Draw title
	local x = app.width/2 - self.delta
	local y = menu.title.y - self.title_delta
	love.graphics.draw(img.space_cats, x, y, 0, 1, 1, self.title.x0, self.title.y0)
	
	-- Draw buttons
	for _, button in pairs(self.buttons) do
		menu:draw_button(button)
	end
end

--- Stencil open animation
function menu:stencil()
	love.graphics.rectangle("fill", menu.ship.position.x, 0, app.width - menu.ship.position.x, app.height)
end

--- Draw open animation
function menu:draw_open_anim()
	-- Set stencil function
	love.graphics.stencil(menu.stencil, "replace", 1)
	love.graphics.setStencilTest("greater", 0)
	
	-- Draw loading text
	love.graphics.setColor(0, 0, 0)
	love.graphics.rectangle("fill", 0, 0, app.width, app.height)
	love.graphics.setColor(255, 255, 255)
	local x  = math.round(app.width/2)
	local y  = math.round(app.height/2)
	local x0 = math.round(txt.loading:getWidth()/2)
	local y0 = math.round(txt.loading:getHeight()/2)
	love.graphics.draw(txt.loading, x, y, 0, 1, 1, x0, y0)
	
	-- Remove stecil
	love.graphics.setStencilTest()
	
	-- Print player
	love.graphics.setColor(255, 255, 255)
	player_painter.draw(self.ship)
end

--- Draw menu function
function menu:draw()
	-- Draw background
	love.graphics.draw(img.backgrounds.space, 0, 0)
	
	-- Draw stars
	stars_painter.draw(self.stars)
	
	-- Draw planet
	love.graphics.draw(img.planets.big_red, self.planet.x - self.delta, app.height, 0, 1, 1, self.planet.x0, 96)
	
	-- Draw start menu
	menu:draw_start_menu()
	
	-- Draw settings menu
	settings:draw()
	
	-- Draw save message
	love.graphics.setColor(255, 255, 255, self.t_alpha)
	y = app.height - 5 - txt.saved:getHeight()
	love.graphics.draw(txt.saved, 5 + self.x_delta, y)
	
	-- Draw copyright message
	love.graphics.setColor(255, 255, 255, 255)
	local x = 10
	if app.debug then
		x = x + txt.version:getWidth() + 10
	end
	love.graphics.draw(txt.copyright, x, app.height - txt.copyright:getHeight() - 5)
	
	-- Draw open animation
	if self.current == "animation" then
		menu:draw_open_anim()
	end
end