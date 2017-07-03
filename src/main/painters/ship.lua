--- This module is resposible for draw ships
--
-- @module painters.ship
-- @author	Rafael Alcalde Azpiazu (NEKERAFA)
-- @license GNU General Public License v3

-- Module
local painter_ship = {}

-- Variables
local flames = {}
local ships = {}
local weapons = {}

local lg = love.graphics

--- Load painter module
function painter_ship.load()
    -- Player
    print "Loading player image..."
    ships.player = lg.newImage("src/resources/images/ships/ship_player.png")
    ships.player:setFilter("nearest")

    -- Mouses
    print "Loading small mouse 1 image..."
    ships.small_mouse = lg.newImage("src/resources/images/ships/small_mouse.png")
    ships.small_mouse:setFilter("nearest")

	print "Loading small mouse 2 image..."
    ships.small_mouse2 = lg.newImage("src/resources/images/ships/small_mouse2.png")
    ships.small_mouse2:setFilter("nearest")

    print "Loading trainer mouse image..."
    ships.trainer_mouse = lg.newImage("src/resources/images/ships/trainer_mouse.png")
    ships.trainer_mouse:setFilter("nearest")

    -- Ships flame
    print "Loading flames..."
    flames.medium = lg.newImage("src/resources/images/animations/flame_medium.png")
    flames.medium:setFilter("nearest")

    flames.small = lg.newImage("src/resources/images/animations/flame_small.png")
    flames.small:setFilter("nearest")

    -- Weapons
    print "Loading blaster 1..."
    weapons.blaster = lg.newImage("src/resources/images/weapons/blaster.png")
    weapons.blaster:setFilter("nearest")

    print "Loading blaster 2..."
    weapons.blaster2 = lg.newImage("src/resources/images/weapons/blaster_2.png")
    weapons.blaster2:setFilter("nearest")
	
    -- Weapons
    print "Loading explosion..."
    ships.explosion = lg.newImage("src/resources/images/animations/explosion.png")
    ships.explosion:setFilter("nearest")
end

--- Draw hitbox
-- @tparam ship ship Ship to paint hitbox
function painter_ship.hitbox(ship)
    local r, g, b, a = lg.getColor()
    lg.setColor(255, 0, 0, 128)
    ship.collider:draw('fill')
    lg.setColor(r, g, b, a)
end

--- Draw a ship
-- @tparam ship ship Ship to paint (Also paint bullets)
function painter_ship.draw(ship)
	-- Draw all bullets
	for i, bullet in ipairs(ship.bullets) do
		angle = math.atan2(bullet.velocity.x, -bullet.velocity.y)
		lg.draw(weapons[bullet.bullet_type], math.round(bullet.x), math.round(bullet.y), angle, 1, -1, 0, 0)
	end

    if ship.life > 0 then
        -- Draw flame and player ship
        if ship.ship_type == "player" then
			if ship.invulnerability:isRunning() then
				r, g, b, a = lg.getColor()
				lg.setColor(255, 128, 128, ship.invulnerability_alpha)
				ship.flame:draw(flames.medium, math.round(ship.x)-24, math.round(ship.y), 0, 1, 1, 8, 8)
				lg.draw(ships[ship.ship_type], math.round(ship.x), math.round(ship.y), 0, 1, 1, 16, 16)
				lg.setColor(r, g, b, a)
			else
				ship.flame:draw(flames.medium, math.round(ship.x)-24, math.round(ship.y), 0, 1, 1, 8, 8)
				lg.draw(ships[ship.ship_type], math.round(ship.x), math.round(ship.y), 0, 1, 1, 16, 16)
			end

		-- Draw flame and small ship
		elseif ship.ship_type == "small_mouse" then
            ship.flame:draw(flames.medium, math.round(ship.x)+24, math.round(ship.y), 0, 1, -1, 8, 8)
            lg.draw(ships[ship.ship_type], math.round(ship.x), math.round(ship.y), 0, 1, 1, 16, 16)

		-- Draw flame and small ship
	elseif ship.ship_type == "small_mouse2" then
			r, g, b, a = lg.getColor()
			lg.setColor(255, ship.color, ship.color, a)
            ship.flame:draw(flames.medium, math.round(ship.x)+24, math.round(ship.y), 0, 1, -1, 8, 8)
            lg.draw(ships[ship.ship_type], math.round(ship.x), math.round(ship.y), 0, 1, 1, 16, 16)
			lg.setColor(r, g, b, a)
	
		-- Draw flame of trainer ship
        elseif ship.ship_type == "trainer_mouse" then
            ship.flame:draw(flames.small, math.round(ship.x)+4, math.round(ship.y)+10, 0, 1, 1, 4, 4)
            lg.draw(ships[ship.ship_type], math.round(ship.x), math.round(ship.y), 0, 1, 1, 12, 12)
        end

    elseif not ship.destroyed then
        -- Draw explosion
        ship.explosion:draw(ships.explosion, math.round(ship.x), math.round(ship.y), 0, 1, 1, 16, 16)
    end

    -- Debuging
    --painter_ship.hitbox(ship)
end

return painter_ship
