--- This module is resposible for draw particles like damage and points
--
-- @author	Rafael Alcalde Azpiazu (NEKERAFA)
-- @license GNU General Public License v3

-- Module particle
local particles = {}

--- Draw point particle
-- @tparam particle particle Particle to draw
function particles.draw_points(particle)
	r, g, b, a = love.graphics.getColor()
	
	-- Particle name
	name = tostring(particle.value) .. "_p"
	-- Center of particle
	mid_width = img.particles[name]:getWidth()/2
	height = img.particles[name]:getHeight()
	-- Coordenates
	local x = math.round(particle.position.x)
	local y = math.round(particle.position.y)
	-- Alpha value
	-- This value make four blinks in 1 second
	alpha = math.round(math.abs(math.cos(particle.lifetime*8*math.pi))) * 255
	
	-- Set points color
	if particle.value == 10 then
		love.graphics.setColor(255, 255, 255, alpha)
	elseif particle.value == 30 then
		love.graphics.setColor(64*particle.lifetime, 255, 0, alpha)
	elseif particle.value == 50 then
		love.graphics.setColor(255, 191+64*particle.lifetime, 0, alpha)
	elseif particle.value == 100 then
		love.graphics.setColor(0, 191+64*particle.lifetime, 255, alpha)
	end
	
	love.graphics.draw(img.particles[name], x, y, 0, 1, 1, mid_width, height)
	
	love.graphics.setColor(r, g, b, a)
end

--- Draw damage particle
-- @tparam particle particle Particle to draw
function particles.draw_damage(particle)
	r, g, b, a = love.graphics.getColor()
	
	-- Particle name
	name = tostring(particle.value) .. "_d"
	-- Center of particle
	mid_width = img.particles[name]:getWidth()/2
	height = img.particles[name]:getHeight()
	-- Coordenates
	local x = math.round(particle.position.x)
	local y = math.round(particle.position.y)
	
	-- Set damage particle color
	if particle.damaged then
		love.graphics.setColor(255, 128*particle.lifetime, 0, 255)
	else
		love.graphics.setColor(191+64*particle.lifetime, 191+64*particle.lifetime, 191+64*particle.lifetime, 255)
	end
	
	love.graphics.draw(img.particles[name], x, y, 0, 1, 1, mid_width, height)
	
	love.graphics.setColor(r, g, b, a)
end

--- Draw particles
-- @tparam table particles_table Table with all particle to draw
function particles.draw(particles_table)
	for pos, particle in ipairs(particles_table) do
		-- Draw points particle
		if particle.type == "points" then
			particles.draw_points(particle)
		-- Draw damage particle
		elseif particle.type == "damage" then
			particles.draw_damage(particle)
		end
	end
end

return particles