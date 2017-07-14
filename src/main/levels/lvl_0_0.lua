--- Level 0 - 0 of Space Cats
-- Lore: You know that federated united mouse declared a war 
--
-- @author	Rafael Alcalde Azpiazu (NEKERAFA)
-- @license GNU General Public License v3

local mouse = require 'ships.small_mouse'
local mouse2 = require 'ships.small_mouse2'
local lg = love.graphics

level = {bg = nil, bgm = nil, objetive = "finished", objects = {}}

-- Function to load variable levels
function level.load()
	print "Level 1 - 1"
	
	print "Loading background image..."
	level.bg = lg.newImage("src/assets/images/backgrounds/space.png")
	level.bg:setFilter("nearest")
	
	print "Loading background music..."
	level.bgm = love.audio.newSource("src/assets/sounds/backgrounds/n-dimensions.ogg")
	level.bgm:setLooping(true)
	
	-- up - middle - up Mouse
	local p1 = {x = love.game.width+16, y = 0}
    local p2 = {x = love.game.width/1.25, y = love.game.height/3}
    local p3 = {x = love.game.width-love.game.width/3, y = 0}
	
	-- down - middle - down Mouse
	local p4 = {x = love.game.width+16, y = love.game.height}
    local p5 = {x = love.game.width/1.25, y = love.game.height-love.game.height/3}
    local p6 = {x = love.game.width-love.game.width/3, y = love.game.height}
	
	-- up - middle - middle
	local p7 = {x = love.game.width-love.game.width/3, y = love.game.height/4}
	
	-- down -- middle middle
	local p9 = {x = love.game.width-love.game.width/3, y = love.game.height-love.game.height/3}
    
	-- Load mouses
	--[[ First wave
	table.insert(level.objects, {type = "ship", ship = mouse({p1, p2, p3}, p2, 1), time = 5})
	table.insert(level.objects, {type = "ship", ship = mouse({p1, p2, p3}, p2, 1), time = 0.5})
	table.insert(level.objects, {type = "ship", ship = mouse({p1, p2, p3}, p2, 1), time = 0.5})
	table.insert(level.objects, {type = "ship", ship = mouse({p1, p2, p3}, p2, 1), time = 0.5})
	table.insert(level.objects, {type = "ship", ship = mouse({p1, p2, p3}, p2, 1), time = 0.5})
	
	table.insert(level.objects, {type = "ship", ship = mouse({p4, p5, p6}, p5, 1), time = 0.5})
	table.insert(level.objects, {type = "ship", ship = mouse({p4, p5, p6}, p5, 1), time = 0.5})
	table.insert(level.objects, {type = "ship", ship = mouse({p4, p5, p6}, p5, 1), time = 0.5})
	table.insert(level.objects, {type = "ship", ship = mouse({p4, p5, p6}, p5, 1), time = 0.5})
	table.insert(level.objects, {type = "ship", ship = mouse({p4, p5, p6}, p5, 1), time = 0.5})
	]]
	
	-- Second wave
	table.insert(level.objects, {type = "ship", ship = mouse2(p1, p7), time = 4})
	table.insert(level.objects, {type = "ship", ship = mouse2(p4, p9), time = 0})
	
	table.insert(level.objects, {type = "ship", ship = mouse({p1, p2, p3}, p2, 1), time = 2})
	table.insert(level.objects, {type = "ship", ship = mouse({p1, p2, p3}, p2, 1), time = 1})
	table.insert(level.objects, {type = "ship", ship = mouse({p1, p2, p3}, p2, 1), time = 1})
	table.insert(level.objects, {type = "ship", ship = mouse({p4, p5, p6}, p5, 1), time = 2})
	table.insert(level.objects, {type = "ship", ship = mouse({p4, p5, p6}, p5, 1), time = 1})
	table.insert(level.objects, {type = "ship", ship = mouse({p4, p5, p6}, p5, 1), time = 1})
end

function level.update(dt)
	if level.bgm:isStopped() then
		level.bgm:play()
	end
end

function level.draw()
end