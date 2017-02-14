--- Definition of general game functions in Space Cats
--
-- @author	Rafael Alcalde Azpiazu (NEKERAFA)
-- @license GNU General Public License v3

local collider = require "vldr.hardoncollider"
local player = require "objects.ships.player"
local mouse = require "objects.ships.small_mouse"
local ship_painter = require "painters.ship"

local lg = love.graphics

-- Round a number
function math.round(num)
    if num >= 0 then
        return math.floor(num + 0.5)
    end
    return math.ceil(num - 0.5)
end

-- Global table
game = {run = true, points = 0, MAX_STARS = 32}

-- #### Functions ####

--- Callback to load game
function game.load()
    -- Fonts
    print "Loading fonts..."
    game.font = lg.newFont("resources/fonts/terminus.ttf")
    game.font:setFilter("nearest")
    love.graphics.setFont(game.font)

    -- Backgrounds
    print "Loading backgrounds..."
    game.bg = lg.newImage("resources/images/bg/space.png")
    game.bg:setFilter("nearest")

    -- Image ships
    print "Loading ships..."
    ship_painter.load()

    -- Player ships
    print "Loading player..."
    game.player = player(32, love.game.getHeight()/2)

    -- Mouse ship
    print "Loading mouse.."
    local p1 = {x = love.game.getWidth()+16, y = 0}
    local p2 = {x = love.game.getWidth()/1.25, y = love.game.getHeight()/2}
    local p3 = {x = love.game.getWidth()/3, y = 0}
    game.mouse = mouse({p1, p2, p3}, p2, 2)

    -- Stars
    print "Loading stars..."
    game.star = {}
    for i = 1, game.MAX_STARS do
        game.star[i] = {
            x = math.random(8, love.game.getWidth()-8),
            y = math.random(8, love.game.getHeight()-8),
            v = math.random(1, 4)*love.game.frameRate()
        }
    end

    -- Star images
    game.star_image = {}
    for i = 1, 2 do
        game.star_image[i] = lg.newImage("resources/images/bg/star_" .. i .. ".png")
    end
end

--- Callback to update all variables
-- @tparam number dt Time since the last update in seconds
function game.update(dt)
    -- If game is running, update all variables
    if game.run then
        -- Update player
        game.player:update(dt)
        game.player:move(dt)

        -- Check mouse status
        game.check_enemy()

        -- Update mouse
        game.mouse:update(dt)
        game.mouse:move(dt)

        -- Check collitions
        game.collider()

        -- Update stars
        game.update_star(dt)
    end
end

--- Update stars
-- @tparam number dt Time since the last update in seconds
function game.update_star(dt)
    for i = 1, game.MAX_STARS do
        game.star[i].x = game.star[i].x - game.star[i].v * dt

        -- Restart if star throws out the screen
        if game.star[i].x < 0 then
            game.star[i].x = love.game.getWidth()
            game.star[i].y = math.random(8, love.game.getHeight()-8)
            game.star[i].v = math.random(1, 4)*love.game.frameRate()
        end
    end
end

--- Check new enemy
function game.check_enemy()
    if game.mouse.destroyed then
        game.restart_enemy()
        game.points = game.points+1
    elseif game.mouse.x+16 < 0 or game.mouse.x-16 > love.game.getWidth()
        or game.mouse.y+16 < 0 or game.mouse.y-16 > love.game.getHeight() then
        game.restart_enemy()
    end
end

--- Create new enemy
function game.restart_enemy()
    collider.remove(game.mouse.collider)
    game.mouse = nil
    collectgarbage("collect")
    local p1 = {x = love.game.getWidth()+16, y = 0}
    local p2 = {x = love.game.getWidth()/1.25, y = love.game.getHeight()/2}
    local p3 = {x = love.game.getWidth()/3, y = 0}
    game.mouse = mouse({p1, p2, p3}, p2, 2)
end

--- Check collitions
function game.collider()
    -- Check player bullets
    for i, bullet in ipairs(game.player.bullets) do
        -- Check if collides with the mouse
        if bullet.collider:collidesWith(game.mouse.collider) then
            -- Make damage
            game.mouse:damage(bullet.damage)
            -- Remove bullet from collider space
            collider.remove(bullet.collider)
            -- Remove from bullets
            table.remove(game.player.bullets, i)
            break
        end
    end
end

--- Draw sky background
function game.sky()
    lg.draw(game.bg, 0, 0)

    -- Update stars
    for i, star in ipairs(game.star) do
        -- Select image
        local star_image
        if star.v < 3*love.game.frameRate() then
            star_image = 1
        else
            star_image = 2
        end

        -- Draw image
        lg.draw(game.star_image[star_image], math.round(game.star[i].x),
                math.round(game.star[i].y))
    end
end

--- Calback to draw graphics
function game.draw()
    -- Draw sky
    game.sky()
    -- Draw asteroid
    --asteroid_painter.draw(game.asteroid)
    -- Draw ship player
    ship_painter.draw(game.player)
    ship_painter.draw(game.mouse)
    lg.print(math.round(game.player.x) .. ", " .. math.round(game.player.y), 5, 5)
    lg.printf(string.format("%0.8i", game.points), 5, 5, love.game.getWidth()-10, "right")
end

game.load()
