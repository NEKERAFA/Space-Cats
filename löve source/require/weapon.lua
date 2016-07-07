--[[
    Created by NEKERAFA on thu 29 jun 2016 19:34:24 (CEST)
	License by Creative Commons Attribution-ShareAlike 4.0
	http://creativecommons.org/licenses/by-sa/4.0/
	
	weapon.lua
	
	Biblioteca para añadir armas y particulas de disparos
]]

-- Modulo weapon
local weapon = {}

-- Imagen de la bala
weapon.ball = love.graphics.newImage("images/ships/ball.png")
weapon.ball:setFilter("nearest")

function weapon.new(time)
    -- Variables y métodos privados
    local bullets = {}
	local shoot_bullet = timer.new()
	local shoot_time = time

    -- Variables y métodos públicos
    public = {}
	
	-- Muestra las balas
	function public:render()
		for k, bullet in ipairs(bullets) do
			love.graphics.draw(weapon.ball, bullet.x, bullet.y, 0, 1, 1, weapon.ball:getWidth()/2, weapon.ball:getHeight()/2)
		end
	end
	
	-- Actualiza las balas
	function public:update(dt)
		for i = 1, #bullets do
			bullet = bullets[i]
			bullet.x = bullet.x + bullet.v*dt*100
			if (bullet.x < 0) or (bullet.x > love.game.getWidth()) then
				table.remove(bullets, i)
				break;
			end
		end
		
		if shoot_bullet:isFinished() then
			shoot_bullet:stop()
		end
	end
	
	-- Dispara una bala
	function public:shoot(x, y, v)
		if shoot_bullet:getTime() == 0 then
			table.insert(bullets, {x = x, y = y, v = v})
			shoot_bullet:start(shoot_time)
		end
	end
	
	-- Destruye una bala
	function public:kill(i)
		if not bullets[i] then error("Bullet "..i.." doesn't exist", 2) end
		table.remove(bullets, i)
	end
	
	-- Obtiene el numero de balas disparadas
	function public:shotBullets()
		return #bullets
	end
	
	-- Obtiene la hitbox de una bala
	function public:getHitBox(i)
		if not bullets[i] then error("Bullet "..i.." doesn't exist", 2) end
		
		bullet = bullets[i]
		return {x = bullet.x-weapon.ball:getWidth()/2,
		        y = bullet.y-weapon.ball:getHeight()/2,
				h = weapon.ball:getHeight(),
				w = weapon.ball:getWidth()}
	end
	
	-- Libera los recursos
	function public:free()
		bullets = nil
		shoot_bullet:free()
		shoot_bullet = nil
		shoot_time = nil
		collectgarbage("collect")
	end
	
	return public
end

return weapon