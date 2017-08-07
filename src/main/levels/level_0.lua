--- Level 0 of Space Cats
-- Example level
--
-- @author	Rafael Alcalde Azpiazu (NEKERAFA)
-- @license GNU General Public License v3

local small_mouse = require "src.main.entities.ships.small_mouse"
local mouse       = require "src.main.entities.ships.mouse"
local vector      = require "lib.vrld.hump.vector"

-- Level table
level = {}

--- Level background image
level.bgi = img.backgrounds.space
--- Level background music
level.bgm = snd.music.brave_space_explorers
--- Level stars
level.stars = true
--- Level objetive
level.objetive = "finish"
--- Level entities
level.entities = nil
--- Number of ntities
level.entities_stacked = 0

--- Load all level entities
function level:init()
	-- up - middle - up movement
	p1  = vector(app.width + 16, 0)
	p2  = vector(3/4 * app.width, 1/3 * app.height)
	p3  = vector(2/3 * app.width, 0)

	-- down - middle - down movement
	p4  = vector(app.width + 16, app.height)
	p5  = vector(3/4 * app.width, 2/3 * app.height)
	p6  = vector(2/3 * app.width, app.height)

	-- up - middle
	p7  = vector(2/3 * app.width, 1/4 * app.height)

	-- down - middle
	p8  = vector(2/3 * app.width, 3/4 * app.height)
	
	-- middle - middle
	p9  = vector(app.width + 16, 1/2 * app.height)
	p10 = vector(3/4 * app.width, 1/2 * app.height)

	-- First wave
	self.entities = {}
	-- Mouses goes from up
	table.insert(self.entities, {
		object = small_mouse({p1, p2, p3}, p2, 1),
		wait = false,
		time = 6
	})
	table.insert(self.entities, {
		object = small_mouse({p1, p2, p3}, p2, 1),
		wait = false,
		time = 2
	})
	table.insert(self.entities, {
		object = small_mouse({p1, p2, p3}, p2, 1),
		wait = false,
		time = 2
	})
	table.insert(self.entities, {
		object = small_mouse({p1, p2, p3}, p2, 1),
		wait = false,
		time = 2
	})
	-- Mouses goes from down
	table.insert(self.entities, {
		object = small_mouse({p4, p5, p6}, p5, 1),
		wait = false,
		time = 4
	})
	table.insert(self.entities, {
		object = small_mouse({p4, p5, p6}, p5, 1),
		wait = false,
		time = 2
	})
	table.insert(self.entities, {
		object = small_mouse({p4, p5, p6}, p5, 1),
		wait = false,
		time = 2
	})
	table.insert(self.entities, {
		object = small_mouse({p4, p5, p6}, p5, 1),
		wait = false,
		time = 2
	})

	-- Wave 2
	-- Mouse Ships
	table.insert(self.entities, {
		object = mouse(p1, p7, game.player),
		wait = false,
		time = 6
	})
	table.insert(self.entities, {
		object = mouse(p4, p8, game.player),
		wait = false,
		time = 0
	})
	-- Small ships
	table.insert(self.entities, {
		object = small_mouse({p1, p2, p3}, p2, 1),
		wait = false,
		time = 2
	})
	table.insert(self.entities, {
		object = small_mouse({p1, p2, p3}, p2, 1),
		wait = false,
		time = 2
	})
	table.insert(self.entities, {
		object = small_mouse({p1, p2, p3}, p2, 1),
		wait = false,
		time = 2
	})
	table.insert(self.entities, {
		object = small_mouse({p4, p5, p6}, p5, 1),
		wait = false,
		time = 2
	})
	table.insert(self.entities, {
		object = small_mouse({p4, p5, p6}, p5, 1),
		wait = false,
		time = 2
	})
	table.insert(self.entities, {
		object = small_mouse({p4, p5, p6}, p5, 1),
		wait = false,
		time = 2
	})

	-- Wave 3
	table.insert(self.entities, {
		object = mouse(p1, p7, game.player),
		wait = true,
		time = 4,
	})
	table.insert(self.entities, {
		object = mouse(p4, p8, game.player),
		wait = false,
		time = 0
	})
	table.insert(self.entities, {
		object = mouse(p9, p10, game.player),
		wait = false,
		time = 2
	})

	level.entities_stacked = #self.entities
end