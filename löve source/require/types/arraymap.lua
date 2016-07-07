--[[
	**** MODULE ARRAY MAP ****
	Implement a associative array or map type of elements
	A collision of same keys not overwrite previous value

	arraymap.new( elements table ) : arraymap
	-- Creates a new arraymap

	arraymap:empty() : boolean
	-- Return true if the arraymap is empty

	arraymap:clear() : nil
	-- Clear the arraymap

	arraymap:size() : number
	-- Return the size of queue

	arraymap:set( key, value ) : nil
	-- Add a pair (key, value) in the arraymap

	arraymap:get( key ): value
	-- Get first value of a key

	arraymap:getall( key ): value
	-- Get all value of a key

	arraymap:remove( key ) : value
	-- Remove first key from the arraymap
	
	arraymap:removeall( key ) : value
	-- Remove all key from the arraymap

	arraymap:find( value ) : boolean, key
	-- Search the first ocurrence in the collection and return it key

	arraymap:search( value ) : boolean, table key
	-- Search all elements in the collection and return their keys

	arraymap:iterate()
	-- Iterate the arraymap. Use in for ... in loops (Warning: this function use pairs, see reference)
]]

arraymap = {}
-- Crea un mapa hash
function arraymap.new(t)
	if type(t) ~= "table" and type(t) ~= "nil" then error("bad argument #1 to new (table expected, got "..type(t)..")", 2) end

	-- Atributos
	local data = setmetatable({}, {__mode="kv", __metatable = nil})
	local size = 0
	if t then
		for k, v in pairs(t) do
			table.insert(data, {k = k, v = v}); size = size+1
		end
	end
	
	-- Metodos públicos
	local method = {}
	local metamethod = {}

	-- Tamaño del array asociativo
	function method:size()
		return size
	end

	-- Si el array asociativo está vacio
	function method:empty()
		return size == 0
	end

	-- Limpia el array asociativo
	function method:clear()
		data = setmetatable({}, {__mode="kv", __metatable = nil})
		size = 0
	end

	-- Mete un par (clave, valor) en el array asociativo
	function method:set(k, v)
		table.insert(data, {k = k, v = v})
		size = size+1
	end

	-- Obtiene el primer valor del array asociativo
	function method:get(k)
		local value = nil
		for i = 1, size do
			if data[i].k == k then value = data[i].v; break end
		end
		return value
	end
	
	-- Obtiene todos los valores del array asociativo
	function method:getall(k)
		local value = {}
		for i = 1, size do
			if data[i].k == k then table.insert(value, data[i].v) end
		end
		return value
	end
	
	-- Elimina el primer elemento con clave k del mapa hash
	function method:remove(k)
		local value = nil
		for i = 1, size do
			if data[i].k == k then
				value = data[i].v
				table.remove(data, i); size = size-1; break
			end
		end
		return value
	end

	-- Elimina todos los elementos con clave k del mapa hash
	function method:removeall(k)
		local value = {}
		for i = 1, size do
			if data[i].k == k then
				table.insert(value, data[i].v)
				table.remove(data, i); size = size-1
			end
		end
		return value
	end

	-- Busca la primera clave con un valor en el mapa hash
	function method:find(value)
		key = nil
		for i = 1, size do
			if data[i].v == value then key = data[i].k; break end
		end
		return key ~= nil, key
	end

	-- Devuelve todas las claves con el valor dado en el mapa hash
	function method:search(value)
		local key = {}
		for i = 1, size do
			if data[i].v == value then table.insert(key, data[i].k) end
		end
		return key ~= {}, key
	end

	-- Función iteradora de la colección
	function method:iterate()
		local i = 0
		return function ()
			i = i+1
			if i > size then return nil end
			return data[i].k, data[i].v 
		end
	end

	local function concat(m1, m2)
		for k, v in m2:iterate() do m1:set(k, v) end
	end

	-- Se puede concatenar con .. dos colecciones
	metamethod.__concat = concat
	
	-- Obtener la longitud
	metamethod.__len = method:size()

	return setmetatable(method, metamethod)
end