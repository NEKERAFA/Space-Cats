--[[
	Created by NEKERAFA on fri 26 feb 2016 19:29:03 (CET)
	License by Creative Commons Attribution-ShareAlike 4.0
	http://creativecommons.org/licenses/by-sa/4.0/

	**** MODULE COLLECTION ****
	Implement an abstract data type which contents elements inside it

	collection.new( number n ) : collection
	-- Creates a new collection

	collection:empty() : boolean
	-- Return true if the object is empty

	collection:full() : boolean
	-- Return true if the object is full

	collection:clear() : nil
	-- Clear the collection

	collection:size() : number
	-- Return the size of collection

	collection:add( element e [, number pos] ) : nil
	-- Add a element to the collection in a position or in the last position

	collection:get( number pos ) : element
	-- Return the element at the position or in the last position

	collection:remove( number pos ) : element
	-- Remove the element at the position or in the last position

	collection:search( element e ) : number, element
	-- Search a element in the collection and return the position

	collection:next( number pos ) : number, element
	-- Return the next element in the collection or nil if it is the last position

	collection:prev( number pos ) : number, element
	-- Return the previous element in the collection or nil if it is the first element

	collection:iterate()
	-- Iterate the collection. Use in for ... in loops (Warning: this function use pairs, see reference)

	collection:sort( comp ) : nil
	-- Sort a collection with a compare function

	collection:pack( ... ) : nil
	-- Insert the list of element in the collection

	collection:unpack( i, j ) : ...
	-- Return a list of element from the collection

	collection:concat( sep [, number i [, number j] ] ) : string
	-- Return a string that concats the elements of the collection

]]

collection = {}
-- Crea una colección
function collection.new(n)
	if n and (n < 0) then error("bad argument #1 to new (must be greater or equal 0)", 2) end

	-- Variables privadas
	local data = setmetatable({}, {__mode="kv", __metatable = nil})
	local size = 0
	local MAX_SIZE = n or 0

	-- Metodos públicos
	local method = {}

	-- Retorna si el objeto está vacio
	function method:empty()
		return size == 0
	end

	-- Retorna si el objecto está lleno
	function method:full()
		if MAX_SIZE == 0 then return false
		else return size == MAX_SIZE end
	end

	-- Limpia la colección
	function method:clear()
		data = setmetatable({}, {__mode="kv", __metatable = nil})
		size = 0
    collectgarbage('collect')
	end

	-- Retorna el tamano de la colección
	function method:size()
		return size
	end

	-- Añade un elemento a la colección
	function method:add(e, pos)
		if e == nil then error("bad argument #1 to add (attempt to add nil)", 2) end
		if (MAX_SIZE > 0) and (size == MAX_SIZE) then
			error("error adding element (collection overflow)", 2)
		end
		size = size+1
		table.insert(data, pos or size, e)
	end

	-- Pone un elemento en una posición dada
	function method:set(pos, e)
		if (pos > size) or (pos < 1) then error("bad argument #1 to set (position out of bounds)", 2) end
		data[pos] = e
	end

	-- Obtiene la posición del elemento
	function method:get(pos)
		if pos and ((pos > size) or (pos < 1)) then
			error("bad argument #1 to get (position out of bounds)", 2)
		end
		return data[pos or size]
	end

	-- Elimina un elemento de la colección
	function method:remove(pos)
		if size == 0 then error("error removing element (collection underflow)", 2) end
		if pos and ((pos > size) or (pos < 1)) then
			error("bad argument #1 to remove (position out of bounds)", 2)
		end
		size = size-1
		return table.remove(data, pos or size+1)
	end

	-- Busca un elemento en la colección
	function method:search(e)
		if not method:empty() then
			local n = 1
			while (n <= size) and (data[n] ~= e) do n = n+1 end
			if n > size then return nil else return n, data[n] end
		else return nil end
	end

	-- Primer elemento
	function method:first()
		if size == 0 then return nil
		else return 1, data[1] end
	end

	-- Ultimo elemento
	function method:last()
		if size == 0 then return nil
		else return size, data[size] end
	end

	-- Siguiente elemento
	function method:next(pos)
		if pos >= size or pos < 1 then return nil
		else return pos+1, data[pos+1] end
	end

	-- Elemento anterior
	function method:prev(pos)
		if pos > size or pos <= 1 then return nil
		else return pos-1, data[pos-1] end
	end

	-- Función iteradora de la colección
	function method:iterate()
		return pairs(data)
	end

	-- Ordena la colección
	function method:sort(comp)
		table.sort(data, comp)
	end

	-- Empaqueta la lista de elementos en la colección
	function method:pack(...)
		list = {...}
		for k, v in pairs(list) do
			if (MAX_SIZE > 0) and (size == MAX_SIZE) then
				error("collection overflow", 2)
			end
			size = size+1
			table.insert(data, v)
		end
	end

	-- Devuelve una lista con todos los elementos
	function method:unpack(i, j)
		return table.unpack(data, i, j)
	end

	-- Devuelve un string con los elementos concatenados de la colección
	function method:concat(sep, i, j)
		return table.concat(data, sep, i, j)
	end

	return method
end
