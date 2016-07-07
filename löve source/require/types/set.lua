--[[
	**** MODULE SET ****
	Implement a set of elements
	
	set.new(t) : set
	-- Creates a new set

	set:empty() : boolean
	-- Return true if the set is empty

	set:clear() : nil
	-- Clear the set

	set:size() : number
	-- Return the size of the set

	set:add( element e ) : nil
	-- Add a element to the set

	set:remove( element e ) : nil
	-- Remove a element in the set

	set:search( element e ) : boolean
	-- Search a element in the queue

	set:union( set s ) : set
	-- Returns new set union of the set or s
	-- Also you can use + operator

	set:intersect( set s ) : set
	-- Returns new set intersection of the set and s
	-- Also you can use ^ operator
	
	set:complement( set s ) : set
	-- Returns new set complement of the set minus s
	-- Also you can use - operator
	
	set:product( set s ) : map
	-- Returns a map that is the cartesian product of the set and s
	-- Also you can use * operator
	
	set:subset( set s ) : boolean
	-- Returns if s is a subset
	
	set:iterate()
	-- Iterate the set. Use in for ... in loops

	set:pack( ... ) : nil
	-- Insert the list of element in the queue

	set:unpack() : ...
	-- Return a list with all elements of the queue

	set:concat( sep ) : string
	-- Return a string that concats the elements of the set
]]

require "lib/arraymap"

set = {}
-- Crea un conjunto
function set.new(t)
	if type(t) ~= "table" and type(t) ~= "nil" then error("bad argument #1 to new (table expected, got "..type(t)..")", 2) end

	-- Variables privadas
	local data = setmetatable({}, {__mode="kv", __metatable = nil})	
	local size = 0
	if t then
		for k, v in ipairs(t) do
			data[v] = true; size = size+1
		end
	end

	-- Metodos públicos
	local method = {}
	local metamethod = {}
	
	-- Tamaño del conjunto
	function method:size()
		return size
	end

	-- Si el conjunto está vacio
	function method:empty()
		return size == 0
	end

	-- Limpia el conjunto
	function method:clear()
		data = {}
		size = 0
	end

	-- Mete un elemento en el conjunto
	function method:add(e)
		if not data[e] then data[e] = true; size = size+1 end
	end
	
	-- Elimina un elemento del conjunto
	function method:remove(e)
		if data[e] ~= nil then data[e] = nil; size = size-1 end
	end

	-- Busca un elemento en el conjunto
	function method:search(e)
		return data[e] == true
	end

	-- Devuelve un conjunto unión del conjunto o s
	function method:union(s)
		local union = set.new()
		for e in self.iterate() do u:add(e) end
		for e in s:iterate() do u:add(e) end
		return union
	end
	
	-- La unión se puede hacer con el operador +
	metamethod.__add = method.union

	-- Devuelve un conjunto intersección del conjunto y s
	function method:intersect(s)
		local inter = set.new()
		for e1 in self.iterate() do
			for e2 in s:iterate() do
				if e1 == e2 then inter:add(e1) end
			end
		end
		return inter
	end

	-- La intersección se puede hacer con el operador ^
	metamethod.__pow = method.intersect
	
	-- Devuelve el complemento de conjunto menos s
	function method:complement(s)
		local comp = set.new()
		for e in self.iterate() do comp:add(e) end
		for e in s:iterate() do comp:remove(e) end
		return comp
	end

	-- El complemento se puede hacer con el operador -
	metamethod.__sub = method.complement
	
	-- Devuelve el producto cartesiano de un conjunto (Mediante un arraymap)
	function method:product(s)
		local prod = arraymap.new()
		for e1 in self.iterate() do
			for e2 in s:iterate() do prod:set(e1, e2) end
		end
		return prod
	end
	
	metamethod.__mul = method.product
	
	-- Comprueba si un conjunto es subconjunto
	function method:subset(s)
		if s:size() > self.size() then return false end
		for e in s:iterate() do
			if not data[e] then return false end
		end
		return true
	end

	-- Inserta la lista de elementos en el conjunto
	function method:pack(...)
		for k, v in pairs(...) do
			data[k] = true; size = size+1
		end
	end

	-- Devuelve una lista con todos los elementos del conjunto
	function method:unpack()
		local pack = {}
		for k, v in pairs(data) do
			table.insert(pack, k)
		end
		return pack
	end

	-- Concatena y devuelve la lista
	function method:concat(sep)
		local str = ""
		for k, v in pairs(data) do
			str = k..sep
		end
		return str
	end

	-- Función iteradora de la colección
	function method:iterate()
		local e = nil
		return function ()
			e = next(data, e)
			return e
		end
	end
	
	-- Se puede concatenar con .. dos colecciones
	metamethod.__concat = function (s)
		for k in s:interate() do method:set(k) end
	end
	
	-- Obtener la longitud
	metamethod.__len = method:size
	
	metamethod.__tostring = method:concat

	return setmetatable(method, metamethod)
end