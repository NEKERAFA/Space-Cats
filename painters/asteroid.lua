--- This module is resposible for draw asteroids
--
-- @module painters.asteroid
-- @author	Rafael Alcalde Azpiazu (NEKERAFA)
-- @license GNU General Public License v3

-- Module
local painter_asteroid = {}

-- Variables
local asteroids = {}

local lg = love.graphics

--- Load painter module
function painter_asteroid.load()
    print "Loading asteroid image..."
    asteroids.normal = lg.newImage("resources/images/asteroids/asteroid_1.png")
    asteroids.normal:setFilter("nearest")
end

-- Draw hitbox
function painter_asteroid.hitbox(asteroid)
    local r, g, b, a = lg.getColor()
    lg.setColor(255, 0, 0, 128)
    asteroid.collider:draw("fill")
    lg.setColor(r, g, b, a)
end

-- Draw a asteroid
function painter_asteroid.draw(asteroid)
    -- Draw asteroid
    lg.draw(asteroids[asteroid.asteroid_type], math.round(asteroid.x), math.round(asteroid.y), 0, 1, 1, 16, 16)
    painter_asteroid.hitbox(asteroid)
end

return painter_asteroid
