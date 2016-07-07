--[[
    * main.lua
	* Archivo inicial del juego - "0.5.2 (alphaka)"
    * Creado por Rafael Alcalde Azpiazu (nekerafa@gmail.com) el jue 23 jun 2016 18:54 (CEST)

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
	along with Foobar.  If not, see <http://www.gnu.org/licenses/>.
]]

-- Bibliotecas requeridas

require "require/colision"
require "require/timer"
require "require/mathext"

-- Variables locales
local dtotal = 0
local dgb = 0
local ver = "0.5.2 (alphaka)"

hitbox = false

-- Cargamos los recursos
function love.load(arg)
    dofile("game.lua")
	--love.keyboard.setKeyRepeat(true)
end

-- Actualizamos los elementos del juego
function love.update(dt)
	game.update(dt)

	dtotal = dtotal + dt
	if dtotal >= 1 then
		title = string.format("%i FPS, %.2f KB", love.timer.getFPS(), collectgarbage("count"))
		love.window.setTitle(title)
		dtotal = dtotal - 1
	end
	
	dgb = dgb + dt
	if dgb >= 5 then
		collectgarbage("collect")
		dgb = dgb - 2
	end
end

function love.keypressed(key, scancode, isrepeat)
	if scancode == "return" then
		hitbox = not hitbox
	elseif scancode == "escape" then
		love.event.quit(0)
	end
end

-- Mostramos el juego
function love.draw()
    love.graphics.push()
    love.graphics.scale(scalefactor, scalefactor)
    game.show()
	love.graphics.printf({{255, 210, 0}, ver}, 10, love.game.getHeight()-20, love.game.getWidth(), "left") 
    love.graphics.pop()
end