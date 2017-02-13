--- This module is resposible for draw ships
--
-- @module painters.ship
-- @author	Rafael Alcalde Azpiazu (NEKERAFA)
-- @license GNU General Public License v3

-- Module
local painter_ship = {}

-- Variables
local flame
local ships = {}
local weapons = {}

local lg = love.graphics

--- Load painter module
function painter_ship.load()
    -- Player
    print "Loading player image..."
    ships.player = lg.newImage("resources/images/ships/ship-cat.png")
    ships.player:setFilter("nearest")

    -- Player
    print "Loading mouse image..."
    ships.small_mouse = lg.newImage("resources/images/ships/ship-mouse.png")
    ships.small_mouse:setFilter("nearest")

    -- Ships flame
    print "Loading flame..."
    flame = lg.newImage("resources/images/ships/flame.png")
    flame:setFilter("nearest")

    -- Weapons
    print "Loading blaster..."
    weapons.blaster = lg.newImage("resources/images/weapons/blaster.png")
    weapons.blaster:setFilter("nearest")

    -- Weapons
    print "Loading explosion..."
    ships.explosion = lg.newImage("resources/images/ships/explosion.png")
    ships.explosion:setFilter("nearest")
end

-- Draw hitbox
function painter_ship.hitbox(ship)
    local r, g, b, a = lg.getColor()
    lg.setColor(255, 0, 0, 128)
    ship.collider:draw('fill')
    lg.setColor(r, g, b, a)
end

-- Draw a ship
function painter_ship.draw(ship)
    -- Draw bullets
    for i, bullet in ipairs(ship.bullets) do
        lg.draw(weapons[bullet.bullet_type], math.round(bullet.x),
                math.round(bullet.y), 0, 1, 1, 0, 0)
    end

    -- Draw ship
    lg.draw(ships[ship.ship_type], math.round(ship.x), math.round(ship.y), 0, 1, 1, 16, 16)
    -- Draw flame
    if ship.ship_type == "player" then
        ship.flame:draw(flame, math.round(ship.x)-24, math.round(ship.y), 0, 1, 1, 8, 8)
    elseif ship.ship_type == "small_mouse" then
        ship.flame:draw(flame, math.round(ship.x)+24, math.round(ship.y), 0, 1, 1, 8, 8)
    end
    -- Draw explosion
    ship.explosion:draw(ships.explosion, math.round(ship.x), math.round(ship.y), 0, 1, 1, 16, 16)
    painter_ship.hitbox(ship)
end

return painter_ship
