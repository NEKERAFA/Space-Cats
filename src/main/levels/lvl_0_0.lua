--- Level 0 - 0 of Space Cats
-- Lore: You know that federated united mouse declared a war 
--
-- @author	Rafael Alcalde Azpiazu (NEKERAFA)
-- @license GNU General Public License v3

local mouse = require 'ships.small_mouse'
local lg = love.graphics

level = {bg = nil, bgm = nil, objetive = "finished", enemies = {}}

-- Function to load variable levels
function level.load()
	print "Level 0 - 0"
	
	print "Loading background image..."
	level.bg = lg.newImage("src/resources/images/backgrounds/space.png")
	level.bg:setFilter("nearest")
	
	print "Loading background music..."
	level.bgm = love.audio.newSource("src/resources/sounds/backgrounds/n-dimensions.mp3")
	level.bgm:setLooping(true)
	
	-- up - middle - up Mouse
	local p1 = {x = love.game.getWidth()+16, y = 0}
    local p2 = {x = love.game.getWidth()/1.25, y = love.game.getHeight()/2}
    local p3 = {x = love.game.getWidth()/3, y = 0}
	
	-- down - middle - down Mouse
	local p4 = {x = love.game.getWidth()+16, y = love.game.getHeight()}
    local p5 = {x = love.game.getWidth()/1.25, y = love.game.getHeight()/2}
    local p6 = {x = love.game.getWidth()/3, y = love.game.getHeight()}
    
	-- Load mouses
	table.insert(level.enemies, {ship = mouse({p1, p2, p3}, p2, 2), time = 5})
	table.insert(level.enemies, {ship = mouse({p4, p5, p6}, p2, 2), time = 0})
	table.insert(level.enemies, {ship = mouse({p1, p2, p3}, p2, 2), time = 1})
	table.insert(level.enemies, {ship = mouse({p4, p5, p6}, p2, 2), time = 0})
	table.insert(level.enemies, {ship = mouse({p1, p2, p3}, p2, 2), time = 1})
	table.insert(level.enemies, {ship = mouse({p4, p5, p6}, p2, 2), time = 0})
	table.insert(level.enemies, {ship = mouse({p1, p2, p3}, p2, 2), time = 1})
	table.insert(level.enemies, {ship = mouse({p4, p5, p6}, p2, 2), time = 0})
end

function level.update(dt)
	if bgm:isStopped() then
		bgm:play()
	end
end

function level.draw()
end