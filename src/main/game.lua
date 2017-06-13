--- Definition of general game functions in Space Cats
--
-- @author	Rafael Alcalde Azpiazu (NEKERAFA)
-- @license GNU General Public License v3

local collider = require 'vrld.HC'
local player = require 'ships.player'
local mouse = require 'ships.small_mouse'
local ship_painter = require 'src.main.painters.ship'

local lg = love.graphics

-- Round a number
function math.round(num)
    if num >= 0 then
        return math.floor(num + 0.5)
    end
    return math.ceil(num - 0.5)
end

-- Global table
game = {run = true, points = 0, MAX_STARS = 32, time = 0, enemies = {}}

-- #### Functions ####

--- Callback to load game
function game.load()
    -- Fonts
    print "Loading fonts..."
    game.font = lg.newFont("src/resources/fonts/terminus.ttf")
    game.font:setFilter("nearest")
    love.graphics.setFont(game.font)

    -- Image ships
    print "Loading ship painter..."
    ship_painter.load()

    -- Player ships
    print "Loading player..."
    game.player = player(32, love.game.getHeight()/2)

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
        game.star_image[i] = lg.newImage("src/resources/images/backgrounds/star_" .. i .. ".png")
    end
	
	-- First level
	dofile("src/main/levels/lvl_0_0.lua")
	-- Load level
	level.load()
end

--- Callback to update all variables
-- @tparam number dt Time since the last update in seconds
function game.update(dt)
    -- If game is running, update all variables
    if game.run then
		game.time = game.time + dt
		
        -- Update player
        game.player:update(dt)
        game.player:move(dt)

		-- Check if must pop new enemy in game
		if (#level.enemies > 0) and (game.time > level.enemies[1].time) then
			game.time = game.time - level.enemies[1].time
			table.insert(game.enemies, level.enemies[1].ship)
			table.remove(level.enemies, 1)
		end

        -- Update all enemies
		for i, enemy in ipairs(game.enemies) do
			enemy:update(dt)
			enemy:move(dt)
			
			-- Remove a enemy if is out of screen
			if (enemy.x < -16) or (enemy.x > love.game.getWidth()+16) or
			   (enemy.y < -16) or (enemy.y > love.game.getHeight()+16) or enemy.destroyed then
				enemy:free()
				table.remove(game.enemies, i)
				break
			end
		end

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

--- Check collitions
function game.collider()
    -- Check player bullets
    for i, bullet in ipairs(game.player.bullets) do
        -- Check if collides with one enemy
        for pos, enemy in ipairs(game.enemies) do
            if bullet.collider:collidesWith(enemy.collider) then
                -- Make damage
                enemy:damage(bullet.damage)
                -- Remove bullet from collider space
                collider.remove(bullet.collider)
                -- Remove from bullets
                table.remove(game.player.bullets, i)
                break
            end
        end
    end
	
	-- Check enemy bullets
	for pos, enemy in ipairs(game.enemies) do
		for i, bullet in ipairs(enemy.bullets) do
			if bullet.collider:collidesWith(game.player.collider) then
				-- Make damage
				game.player:damage(bullet.damage)
				-- Remove bullet from collider space
				collider.remove(bullet.collider)
				-- Remove from bullets
				table.remove(game.player.bullets, i)
				break
			end
		end
	end
end

--- Draw sky background
function game.sky()
    lg.draw(level.bg, 0, 0)

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

    -- Draw ship player
    ship_painter.draw(game.player)
	
	-- Draw enemies
	for i, enemy in ipairs(game.enemies) do
		ship_painter.draw(enemy)
	end
	
    lg.print(game.player.life, 5, 5)
    lg.printf(string.format("%0.8i", game.points), 5, 5, love.game.getWidth()-10, "right")
end

game.load()
