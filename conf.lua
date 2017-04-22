--- Löve configuration script
--
-- @author	Rafael Alcalde Azpiazu (NEKERAFA)
-- @license GNU General Public License v3
-- @release 0.1

-- A new global table
love.game = {path = love.filesystem.getSource() .. "/"}

-- Add library path to require
package.path = love.game.path .. "lib/nekerafa/collections/src/?.lua;" .. package.path
package.path = love.game.path .. "src/main/objects/?.lua;" .. package.path
package.path = love.game.path .. "lib/?.lua;" .. package.path
package.path = love.game.path .. "lib/?/init.lua;" .. package.path

--- Global scalefactor
love.scalefactor = 1

function love.conf(t)
    t.version = "0.10.0"
    t.console = false

    t.window.title = "Space cats!"
    t.window.width = 320*love.scalefactor
    t.window.height = 180*love.scalefactor
    t.window.vsync = true
    t.window.highdpi = true
end

--- Get width of game
function love.game.getWidth()
    return 320
end

--- Get height of game
function love.game.getHeight()
    return 180
end

--- Get frame rate (60 fps)
function love.game.frameRate()
    return 60
end
