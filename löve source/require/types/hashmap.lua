--[[
	**** MODULE HASH MAP ****
	Implement a associative hash array or hashmap type of elements
	A collision of same keys overwrite previous value

	hashmap.new( elements table ) : hashmap
	-- Creates a new hashmap

	map:empty() : boolean
	-- Return true if the hashmap is empty

	hashmap:clear() : nil
	-- Clear the hashmap

	hashmap:size() : number
	-- Return the size of queue

	hashmap:set( key, value ) : nil
	-- Add a pair (key, value) in the hashmap

	hashmap:get( key ): value
	-- Get value of a key

	hashmap:remove( key ) : value
	-- Remove the key from the hashmap

	hashmap:find( value ) : boolean, key
	-- Search the first ocurrence in the collection and return it key

	hashmap:search( value ) : boolean, table key
	-- Search all elements in the collection and return their keys

	hashmap:iterate()
	-- Iterate the hashmap. Use in for ... in loops (Warning: this function use pairs, see reference)
]]

hashmap = {}
-- Crea un mapa hash
function hashmap.new(t)
	if type(t) ~= "table" and type(t) ~= "nil" then error("bad argument #1 to new (table expected, got "..type(t)..")", 2) end

	-- Atributos
	local data = setmetatable({}, {__mode="kv", __metatable = nil})
	local size = 0
	if t then
		for k, v in pairs(t) do
			data[k] = v; size = size+1
		end
	end
	
	-- Metodos públicos
	local method = {}
	local metamethod = {}

	-- Tamaño del mapa hash
	function method:size()
		return size
	end

	-- Si el mapa hash está vacio
	function method:empty()
		return size == 0
	end

	-- Limpia el mapa hash
	function method:clear()
		data = setmetatable({}, {__mode="kv", __metatable = nil})
		size = 0
	end

	-- Mete un par (clave, valor) en el mapa hash
	function method:set(k, v)
		if data[k] then size = size+1 end
		data[k] = v
	end
	
	-- Obtiene un valor en el mapa hash
	function method:get(k)
		return data[k]
	end
	
	-- Elimina el elemento con clave k del mapa hash
	function method:remove(k)
		if data[k] ~= nil then print(true); data[k] = nil; size = size-1 end
	end

	-- Busca la primera clave con un valor en el mapa hash
	function method:find(value)
		key = nil
		for k, v in pairs(data) do
			if v == value then key = k; break end
		end
		return key ~= nil, key
	end

	-- Devuelve todas las claves con el valor dado en el mapa hash
	function method:search(value)
		key = {}
		for k, v in pairs(data) do
			if v == value then table.insert(key, k) end
		end
		return key ~= {}, key
	end

	-- Función iteradora de la colección
	function method:iterate()
		return pairs(data)
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