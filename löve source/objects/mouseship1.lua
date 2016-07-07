--[[
    * mouseship1.lua
	* Nave enemiga, es un ratón pequeño
    * Creado por Rafael Alcalde Azpiazu el jue 23 jun 2016 18:54 (CEST)

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

if not ship then require "objects/ship" end

local weapon = require "require/weapon"
local anim = require "require/sodapop"
local point = require "require/types/point"
local vector = require "require/types/vector"

-- Modulo nave
mouseship_1 = {}
 
local ship_mouse = love.graphics.newImage("images/ships/ship-mouse.png")
local ship_flame = love.graphics.newImage("images/ships/combustion.png")
ship_mouse:setFilter("nearest")
ship_flame:setFilter("nearest")

-- Prototipo de nave
function mouseship_1.new(x, y, v, shot, topoint, toexit)
    -- Variables y métodos privados
    local ship = ship.new(x, y, 2) -- Nave
	local topoint = topoint
	local toexit = toexit
	local vel = v
	local shot = shot
	local flame = anim.newAnimatedSprite(0, 0) -- Animación del fuego del motor
	local weapon = weapon.new(100) -- Arma
	local state = 0
	
	flame.flipX = true
	flame:addAnimation('run', {
		image       = ship_flame,
		frameWidth  = 16,
		frameHeight = 16,
		frames      = {
			{1, 1, 1, 4, 0.05}
		}
	})

    -- Variables y métodos públicos
    public = {}
    
	-- Obtiene la posición X
    function public:getX()
        return math.round(ship.x)
    end
    
	-- Obtiene la posición Y
    function public:getY()
        return math.round(ship.y)
    end
    
	-- Obtiene la vida
    function public:getLife()
        return ship.life
    end
    
	-- Aplica daño a la nave
    function public:makeDamage()
		if ship.life > 0 then
			ship.life = ship.life - 1
		end
	end
	
	-- Devuelve verdadero si está destruida la nave
	function public:isKilled()
		return ship.life == 0
	end
	
	-- Función para actualizar los elementos internos
	function public:update(dt)
		flame:update(dt)
		weapon:update(dt)
	end
	
	-- Función para rederizar la nave
	function public:render()
		-- Mostramos la nave, el fuego y las balas
		weapon:render()
		love.graphics.draw(ship_mouse, ship.x, ship.y, 0, 1, 1, 16, 16)
		flame:draw(ship.x+24, ship.y)
	end

	-- Función para mover la nave
	function public:move(dt)
		if ship.life > 0 then
			if state == 0 then
				local d = vector.new(point.new(ship.x, ship.y), topoint)
				
				if (d:magnitude() < 1.5) and (d:magnitude() > -1.5) then state = 1 end
				
				local v = vector.new(d, vel)
				
				ship.x = ship.x + v:x() * 100 * dt
				ship.y = ship.y + v:y() * 100 * dt
			elseif state == 1 then
				if weapon:shotBullets() < shot then
					weapon:shoot(ship.x-8, ship.y, -4)
				else state = 2 end
			elseif state == 2 then
				local d = vector.new(point.new(ship.x, ship.y), toexit)
				
				if (d:magnitude() < 1.5) and (d:magnitude() > -1.5) then state = 3 end
				
				local v = vector.new(d, vel)
				
				ship.x = ship.x + v:x() * 100 * dt
				ship.y = ship.y + v:y() * 100 * dt
			end
		end
	end
	
	-- Obtiene el estado actual
	function public:getState()
		return state
	end

	-- Obtiene la hitbox de la nave
	function public:getHitBox()
		return {x = ship.x-ship_mouse:getWidth()/2,
			    y = ship.y-ship_mouse:getHeight()/2,
				w = ship_mouse:getWidth(),
				h = ship_mouse:getHeight()}
	end
	
	-- Funciones para las balas
	public.bullet = {}

	-- Obtiene la hitbox de la bala
	function public.bullet:getHitBox(i)
		return weapon:getHitBox(i)
	end
	
	-- Destruye la bala
	function public.bullet:kill(i)
		weapon:kill(i)
	end

	-- Cantidad de balas disparadas
	function public.bullet:shotBullets()
		return weapon:shotBullets()
	end
	
	-- Libera la nave y sus variables
	function public:free()
		topoint = nil
		state = nil
		vel = nil
		shot = nil
		flame = nil
		weapon:free()
		weapon = nil
		ship:free()
		ship = nil
		public = nil
		collectgarbage('collect')
		return true
	end
	
    return public
end

function playership.free()
	ship_cat = nil
	ship_flame = nil
	weapon = nil
	anim = nil
	collectgarbage('collect')
	return true
end