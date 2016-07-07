--[[
	Created by NEKERAFA on fri 26 feb 2016 19:29:03 (CET)
	License by Creative Commons Attribution-ShareAlike 4.0
	http://creativecommons.org/licenses/by-sa/4.0/
    
	**** MODULE QUEUE ****
	Implement a queue type of elements

	queue.new( number n ) : queue
	-- Creates a new queue

	queue:empty() : boolean
	-- Return true if the queue is empty

	queue:full() : boolean
	-- Return true if the queue is full

	queue:clear() : nill
	-- Clear the queue

	queue:size() : number
	-- Return the size of queue

	queue:push( element e ) : nil
	-- Add a element to the queue (Always in the last position)

	queue:front() : element
	-- Return the element in the peek of the queue

	queue:pop() : element
	-- Remove the element in the queu (Always in the first position)

	queue:search( element e ) : boolean
	-- Search a element in the queue

	queue:iterate()
	-- Iterate the queue. Use in for ... in loops (Warning: this function use pairs, see reference)

	queue:pack( ... ) : nil
	-- Insert the list of element in the queue

	queue:unpack() : ...
	-- Return a list with all elements of the queue

	queue:concat( sep ) : string
	-- Return a string that concats the elements of the queue
]]

require "lib/collection"

queue = {}
-- Crea una cola
function queue.new(n)
	-- Atributos
	local method = {}
	local metamethod = {}
	local new_queue = collection.new(n)

	-- Tamaño de la cola
	function method:size()
		return new_queue:size()
	end

	-- Si la cola está vacia
	function method:empty()
		return new_queue:empty()
	end

	-- Si la cola está llena
	function method:full()
		return new_queue:full()
	end

	-- Limpia la cola
	function method:clear()
		new_queue:clear()
	end

	-- Mete un elemento en la cola
	function method:push(e)
		if new_queue:full() then error("error in push (queue overflow)", 2) end
		new_queue:add(e)
	end

	-- Elimina un elemento de la cola
	function method:pop()
		if new_queue:empty() then error("error in pop (queue underflow)", 2) end
		return new_queue:remove(1)
	end
	
	-- Muestra el elemento del frente de la cola
	function method:front()
		return new_queue:get(1)
	end

	-- Busca un elemento en la cola
	function method:search(e)
		return (new_queue:search(e) ~= nil)
	end

	-- Función iteradora de la colección
	function method:iterate()
		return new_queue:iterate()
	end

	-- Empaqueta la lista de elementos en la colección
	function method:pack(...)
		list = {...}
		for k, v in pairs(list) do
			if new_queue:full() then error("error in pack (queue overflow)", 2) end
			new_queue:add(v)
		end
	end

	-- Devuelve una lista con todos los elementos
	function method:unpack()
		return new_queue:unpack()
	end

	-- Devuelve un string con los elementos concatenados de la colección
	function method:concat(sep)
		return new_queue:concat(sep)
	end

	-- Se puede concatenar con .. dos colecciones
	metamethod.__concat = function (s)
		for k, v in s:interate() do method:push(v) end
	end
	
	-- Obtener la longitud
	metamethod.__len = method:size()

	return setmetatable(method, metamethod)
end