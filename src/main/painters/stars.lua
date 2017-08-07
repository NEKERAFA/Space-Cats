--- This module is resposible for draw star sky
--
-- @author	Rafael Alcalde Azpiazu (NEKERAFA)
-- @license GNU General Public License v3

-- Module stars
local stars = {}

--- Draw stars object
-- @tparam stars stars Stars object
function stars.draw(stars)
	for i, star in ipairs(stars.stars) do
		x = math.round(star.position.x)
		y = math.round(star.position.y)
		
		-- Check if star has low velocity
		if (star.velocity.x ~= 0 and math.abs(star.velocity.x) < 5 * app.frameRate) or 
		   ((star.velocity.y ~= 0) and math.abs(star.velocity.y) < 5 * app.frameRate) then
			love.graphics.draw(img.particles.star, x, y)
		-- Show star with high velocity
		else
			love.graphics.draw(img.particles.star, x, y, 0, 2, 2, 1, 1)
		end
	end
end

return stars