--[[
	Creado por NEKERAFA el dom 26 jun 2016 17:43 (CEST)
	License by Creative Commons Attribution-ShareAlike 4.0
	http://creativecommons.org/licenses/by-sa/4.0/
	
	colision.lua
	
	Biblioteca para añadir detectores de colisiones
]]


colision = {}

function colision.rect(a, b)
	return (a.x < b.x+b.w) and (a.x+a.w > b.x) and (a.y < b.y+b.h) and (a.y+a.h > b.y)
end

function colision.raytracker(a, b)
	return (a.x1 < b.x+b.w) and (a.x2 > b.x) and (a.y1 < b.y+b.h) and (a.y2 > b.y)
end