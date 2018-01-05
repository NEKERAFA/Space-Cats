--- Definition of collision functions beetween entities in Space Cats
--
-- @author	Rafael Alcalde Azpiazu (NEKERAFA)
-- @license GNU General Public License v3

local vector   = require "lib.vrld.hump.vector"
local particle = require "src.main.entities.particle"

-- Module collisions
local collision = {}

--- Check collisions from player bullets
-- @tparam player player Player ship
-- @tparam table entities A table with all entities to check
function collision:check_player_bullets(player, entities)
	-- Check all bullets
	for i, bullet in ipairs(player.weapon.bullets) do
		-- Check all entities
		for j, entity in ipairs(entities) do
			-- Check if entity collides with bullet collider
			if entity.collider and entity.collider:collidesWith(bullet.collider) then
				-- Remove bullet
				table.remove(player.weapon.bullets, i)
				-- Make damage
				damaged = entity:damage(bullet.damage)
				return entity, bullet.damage, damaged
			end
		end
	end
end

--- Check collisions from entities bullets
-- @tparam player player Player ship
-- @tparam table entities A table with all entities to check
function collision:check_entities_bullets(player, entities)
	-- Check all entities
	for i, entity in ipairs(entities) do
		-- Check if entity has weapon
		if entity.weapon then
			for j, bullet in ipairs(entity.weapon.bullets) do
				-- Check if player collider with bullet collider
				if player.collider and player.collider:collidesWith(bullet.collider) then
					-- Remove bullet
					table.remove(entity.weapon.bullets, j)
					-- Make damage
					if player:damage(bullet.damage) then
						return bullet.damage
					end
					return nil
				end
			end
		end
	end
end

--- Check all bullet collisions and create particles if it needed
-- @tparam player player Player ship
-- @tparam table entities A table with all entities to check
-- @tparam table particles A table to add particles
function collision:check(player, entities, particles)
	-- Check collisions from player bullets
	entity, damage, damaged = collision:check_player_bullets(player, entities)
	
	-- Create new particle
	if entity and entity.life == 0 then
		new_particle = particle(entity.position, vector(0, -app.scalefactor*2), 1, entity.points, "points")
		table.insert(particles, new_particle)
		return entity.points
	elseif entity and damaged then
		new_particle = particle(entity.position, vector(app.scalefactor*2, 0), 1, damage, "damage")
		new_particle.damaged = damaged
		table.insert(particles, new_particle)
	end
	
	-- Check collisions from entities bullets
	damage = collision:check_entities_bullets(player, entities)
	
	-- Create new particle
	if damage then
		new_particle = particle(player.position, vector(-app.scalefactor*2, 0), 1, damage, "damage")
		new_particle.damaged = true
		table.insert(particles, new_particle)
	end
end

return collision