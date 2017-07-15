--- This module is resposible for draw obstacles
--
-- @module painters.obstacle
-- @author	Rafael Alcalde Azpiazu (NEKERAFA)
-- @license GNU General Public License v3

-- Module
local painter_obstacle = {}

-- Variables
local obstacles = {}

--- Load painter module
function painter_obstacle.load()
    print "Loading obstacle image..."
    obstacles.asteroid = love.graphics.newImage("src/assets/images/obstacles/asteroid.png")
    obstacles.asteroid:setFilter("nearest")

    print "Loading explosion..."
    explosion = love.graphics.newImage("src/assets/images/animations/explosion.png")
    explosion:setFilter("nearest")
end

--- Draw hitbox of obstacle
-- @tparam obstacle obstacle obstacle to paint hitbox
function painter_obstacle.hitbox(obstacle)
    local r, g, b, a = love.graphics.getColor()
    love.graphics.setColor(255, 0, 0, 128)
    obstacle.collider:draw("fill")
    love.graphics.setColor(r, g, b, a)
end

--- Draw an obstacle
-- @tparam obstacle obstacle obstacle to paint
function painter_obstacle.draw(obstacle)
    -- Draw obstacle
    if obstacle.strength > 0 then
        love.graphics.draw(obstacles[obstacle.obstacle_type], math.round(obstacle.x), math.round(obstacle.y), 0, 1, 1, 16, 16)
    elseif not obstacle.destroyed then
        obstacle.explosion:draw(explosion, math.round(obstacle.x), math.round(obstacle.y), 0, 1, 1, 16, 16)
    end

    -- Debuging
    if love.game.debug then
		painter_obstacle.hitbox(obstacle)
	end
end

return painter_obstacle
