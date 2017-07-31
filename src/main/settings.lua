--- Definition of settings functions in Space Cats
--
-- @module  settings
-- @author	Rafael Alcalde Azpiazu (NEKERAFA)
-- @license GNU General Public License v3

-- Module settings
settings = {}

--- Current option
settings.option = 1
--- Current music volume
settings.music_volume = nil
--- Current sound effects volume
settings.sfx_volume = nil
--- Current fullscreen state
settings.fullscreen = nil
--- Current language
settings.language = nil
--- Current screen scale factor
settings.scalefactor = nil

--- Load settings variables
function settings:init()
	-- Load installed list languages
	self.languages = love.filesystem.getDirectoryItems("lang")

	-- Load all resolutions
	self.resolutions = {3, 3.2, 4, 4.2666, 5, 6, 8, 10, 12, 12.8}
	
	-- Load variables
	settings:get_settings()
end

--- Get current variable settings
function settings:get_settings()
	-- Set settings
	self.music_volume = app.music_volume
	self.sfx_volume = app.sfx_volume
	self.fullscreen = app.fullscreen
	
	-- Get current language
	for pos, language in ipairs(self.languages) do
		dot = language:find("%.")
		if app.language == string.sub(language, 1, dot-1) then
			self.language = pos
		end
	end
	
	-- Get current resolution
	for pos, resolution in ipairs(self.resolutions) do
		if app.scalefactor == resolution then
			self.scalefactor = pos
		end
	end
	
	if self.scalefactor == nil then
		self.resolutions[0] = app.scalefactor
		self.scalefactor = 0
	end
end

--- Update settings file
function settings:update_settings()
	-- Update variables
	app.music_volume = self.music_volume
	app.sfx_volume = self.sfx_volume
	app.fullscreen = self.fullscreen
	
	-- Create save folder if not exists
	if not love.filesystem.exists(love.filesystem.getSaveDirectory()) then
		love.filesystem.createDirectory(love.filesystem.getSaveDirectory())
	end
	
	-- Update file
	settings_file, msg = io.open(app.save_file, "w+")
	if settings_file == nil then
		error(msg)
	end
	
	settings_file:write("-- App settings\n")
	settings_file:write("music_volume = " .. self.music_volume .. "\n")
	settings_file:write("sfx_volume = " .. self.sfx_volume .. "\n")
	settings_file:write("scalefactor = " .. self.resolutions[self.scalefactor] .. "\n")
	settings_file:write("fullscreen = " .. tostring(self.fullscreen) .. "\n")
	dot = string.find(self.languages[self.language], "%.")
	language = string.sub(self.languages[self.language], 1, dot-1)
	settings_file:write("language = \"" .. language .. "\"\n")
	settings_file:flush()
	settings_file:close()
	
	-- Update fullscreen
	love.window.setFullscreen(self.fullscreen)
	
	-- Set scalefactor
	if app.fullscreen then
		width = love.window.getDesktopDimensions()
		app.scalefactor = width / app.width
	else
		app.scalefactor = self.resolutions[self.scalefactor]
	end
	
	-- Update window
	new_width = math.ceil(app.width * app.scalefactor)
	new_height = math.ceil(app.height * app.scalefactor)
	love.window.setMode(new_width, new_height, {fullscreen = app.fullscreen})
	
	-- Load language
	dofile("lang/" .. self.languages[self.language])
	
	-- Start save animation
	animation.save_text()
end

--- Save settings and back to start screen
function settings:save_and_back()
	settings:update_settings()
	self.option = 1
	animation.change_start()
end

--- Back to start screen
function settings:back()
	settings:get_settings()
	self.option = 1
	animation.change_start()
end

--- Change music volume
-- @tparam Scancode scancode The scancode representing the pressed key
function settings:keypressed_music(scancode)
	if scancode == menu.right and self.music_volume ~= 100 then
		self.music_volume = self.music_volume + 1
	elseif scancode == menu.left and self.music_volume ~= 0 then
		self.music_volume = self.music_volume - 1
	end
end

--- Change sound effect volume
-- @tparam Scancode scancode The scancode representing the pressed key
function settings:keypressed_sfx(scancode)
	if scancode == menu.right and self.sfx_volume ~= 100 then
		self.sfx_volume = self.sfx_volume + 1
	elseif scancode == menu.left and self.sfx_volume ~= 0 then
		self.sfx_volume = self.sfx_volume - 1
	end
end

--- Change screen resolution
-- @tparam Scancode scancode The scancode representing the pressed key
function settings:keypressed_resolution(scancode)
	if scancode == menu.right and self.scalefactor ~= #self.resolutions then
		self.scalefactor = self.scalefactor + 1
	elseif scancode == menu.left and self.scalefactor ~= 1 then
		self.scalefactor = self.scalefactor - 1
	end
end

--- Enable and disable fullscreen
-- @tparam Scancode scancode The scancode representing the pressed key
function settings:keypressed_fullscreen(scancode)
	if scancode == menu.right and not self.fullscreen then
		self.fullscreen = true
	elseif scancode == menu.left and self.fullscreen then
		self.fullscreen = false
	end
end

--- Change language
-- @tparam Scancode scancode The scancode representing the pressed key
function settings:keypressed_language(scancode)
	if scancode == menu.right and self.language ~= #self.languages then
		menu.sfx_value = menu.sfx_value + 1
	elseif scancode == menu.left and self.language ~= 1 then
		menu.sfx_value = menu.sfx_value - 1
	end
end

--- Control settings menu
-- @tparam KeyConstant key Character of the pressed key
-- @tparam Scancode scancode The scancode representing the pressed key
-- @tparam bolean isrepeat Whether this key press event is a repeat. The delay between key depends on the user's system settings
function settings:keypressed(key, scancode, isrepeat)
	-- Move menu up an down
	if scancode == menu.up and self.option ~= 1 then
		self.option = self.option - 1
	elseif scancode == menu.down and self.option ~= 6 then
		self.option = self.option + 1
	end
	
	-- Change settings variables
	-- Set music volume
	if self.option == 1 then
		settings:keypressed_music(scancode)
	-- Set sound effects volume
	elseif self.option == 2 then
		settings:keypressed_sfx(scancode)
	-- Set current resolution
	elseif self.option == 3 and not self.fullscreen then
		settings:keypressed_resolution(scancode)
	-- Set fullscreen mode
	elseif self.option == 4 then
		settings:keypressed_fullscreen(scancode)
	-- Set language
	elseif self.option == 5 then
		settings:keypressed_language(scancode)
	end
	
	-- Make acction
	if scancode == menu.accept then
		-- Save settings
		if self.option ~= 6 then
			settings:save_and_back()
		-- Show credits and licenses
		else
		end
	-- Return to start menu
	elseif scancode == menu.cancel then
		settings:back()
	end
end

--- Draw label and current music volume
-- @tparam number dx Delta of x axis
function settings:draw_music_volume(dx)
	-- Draw music volume label
	love.graphics.setColor(0, 0, 0)
	love.graphics.draw(txt.music, 41 + dx, 27)
	love.graphics.setColor(255, 224, 0)
	love.graphics.draw(txt.music, 40 + dx, 26)
	-- Draw current music volume
	love.graphics.setColor(255, 255, 255)
	love.graphics.printf("< " .. self.music_volume .. " % >", 140 + dx, 27, 160, "center")
end

--- Draw label and current sound effects volume
-- @tparam number dx Delta of x axis
function settings:draw_sfx_volume(dx)
	-- Draw sound effects volume lavel
	love.graphics.setColor(0, 0, 0)
	love.graphics.draw(txt.sfx, 41 + dx, 51)
	love.graphics.setColor(255, 224, 0)
	love.graphics.draw(txt.sfx, 40 + dx, 50)
	-- Draw current sound effects volume
	love.graphics.setColor(255, 255, 255)
	love.graphics.printf("< " .. self.sfx_volume .. " % >", 140 + dx, 51, 160, "center")
end

--- Draw label and current screen resolution
-- @tparam number dx Delta of x axis
function settings:draw_resolution(dx)
	-- Resolution
	width = math.ceil(app.width * self.resolutions[self.scalefactor])
	height = math.ceil(app.height * self.resolutions[self.scalefactor])
	
	-- Draw resolution volume label
	love.graphics.setColor(0, 0, 0)
	love.graphics.draw(txt.resolution, 41 + dx, 75)
	love.graphics.setColor(255, 224, 0)
	love.graphics.draw(txt.resolution, 40 + dx, 74)
	-- If fullscreen, show disable color
	if self.fullscreen then
		love.graphics.setColor(128, 128, 128)
	else
		love.graphics.setColor(255, 255, 255)
	end
	-- Draw current resolution value
	love.graphics.printf("< " .. width .. "x" .. height .. " >", 140 + dx, 75, 160, "center")
end

--- Draw label and current fullscreen value
-- @tparam number dx Delta of x axis
function settings:draw_fullscreen(dx)
	-- Draw resolution volume label
	love.graphics.setColor(0, 0, 0)
	love.graphics.draw(txt.fullscreen, 41 + dx, 99)
	love.graphics.setColor(255, 224, 0)
	love.graphics.draw(txt.fullscreen, 40 + dx, 98)
	love.graphics.setColor(255, 255, 255)
	-- Draw if fullscreen is enable or disable
	if self.fullscreen then
		love.graphics.printf("< " .. msg_string.enabled .. " >", 140 + dx, 99, 160, "center")
	else
		love.graphics.printf("< " .. msg_string.disabled .. " >", 140 + dx, 99, 160, "center")
	end
end

--- Draw label and current language
-- @tparam number dx Delta of x axis
function settings:draw_language(dx)
	-- Language
	dot = string.find(self.languages[self.language], "%.")
	language = string.sub(self.languages[self.language], 1, dot-1):gsub("^%l", string.upper)

	-- Draw language label
	love.graphics.setColor(0, 0, 0)
	love.graphics.draw(txt.language, 41 + dx, 123)
	love.graphics.setColor(255, 224, 0)
	love.graphics.draw(txt.language, 40 + dx, 122)
	love.graphics.setColor(255, 255, 255)
	-- Draw current language
	love.graphics.printf("< " .. language .. " >", 140 + dx, 123, 160, "center")
end

--- Draw credits label
-- @tparam number dx Delta of x axis
function settings:draw_credits(dx)
	-- Draw credits label
	love.graphics.setColor(0, 0, 0)
	love.graphics.draw(txt.credits, 41 + dx, 147)
	love.graphics.setColor(255, 224, 0)
	love.graphics.draw(txt.credits, 40 + dx, 146)
end

--- Draw settings menu
function settings:draw()
	-- Delta of menu
	delta = app.width - menu.delta
	
	-- Draw selection mark
	love.graphics.setColor(255, 255, 255)
	y0 = math.round(txt.mark_bold:getHeight()/2)
	love.graphics.draw(txt.mark_bold, 20 + delta, 32 + (self.option - 1) * 24, 0, 1, 1, 0, y0)

	-- Draw option menus
	settings:draw_music_volume(delta)
	settings:draw_sfx_volume(delta)
	settings:draw_resolution(delta)
	settings:draw_fullscreen(delta)
	settings:draw_language(delta)
	settings:draw_credits(delta)
end