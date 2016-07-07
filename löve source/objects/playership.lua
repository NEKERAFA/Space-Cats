--[[
    * playership.lua
	* Nave del jugador, es un gatico cute
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

-- Modulo nave
playership = {}
 
local ship_cat = love.graphics.newImage("images/ships/ship-cat.png")
local ship_flame = love.graphics.newImage("images/ships/combustion.png")
ship_cat:setFilter("nearest")
ship_flame:setFilter("nearest")

-- Prototipo de nave
function playership.new(x, y, life)
    -- Variables y métodos privados
    local ship = ship.new(x, y, life) -- Nave
	local invulnerabity = timer.new() -- Establece un momento de invulnerabilidad
	local blended = false -- Si está con el shader blend
	local flame = anim.newAnimatedSprite(0, 0) -- Animación del fuego del motor
	local weapon = weapon.new(250) -- Arma
	
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
		if ship.life > 0 and invulnerabity:getTime() == 0 then
			ship.life = ship.life - 1
			invulnerabity:start(2000)
		end
	end
	
	-- Devuelve verdadero si está destruida la nave
	function public:isKilled()
		return ship.life == 0
	end
	
	-- Función para actualizar los elementos internos
	function public:update(dt)
		if invulnerabity:isFinished() then
			invulnerabity:stop()
			flame.color = {255, 255, 255, 255}
		end
		flame:update(dt)
		weapon:update(dt)
	end
	
	-- Función para rederizar la nave
	function public:render()
		local r, g, b, a = love.graphics.getColor()
		weapon:render()
		-- Ajustamos primero los shaders
		if invulnerabity:getTime() > 0 then
			love.graphics.setColor(255, 255, 255, 255-math.abs((invulnerabity:getTime()%511)-255))
			flame.color = {255, 255, 255, 255-math.abs((invulnerabity:getTime()%511)-255)}
		end
		-- Mostramos la nave y el fuego
		love.graphics.draw(ship_cat, ship.x, ship.y, 0, 1, 1, 16, 16)
		flame:draw(ship.x-24, ship.y)
		love.graphics.setColor(r, g, b, a)
	end

	-- Función para mover la nave
	function public:move(dt)
		-- Movimiento de la nave
		if love.keyboard.isDown("up") then
			ship.y = ship.y - 150*dt
		elseif love.keyboard.isDown("down") then
			ship.y = ship.y + 150*dt
		elseif love.keyboard.isDown("left") then
			ship.x = ship.x - 150*dt
		elseif love.keyboard.isDown("right") then
			ship.x = ship.x + 150*dt
		end
		
		-- Dispara la nave
		if love.keyboard.isDown("space") then
			weapon:shoot(ship.x+16, ship.y, 4)
		end
		
		-- Para que no se salga de la pantalla
		ship.y = math.max(16, math.min(love.game.getHeight()-16, ship.y))
		ship.x = math.max(16, math.min(love.game.getWidth()-16, ship.x))
	end

	-- Obtiene la hitbox de la nave
	function public:getHitBox()
		return {x = ship.x-ship_cat:getWidth()/2,
			    y = ship.y-ship_cat:getHeight()/2,
				w = ship_cat:getWidth(),
				h = ship_cat:getHeight()}
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
		invulnerabity:free()
		invulnerabity = nil
		flame = nil
		weapon:free()
		weapon = nil
		ship:free()
		ship = nil
		public.bullet = nil
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