--[[
    * ship.lua
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

-- Modulo nave
ship = {}

-- Prototipo de nave
function ship.new(x, y, life)
    -- Variables y métodos públicos
    public = {}
	
	public.x = x or 0
	public.y = y or 0
	public.life = life or 0
    
	-- Obtiene la posición X
    -- function public:getX() end
    
	-- Obtiene la posición Y
    -- function public:getY() end
    
	-- Obtiene la vida
    -- function public:getLife() end
    
	-- Aplica daño a la nave
    -- function public:makeDamage() end
	
	-- Devuelve verdadero si está destruida la nave
	-- function public:isKilled() end
	
	-- Función para actualizar los elementos internos
	-- function public:update() end
	
	-- Función para rederizar la nave
	-- function public:render() end

	-- Función para mover la nave
	-- function public:move() end

	-- Obtiene la hitbox de la nave
	-- function public:getHitBox() end
	
	-- Funciones para las balas
	-- public.bullet = {}

	-- Obtiene la hitbox de la bala
	-- function public.bullet:getHitBox(i) end
	
	-- Destruye la bala
	-- function public.bullet:kill(i) end
	
	-- Libera la bala
	function public:free()
		-- x = nil
		-- y = nil
		-- life = nil
		-- public.bullet = nil
		public = nil
		collectgarbage('collect')
	end
	
    return public
end