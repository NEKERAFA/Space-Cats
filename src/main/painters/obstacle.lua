--- This module is resposible for draw obstacles
--
-- @module painters.obstacle
-- @author	Rafael Alcalde Azpiazu (NEKERAFA)
-- @license GNU General Public License v3

-- Module
local painter_obstacle = {}

-- Variables
local obstacles = {}

local lg = love.graphics

--- Load painter module
function painter_obstacle.load()
    print "Loading obstacle image..."
    obstacles.asteroid = lg.newImage("src/resources/images/obstacles/asteroid.png")
    obstacles.asteroid:setFilter("nearest")

    print "Loading explosion..."
    explosion = lg.newImage("src/resources/images/animations/explosion.png")
    explosion:setFilter("nearest")
end

--- Draw hitbox of obstacle
-- @tparam obstacle obstacle obstacle to paint hitbox
function painter_obstacle.hitbox(obstacle)
    local r, g, b, a = lg.getColor()
    lg.setColor(255, 0, 0, 128)
    obstacle.collider:draw("fill")
    lg.setColor(r, g, b, a)
end

--- Draw an obstacle
-- @tparam obstacle obstacle obstacle to paint
function painter_obstacle.draw(obstacle)
    -- Draw obstacle
    if obstacle.strength > 0 then
        lg.draw(obstacles[obstacle.obstacle_type], math.round(obstacle.x), math.round(obstacle.y), 0, 1, 1, 16, 16)
    elseif not obstacle.destroyed then
        obstacle.explosion:draw(explosion, math.round(obstacle.x), math.round(obstacle.y), 0, 1, 1, 16, 16)
    end
    painter_obstacle.hitbox(obstacle)
end

return painter_obstacle
