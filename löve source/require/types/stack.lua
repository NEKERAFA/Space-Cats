--[[
	Created by NEKERAFA on fri 26 feb 2016 19:29:03 (CET)
	License by Creative Commons Attribution-ShareAlike 4.0
	http://creativecommons.org/licenses/by-sa/4.0/
    
	**** MODULE STACK ****
	Implement a stack type of elements

	stack.new( number n ) : stack
	-- Creates a new stack

	stack:empty() : boolean
	-- Return true if the stack is empty

	stack:full() : boolean
	-- Return true if the stack is full

	stack:clear() : nill
	-- Clear the stack

	stack:size() : number
	-- Return the size of stack

	stack:push( element e ) : nil
	-- Add a element to the stack (Always in the last position)

	stack:peek() : element
	-- Return the element in the peek of the stack

	stack:pop() : element
	-- Remove the element in the stack (Always in the last position)

	stack:search( element e ) : boolean
	-- Search a element in the stack

	stack:iterate()
	-- Iterate the stack. Use in for ... in loops (Warning: this function use pairs, see reference)

	stack:pack( ... ) : nil
	-- Insert the list of element in the stack

	stack:unpack() : ...
	-- Return a list with all elements of the stack

	stack:concat( sep ) : string
	-- Return a string that concats the elements of the stack
]]

require "lib/collection"

stack = {}
-- Crea un stack
function stack.new(n)
	-- Atributos
	local method = {}
	local metamethod = {}
	local new_stack = collection.new(n)

	-- Tamaño del stack
	function method:size()
		return new_stack:size()
	end

	-- Si el stack está vacio
	function method:empty()
		return new_stack:empty()
	end

	-- Si el stack está lleno
	function method:full()
		return new_stack:full()
	end

	-- Limpia el stack
	function method:clear()
		new_stack:clear()
	end

	-- Mete un elemento en el stack
	function method:push(e)
		if new_stack:full() then error("error in push (stack overflow)", 2) end
		new_stack:add(e)
	end

	-- Elimina un elemento del stack
	function method:pop()
		if new_stack:empty() then error("error in pop (stack underflow)", 2) end
		return new_stack:remove()
	end
	
	-- Muestra el elemento de la cima
	function method:peek()
		return new_stack:get()
	end

	-- Busca un elemento en el stack
	function method:search(e)
		return (new_stack:search(e) ~= nil)
	end

	-- Función iteradora de la colección
	function method:iterate()
		return new_stack:iterate()
	end

	-- Empaqueta la lista de elementos en la colección
	function method:pack(...)
		list = {...}
		for k, v in pairs(list) do
			if new_stack:full() then error("error in pack (stack overflow)", 2) end
			new_stack:add(v)
		end
	end

	-- Devuelve una lista con todos los elementos
	function method:unpack()
		return new_stack:unpack()
	end

	-- Devuelve un string con los elementos concatenados de la colección
	function method:concat(sep)
		return new_stack:concat(sep)
	end

	-- Se puede concatenar con .. dos colecciones
	metamethod.__concat = function (s)
		for k, v in s:interate() do method:push(v) end
	end
	
	-- Obtener la longitud
	metamethod.__len = method:size()

	return setmetatable(method, metamethod)
end