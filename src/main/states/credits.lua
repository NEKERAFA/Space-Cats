--- This module load and show game credits
--
-- @author	Rafael Alcalde Azpiazu (NEKERAFA)
-- @license GNU General Public License v3

local gamestate = require "lib.vrld.hump.gamestate"

-- Module credits
credits = {}

--- Load credits text
function credits:init()
	credits.text = {
		"This game was created and developed by NEKERAFA",
		"Images, sounds, fonts and all non-code binary files are free for use and distribution. Check all license files for more information.",
		"",
		"",
		"-- GRAPHIC DESING --",
		"",
		"",
		"Graphics and images are designed by NEKERAFA under GPLv3",
		"Use by own risk :3",
		"",
		"",
		"Pixel Operator Font",
		"(c) 2009-2016 Jayvee Enaguas (HarvettFox96)",
		"Under SIL OFL 1.1",
		"",
		"",
		"",
		"-- MUSIC BACKGROUND --",
		"All music are downloaded from OpenGameArt.org",
		"",
		"",
		"Space - Main theme",
		"Alexandr Zhelanov",
		"Under License CC-BY 3.0",
		"",
		"",
		"Brave Space Explorers",
		"Alexandr Zhelanov",
		"Under License CC-BY 4.0",
		"",
		"",
		"",
		"-- SOUND EFFECTS --",
		"All sound effects are downloaded from FreeSound.org",
		"",
		"",
		"explosion-02",
		"Jesús Lastra (jalastram)",
		"Under License CC-BY 3.0",
		"",
		"",
		"GUI Sound Effects",
		"effect29, effect38, effect39",
		"Jesús Lastra (jalastram)",
		"Under License CC-BY 3.0",
		"",
		"",
		"laser3",
		"Nikola Stojsic (nsstudios)",
		"Under License CC-BY 3.0",
		"",
		"",
		"Mech-Keyboard-01",
		"NewAgeSoup (Mark)",
		"Under License CC0 1.0",
		"",
		"",
		"",
		"--  LIBRARIES AND THIRD TOOLS --",
		"",
		"",
		"HC collision detection",
		"Helper Utilities for a Multitude of Problems",
		"Copyright (c) 2011-2015 Matthias Richter",
		"Under MIT license",
		"",
		"",
		"Anim8 library",
		"Copyright (c) 2011 Enrique García Cota",
		"Under MIT License",
		"",
		"",
		"0.10.1 Splash libary",
		"Copyright (c) 2016 love-community members (as per git commits in repository)",
		"The official LÖVE assets are licensed under the zlib license aswell",
		"",
		"",
		"RPG Talk library",
		"Copyright (c) 2017 Rafael Alcalde Azpiazu",
		"Under MIT License",
		"",
		"",
		"Made with LÖVE 0.10.2",
		"Copyright (c) 2006-2017 LÖVE Development Team",
		"Under ZLIB License",
		"",
		"",
		"Powered by Lua",
		"Copyright (c) 1994–2017 Lua.org, PUC-Rio.",
		"Under MIT license",
		"",
		"",
		"",
		"",
		"SPACE CATS IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"Space Cats (c) 2017 Rafael Alcalde Azpiazu (NEKERAFA)"
	}
end

-- Set initial variables
function credits:enter()
	credits.offset = 190
	credits.width = 0
end

--- Update credits variables
-- @tparam number dt Time since the last update in seconds
function credits:update(dt)
	credits.offset = credits.offset - 0.5 * app.frameRate * dt
	-- Credits finish condition
	if (credits.width > 0) and (credits.offset <= (- credits.width - 10)) then
		gamestate.switch(menu)
	end
end

--- Update credits variables
-- @tparam KeyConstant key Character of the pressed key
-- @tparam Scancode scancode The scancode representing the pressed key
-- @tparam bolean isrepeat Whether this key press event is a repeat. The delay between key depends on the user's system settings
function credits:keypressed(key, scancode, isrepeat)
	if scancode == app.accept then
		gamestate.switch(menu)
	end
end

--- Draw credits animation
function credits:draw()
	text_line = love.graphics.newText(app.font, "")
	credits.width = 0
	
	for i, text in ipairs(credits.text) do
		text_line:setf(text, 300, "center")
		love.graphics.draw(text_line, 10, credits.offset + credits.width)
		if text == "" then
			credits.width = credits.width + 10
		else
			credits.width = credits.width + text_line:getHeight() + 2
		end
	end
end