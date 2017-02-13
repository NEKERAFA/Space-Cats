--- Löve configuration script
--
-- @author	Rafael Alcalde Azpiazu (NEKERAFA)
-- @license GNU General Public License v3
-- @version 1.0

-- A new global table
love.game = {path = love.filesystem.getSource()}

-- Add library path to require
package.path = love.game.path .. "lib/?/init.lua;" .. love.game.path .. "lib/?.lua;" .. package.path

love.scalefactor = 4

function love.conf(t)
    t.version = "0.10.0"
    t.console = false

    t.window.title = "Space cats!"
    t.window.width = 320*love.scalefactor
    t.window.height = 180*love.scalefactor
    t.window.vsync = true
    t.window.highdpi = true
end

function love.game.getWidth()
    return 320
end

function love.game.getHeight()
    return 180
end

function love.game.frameRate()
    return 60
end
