--- Level 0 of Space Cats
-- Example level
--
-- @author	Rafael Alcalde Azpiazu (NEKERAFA)
-- @license GNU General Public License v3

local small_mouse = require "src.main.entities.ships.small_mouse"
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
level.entities = {}
--- Number of ntities
level.entities_stacked = 0

--- Load all level entities
function level:init()
	-- up - middle - up movement
	p1 = vector(app.width + 16, 0)
	p2 = vector(app.width / 1.25, app.height / 3)
	p3 = vector(2 * app.width / 3, 0)

	-- down - middle - down movement
	p4 = vector(app.width + 16, app.height)
	p5 = vector(app.width / 1.25, 2 * app.height / 3)
	p6 = vector(2 * app.width / 3, app.height)

	-- up - middle
	p7 = vector(2 * app.width / 3, app.height / 4)

	-- down - middle
	p9 = vector(2 * app.width / 3, 3 * app.height / 4)

	-- First wave
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

	table.insert(self.entities, {
		object = small_mouse({p4, p5, p6}, p5, 1),
		wait = false,
		time = 6
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

	level.entities_stacked = 8
end