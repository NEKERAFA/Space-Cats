--- Definition of collision functions beetween entities in Space Cats
--
-- @author	Rafael Alcalde Azpiazu (NEKERAFA)
-- @license GNU General Public License v3

local vector   = require "lib.vrld.hump.vector"
local particle = require "src.main.entities.particle"

-- Module collisions
collision = {}

--- Check collisions from player bullets
function collision.check_player_bullets()
	-- Check all bullets
	for i, bullet in ipairs(game.player.weapon.bullets) do
		-- Check all entities
		for j, entity in ipairs(game.entities) do
			-- Check if entity collides with bullet collider
			if entity.collider and entity.collider:collidesWith(bullet.collider) then
				-- Remove bullet
				table.remove(game.player.weapon.bullets, i)
				-- Make damage
				damaged = entity:damage(bullet.damage)

				local new_particle
				-- Create points particle
				if entity.collider == nil then
					velocity = vector(0, -app.scalefactor*2)
					new_particle = particle(entity.position, velocity, 1, entity.points, "points")
					game.points = game.points + entity.points
					hud:update_points()
				-- Create damage particle
				elseif damaged then
					velocity = vector(app.scalefactor*2, 0)
					new_particle = particle(entity.position, velocity, 1, bullet.damage, "damage")
					new_particle.damaged = true
				end
				table.insert(game.particles, new_particle)

				break
			end
		end
	end
end

--- Check collisions from entities bullets
function collision.check_entities_bullets()
	-- Check all entities
	for i, entity in ipairs(game.entities) do
		-- Check if entity has weapon
		if entity.weapon then
			for j, bullet in ipairs(entity.weapon.bullets) do
				-- Check if player collider with bullet collider
				if game.player.collider and game.player.collider:collidesWith(bullet.collider) then
					-- Remove bullet
					table.remove(entity.weapon.bullets, j)
					-- Make damage
					damaged = game.player:damage(bullet.damage)
					-- Create damaged particle
					if damaged then
						velocity = vector(-app.scalefactor*2, 0)
						new_particle = particle(game.player.position, velocity, 1, bullet.damage, "damage")
						new_particle.damaged = true
						table.insert(game.particles, new_particle)
					end
					break
				end
			end
		end
	end
end

-- Check all collisions
function collision.check()
	-- Check collisions from player bullets
	collision.check_player_bullets()
	-- Check collisions from entities bullets
	collision.check_entities_bullets()
end