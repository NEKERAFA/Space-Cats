--- Definition of general game functions in Space Cats
--
-- @author	Rafael Alcalde Azpiazu (NEKERAFA)
-- @license GNU General Public License v3

local collider = require 'vrld.HC'
local player = require 'ships.player'
local mouse = require 'ships.small_mouse'
local ship_painter = require 'src.main.painters.ship'

-- Round a number
function math.round(num)
    if num >= 0 then
        return math.floor(num + 0.5)
    end
    return math.ceil(num - 0.5)
end

-- Global table
game = {
	run = false, points = 0, MAX_STARS = 16, time = 0, debug_time = 0,
	enemies = {}, obstacles = {}, powerups = {}, particles = {}
}

-- #### Functions ####

--- Callback to load game
function game.load()
    -- Fonts
    print "Loading fonts..."
    game.font = love.graphics.newFont("src/assets/fonts/terminus.ttf")
    game.font:setFilter("nearest")
    love.graphics.setFont(game.font)

	-- Loading hud elements
	print "Loading hud images..."
	game.graph = {}
	game.graph.points = {}
	game.graph.points[10] = love.graphics.newImage("src/assets/images/hud/10_p.png")
	game.graph.points[30] = love.graphics.newImage("src/assets/images/hud/30_p.png")
	game.graph.points[50] = love.graphics.newImage("src/assets/images/hud/50_p.png")
	game.graph.points[100] = love.graphics.newImage("src/assets/images/hud/100_p.png")
	
	for pos, img in pairs(game.graph.points) do
		img:setFilter("nearest")
	end
	
	game.graph.life = love.graphics.newImage("src/assets/images/hud/life.png")
	game.graph.life:setFilter("nearest")
	
	game.graph.damage = {}
	for i = 1, 4 do
		game.graph.damage[i] = love.graphics.newImage("src/assets/images/hud/" .. i .. "_d.png")
		game.graph.damage[i]:setFilter("nearest")
	end

	-- Loading shaders
	print "Loading shaders..."
	game.shaders = {}
	game.shaders.grayscale = love.graphics.newShader("src/assets/shaders/grayscale.glsl")

    -- Image ships
    print "Loading ship painter..."
    ship_painter.load()
	
	-- Sound effects
	print "Loading sound effects..."
	game.sfx = {}
	game.sfx.laser = love.audio.newSource("src/assets/sounds/sfx/laser.ogg")
	game.sfx.explosion = love.audio.newSource("src/assets/sounds/sfx/explosion.ogg")

    -- Player ships
    print "Loading player..."
    game.player = player(32, love.game.height/2)

    -- Stars
    print "Loading stars..."
    game.star = {}
    for i = 1, game.MAX_STARS do
        game.star[i] = {
            x = math.random(8, love.game.width-8),
            y = math.random(8, love.game.height-8),
            v = math.random(2, 8)*love.game.frameRate
        }
    end

    -- Star images
    game.star_image = {}
    for i = 1, 2 do
        game.star_image[i] = love.graphics.newImage("src/assets/images/backgrounds/star_" .. i .. ".png")
    end
	
	-- First level
	dofile("src/main/levels/lvl_1_1.lua")
	-- Load level
	level.load()
end

--- Pop new entities
function game.pop_entities()
	-- Check if must pop new element of level
	if level.objects and (#level.objects > 0) and (game.time > level.objects[1].time) then
		game.time = game.time - level.objects[1].time
		
		-- Pop a ship
		if level.objects[1].type == "ship" then
			table.insert(game.enemies, level.objects[1].ship)
			table.remove(level.objects, 1)
		-- Pop a obstacle
		elseif level.objects[1].type == "obstacle" then
			table.insert(game.obstacles, level.objects[1].obstacle)
			table.remove(level.objects, 1)
		end
	end
end

--- Update all enemies
-- @tparam number dt Time since the last update in seconds
function game.update_enemies(dt)
	for i, enemy in ipairs(game.enemies) do
		enemy:update(dt)
		enemy:move(dt)
		
		-- Remove a enemy if is out of screen
		if ((enemy.x < -16) or (enemy.x > love.game.width+16) or
		   (enemy.y < -16) or (enemy.y > love.game.height+16) or 
		   enemy.destroyed) and #enemy.bullets == 0 then
			enemy:free()
			table.remove(game.enemies, i)
			break
		end
	end
end

--- Update all obstacles
-- @tparam number dt Time since the last update in seconds
function game.update_obstacles(dt)
	for i, obstacle in ipairs(game.obstacles) do
		obstacle:update(dt)
		obstacle:move(dt)
		
		-- Remove a obstacle if is out of screen
		if (obstacle.x < -16) or (obstacle.x > love.game.width+16) or
		   (obstacle.y < -16) or (obstacle.y > love.game.height+16) or 
		   obstacle.destroyed then
			obstacle:free()
			table.remove(game.obstacles, i)
			break
		end
	end
end

--- Update stars
-- @tparam number dt Time since the last update in seconds
function game.update_star(dt)
    for i = 1, game.MAX_STARS do
        game.star[i].x = game.star[i].x - game.star[i].v * dt

        -- Restart if star throws out the screen
        if game.star[i].x < 0 then
            game.star[i].x = love.game.width
            game.star[i].y = math.random(8, love.game.height-8)
            game.star[i].v = math.random(2, 8)*love.game.frameRate
        end
    end
end

--- Check collitions
function game.collider()
    -- Check player bullets
    for i, bullet in ipairs(game.player.bullets) do
        -- Check if collides with one enemy
        for pos, enemy in ipairs(game.enemies) do
			-- Check if enemy has a collider box
			if enemy.collider and bullet.collider:collidesWith(enemy.collider) then
				-- Make damage
				enemy:damage(bullet.damage)
				-- Remove bullet from collider space
				collider.remove(bullet.collider)
				-- Remove from bullets
				table.remove(game.player.bullets, i)
				
				-- Add particles as points
				if enemy.life <= 0 then
					table.insert(game.particles, {points = enemy.points,
							x = enemy.x + math.random(-4, 4),
							y = enemy.y + math.random(-4, 4),
							count = 0})
					game.points = game.points + enemy.points
				-- Add particle as damage
				else
					table.insert(game.particles, {damage = bullet.damage,
							x = enemy.x + math.random(-4, 4),
							y = enemy.y + math.random(-4, 4),
							count = 0})
				end
				
				break
			end
			
			-- Check if collides with a enemy bullet
			for j, bullet_e in ipairs(enemy.bullets) do
				if bullet.collider:collidesWith(bullet_e.collider) then
					-- Remove bullets from collider space
					collider.remove(bullet.collider)
					collider.remove(bullet_e.collider)
					-- Remove from bullet table
					table.remove(game.player.bullets, i)
					table.remove(enemy.bullets, j)
					break
				end
			end
		-- end for enemy
		end
	-- end for bullet player
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
				table.remove(enemy.bullets, i)
				break
			end
		end
	
		-- Player versus enemy
		if enemy.collider and game.player.collider:collidesWith(enemy.collider) then
			-- Make damage both enemy and player
			game.player:damage(1)
			enemy:damage(1)
			break
		end
		
		-- Check ships collisions
		for j, other_enemy in ipairs(game.enemies) do
			-- Check if enemies are not the same and has a collider box
			if (i ~= j) and enemy.collider and other_enemy.collider then
				-- Make damage both enemies
				if other_enemy.collider:collidesWith(enemy.collider) then
					enemy:damage(1)	
					other_enemy:damage(1)
					break
				end
			end
		end
	-- end for enemy
	end
end

--- Update particles
function game.update_particles(dt)
	for pos, particle in ipairs(game.particles) do
		if particle.count >= 1 then
			table.remove(game.particles, pos)
			break
		end
		
		particle.count = particle.count + dt
	end
end

--- Callback to update all variables
-- @tparam number dt Time since the last update in seconds
function game.update(dt)
    -- If game is running, update all variables
    if game.run then
		-- Update all level variables
		level.update(dt)
		
		-- level event times
		game.time = game.time + dt
		
		-- pop new entity
		game.pop_entities()
		
        -- Update player
        game.player:update(dt)
        game.player:move(dt)

        -- Update all enemies
		game.update_enemies(dt)
		
		-- Update all obstacles
		game.update_obstacles(dt)

        -- Check collitions
        game.collider()

        -- Update stars
        game.update_star(dt)
		
		-- Update particles
		game.update_particles(dt)
		
		game.debug_time = game.debug_time + dt
		
		if game.debug_time >= 1 then
			--[[local points = {10, 30, 50, 100}
			
			table.insert(game.particles,
				{x = love.game.width/2 + math.random(-4, 4),
				y = love.game.height/2 + math.random(-4, 4),
				points = points[math.random(4)],
				count = 0})]]
			
			game.debug_time = game.debug_time - 1
		end
    end
end

--- Draw sky background
function game.sky()
    love.graphics.draw(level.bg, 0, 0)

    -- Update stars
	if level.stars then
		for i, star in ipairs(game.star) do
			-- Select image
			local star_image
			if star.v < 5*love.game.frameRate then
				star_image = 1
			else
				star_image = 2
			end

			-- Draw image
			love.graphics.draw(game.star_image[star_image], math.round(game.star[i].x),
					math.round(game.star[i].y))
		end
	end
end

--- Draw life
function game.draw_life()
	for i = 1, 4 do
		-- Set grayscale life if life is lost
		if i > game.player.life then
			love.graphics.setShader(game.shaders.grayscale)
		end
		
		-- Calculate x position
		x = (i-1)*18 + love.game.width/2 - ((18*3)+16)/2
		love.graphics.draw(game.graph.life, x, 5)
		
		love.graphics.setShader()
	end
end

--- Draw particles (Points and damage numbers)
function game.draw_particles()
	for pos, particle in ipairs(game.particles) do
		-- Draw points particle
		if particle.points then
			-- Center of particle
			local mid_width = game.graph.points[particle.points]:getWidth()/2
			local height = game.graph.points[particle.points]:getHeight()
			-- Alpha value
			local alpha = math.round(math.abs(math.cos(particle.count*4*math.pi))) * 255
			
			-- Set points color
			if particle.points == 10 then
				love.graphics.setColor(255, 255, 255, alpha)
			elseif particle.points == 30 then
				love.graphics.setColor(math.random(0, 64), 255, 0, alpha)
			elseif particle.points == 50 then
				love.graphics.setColor(255, math.random(192, 255), 0, alpha)
			elseif particle.points == 100 then
				love.graphics.setColor(0, math.random(192, 255), 255, alpha)
			end
			
			love.graphics.draw(game.graph.points[particle.points], particle.x,
				 math.round(particle.y-particle.count*5), 0, 1, 1, mid_width, height)
		end
	
		-- Draw damage particles
		if particle.damage then
			-- Center of particle
			local mid_width = game.graph.damage[particle.damage]:getWidth()/2
			local height = game.graph.damage[particle.damage]:getHeight()
			
			love.graphics.setColor(255, 0, 0, alpha)
			
			love.graphics.draw(game.graph.damage[particle.damage], particle.x,
					math.round(particle.y-particle.count*5), 0, 1, 1, mid_width, height)
		end
	
		love.graphics.setColor(255, 255, 255, 255)
	end
end

--- Calback to draw graphics
function game.draw()
    -- Draw sky
    game.sky()
	
	-- Draw life
	game.draw_life()

    -- Draw ship player
    ship_painter.draw(game.player)
	
	-- Draw enemies
	for i, enemy in ipairs(game.enemies) do
		ship_painter.draw(enemy)
	end
	
	-- Draw particles
	game.draw_particles()
	
    -- love.graphics.print(game.player.life, 5, 5)
    love.graphics.printf(string.format("%0.8i", game.points), 5, 5, love.game.width-10, "right")
end

game.load()
