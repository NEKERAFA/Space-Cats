--[[
	Created by NEKERAFA on thu 16 jun 2016 22:17:43 (CET)
	License by Creative Commons Attribution-ShareAlike 4.0
	http://creativecommons.org/licenses/by-sa/4.0/
	
	timer.lua
	
	Biblioteca para Löve que añade contadores y temporizadores
]]

-- Modulo timer
timer = {}

-- Crea un nuevo contador o temporizador
function timer.new()

	-- Atributos y metodos privados
	local started = 0
	local paused = 0
	local counter = 0
	local running = false
	
	-- Atributos y metodos publicos
	method = {}
	
	-- Inicia el temporizador. Si se pone una cuenta para cuando llega a la cuenta.
	function method:start( count )
		if count then
			started = love.timer.getTime()
			paused = 0
			counter = count
			running = true
		else
			started = love.timer.getTime()
			paused = 0
			counter = 0
			running = true
		end
	end
	
	-- Detiene el temporizador, haya llegado o no a la cuenta objetivo
	function method:stop()
		started = 0
		paused = 0
		counter = 0
		running = false
	end
	
	-- Pausa un temporizador
	function method:pause()
		if not self:isFinished() then
			if running then
				running = false
				paused = love.timer.getTime()
			end
		end
	end
	
	-- Reinicia un temporizador
	function method:resume()
		if not running then
			running = true
			started = started + (love.timer.getTime() - paused)
			paused = 0
		end
	end
	
	-- Muestra el tiempo del contador
	function method:getTime()
		self:isFinished()
		nowtime = love.timer.getTime()
		if running then
			return math.floor((love.timer.getTime() - started)*1000)
		else
			return math.floor((paused - started)*1000)
		end
	end
	
	-- Devuelve verdadero si el temporizador está iniciado
	function method:isRunning()
		return running
	end
	
	-- Devuelve verdadero si el temporizador ha terminado
	function method:isFinished()
		if counter > 0 then
			actTime = math.floor((love.timer.getTime() - started)*1000)
		
			if actTime > counter then
				paused = started + (counter/1000)
				running = false
				return true, (actTime - counter)
			end
			
			return false, (actTime - counter)
		end
		
		return nil
	end
	
	-- Libera el temporizador
	function method:free()
		started = nil
		paused = nil
		counter = nil
		running = nil
		method = nil
		collectgarbage("collect")
	end
	
	return method
end