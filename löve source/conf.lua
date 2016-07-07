--[[
    * conf.lua
	* Archivo de configuración general de Löve
    * Creado por NEKERAFA el jue 23 jun 2016 18:54 (CEST)

	Space Cats es un juego Shoot'em up basado en una guerra espacial de gatos.

	Space Cats is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	Space Cats is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with Foobar. If not, see <http://www.gnu.org/licenses/>.
]]

-- A new global table
love.game = {}

scalefactor = 4

function love.conf(t)
    t.version = "0.10.0"
    t.console = false
    
    t.window.title = "Space cats!"
    t.window.width = 320*scalefactor
    t.window.height = 180*scalefactor
    t.window.vsync = true
    t.window.highdpi = true
end

function love.game.getWidth()
    return 320
end

function love.game.getHeight()
    return 180
end