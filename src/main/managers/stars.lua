-- This module construct and manage a stars sky.
--
-- @classmod src.main.managers.star_manager
-- @see      src.main.entity
-- @author	 Rafael Alcalde Azpiazu (NEKERAFA)
-- @license  GNU General Public License v3

local class  = require "lib.vrld.hump.class"
local vector = require "lib.vrld.hump.vector"
local entity = require "src.main.entitites.entity"

local stars = class {
	--- Create new stars sky object
	-- @tparam stars self A stars to be used
	-- @tparam vector direction Normalized vector with star direction movement
	init = function(self, direction)
		self.direction = direction
		self.stars = {}
		
		for i = 1, self.max_stars do
			position = vector(math.random(8, app.width-8), math.random(8, app.height-8))
			velocity = direction * math.random(2 * app.frameRate, 8 * app.frameRate)
			self.stars[i] = entity(position, velocity, "star")
		end
		
		return stars
	end,
	
	--- Inherit entity class
	__includes = entity,
	
	--- Maximun of starts
	max_stars = 32,

	--- Update all variables and move stars
	-- @tparam stars self Stars object
	-- @tparam number dt Time since the last update in seconds
	update = function(self, dt)
		for i, star in ipairs(self.stars) do
			-- Update star
			star:update(dt)
			
			-- If star go out screen
			if star.position.x < 0 or star.position.x > app.width or
			   star.position.y < 0 or star.position.y > app.height then
				-- Set x position   
				if math.abs(self.direction.y) == 0 then
					star.position.x = app.width
				else
					star.position.x = math.random(8, app.width-8) * math.abs(self.direction.y)
				end
				
				-- Set y position
				if math.abs(self.direction.x) == 0 then
					star.position.y = app.height
				else
					star.position.y = math.random(8, app.width-8) * math.abs(self.direction.x)
				end
				
				velocity = self.direction * math.random(2 * app.frameRate, 8 * app.frameRate)
			end
		end
	end,
	
	--- Remove all stars
	-- @tparam stars self Stars object
	free = function(self)
		self.direction = nil
		while #self.stars > 0 do
			self.stars[1]:free()
			table.remove(self.stars)
		end
	end
}

return stars