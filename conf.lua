--- Löve configuration script
--
-- @author	Rafael Alcalde Azpiazu (NEKERAFA)
-- @license GNU General Public License v3
-- @release 0.1

-- A new global table
love.game = {path = love.filesystem.getSource() .. "/", width = 320, height = 180, frameRate = 60, version = "0.6 (alphaka)"}

-- Add library path to require
package.path = love.game.path .. "lib/nekerafa/collections/src/?.lua;" .. package.path
package.path = love.game.path .. "src/main/objects/?.lua;" .. package.path
package.path = love.game.path .. "lib/?.lua;" .. package.path
package.path = love.game.path .. "lib/?/init.lua;" .. package.path

--- Global scalefactor
love.game.scalefactor = 4

function love.conf(t)
    t.version = "0.10.0"
    t.console = false

    t.window.title = "Space cats!"
    t.window.width = love.game.width*love.game.scalefactor
    t.window.height = love.game.height*love.game.scalefactor
    t.window.vsync = true
    t.window.highdpi = true
end
