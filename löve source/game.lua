--[[
    * game.lua
	* Definición de funciones generales del juego
    * Creado por rafael Alcalde Azpiazu el jue 23 jun 2016 18:54 (CEST)

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

-- Bibliotecas requeridas
require "objects/ship"
require "objects/playership"
require "objects/mouseship1"
local point = require "require/types/point"

-- Módulo del juego y de los shaders
game = {shaders = {}}

-- Tabla para las imagenes
local img = {}

-- Tabla para las estrellas
local star = {}

-- Variables
local player
local enemy

local up = true

-- Carga el juego completamente
function game.load()
    -- Fuentes
	print "Loading fonts"
    font = love.graphics.newFont("images/fonts/terminus.ttf")
	font:setFilter("nearest")
    love.graphics.setFont(font)

    -- Imágenes
	print "Loading images"
    img.bgspace = love.graphics.newImage("images/bg/space.png")
    img.bgspace:setFilter("nearest")
    img.life = love.graphics.newImage("images/hud/life.png")
    img.life:setFilter("nearest")
    img.star = love.graphics.newImage("images/bg/star.png")
    img.star:setFilter("nearest")
    game.load_stars()
	
	-- Shaders
	print "Loading shaders"
	game.load_shaders()
	
	-- Load las naves
	player = playership.new(32, love.game.getHeight()/2, 4)
	enemy = mouseship_1.new(love.game.getWidth()+32, 10, 2, 3, point.new(200, 90), point.new(128, -32))
	--enemy = mouseship_1.new(10, 10, 100, 0.5, point.new(200, 90))
end

-- Carga la estrellas
function game.load_stars()
    for i = 0, 8 do
        star[i] = {
            x = math.random(0, love.game.getWidth()),
            y = math.random(0, love.game.getHeight()),
            v = math.random(4, 8)
        }
    end
end

-- Carga los shaders
function game.load_shaders()
	-- Load blend shader
	game.shaders.blend = love.graphics.newShader("shaders/blend.glsl")
	-- Load colored shader
	game.shaders.fuzzy = love.graphics.newShader("shaders/fuzzy.glsl")
	-- Load 8-bit like shader
	game.shaders.less = love.graphics.newShader("shaders/lesscolours.glsl")
end

-- Muestra el cielo con las estrellas de fondo
function game.sky()
    love.graphics.draw(img.bgspace, 0, 0)
    for i = 0, 8 do
        if star[i].x < 0 then
			star[i].x = love.game.getWidth()
			star[i].y = math.random(0, love.game.getHeight())
			star[i].v = math.random(4, 8)
		end

        love.graphics.draw(img.star, star[i].x, star[i].y)
        star[i].x = star[i].x - star[i].v
    end
end

-- Muestra la vida
function game.life()
	for i = 1, player:getLife() do
		love.graphics.draw(img.life, (i-1)*18+160-(18*player:getLife()-2)/2, 9)
	end
end

-- Comprueba todas las colisiones del mundo
function game.collinders()
	if enemy then
		for i = 1, enemy.bullet:shotBullets() do
			colplayer = player:getHitBox()
			colenemy = enemy.bullet:getHitBox(i)

			if colision.rect(colplayer, colenemy) then
				player:makeDamage(); enemy.bullet:kill(i); break
			end
		end
	end
	
	for i =  1, player.bullet:shotBullets() do
		colplayer = player.bullet:getHitBox(i)
		colenemy = enemy:getHitBox()
		
		if colision.rect(colplayer, colenemy) then
			enemy:makeDamage(); player.bullet:kill(i); break
		end
	end
end

-- Muestra las hitbox
function game.showhitbox()
	love.graphics.setColor(255, 0, 0, 128)
	box = player:getHitBox()
	love.graphics.rectangle("fill", box.x, box.y, box.w, box.h)
	box = enemy:getHitBox()
	love.graphics.rectangle("fill", box.x, box.y, box.w, box.h)
	for i = 1, player.bullet:shotBullets() do
		box = player.bullet:getHitBox(i)
		love.graphics.rectangle("fill", box.x, box.y, box.w, box.h)
	end
	for i = 1, enemy.bullet:shotBullets() do
		box = enemy.bullet:getHitBox(i)
		love.graphics.rectangle("fill", box.x, box.y, box.w, box.h)
	end
	love.graphics.setColor(255, 255, 255, 255)
end

-- Actualiza el mundo
function game.update(dt)
	game.collinders()
	player:update(dt)
	player:move(dt)
	if enemy then
		enemy:update(dt)
		enemy:move(dt)
		if enemy:isKilled() or (enemy:getState() == 3) then
			enemy:free();
			if up then
				enemy = mouseship_1.new(love.game.getWidth()+32, 170, 2, 3, point.new(200, 90), point.new(128, love.game.getWidth()+32))
				up = false
			else
				enemy = mouseship_1.new(love.game.getWidth()+32, 10, 2, 3, point.new(200, 90), point.new(128, -32))
				up = true
			end
		end
	end
end

-- Mueve el juego
function game.move(scancode, isrepeat)
end

-- Muestra el juego
function game.show()
	--love.graphics.setShader(game.shaders.less)
    game.sky()
	player:render()
	if enemy then enemy:render() end
	game.life()
	if hitbox then game.showhitbox() end
	love.graphics.print(player:getX()..", "..player:getY(), 5, 5)
	love.graphics.setShader()
end

-- Una vez cargado el archivo... Muestra el juego
game.load()