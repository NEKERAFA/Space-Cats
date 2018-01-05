{
	--- Level 0 of Space Cats
	-- Example level
	
	--- Level name
	name = "Stage 0\nA new dawn",
	--- Level background image
	bgi = img.backgrounds.space,
	--- Level background music
	bgm = snd.music.brave_space_explorers,
	--- Level stars
	stars = true,
	--- Level objetive
	objetive = "finish",

	--- Level entities
	entities = {
		-- First dialog
		{
			wait = false,
			time = 0,
			type = "dialog",
			args = {msg_string.controls, msg_string.help}
		},
		
		-- First wave
		{
			wait = true,
			time = 4,
			type = "small_mouse",
			args = {
				{{x = 320, y = 0}, {x = 240, y = 60}, {x = 160, y = 0}}, {x = 240, y = 60}, 1
			}
		},
		{
			wait = false,
			time = 2,
			type = "small_mouse",
			args = {
				{{x = 320, y = 0}, {x = 240, y = 60}, {x = 160, y = 0}}, {x = 240, y = 60}, 1
			}
		},
		{
			wait = false,
			time = 2,
			type = "small_mouse",
			args = {
				{{x = 320, y = 0}, {x = 240, y = 60}, {x = 160, y = 0}}, {x = 240, y = 60}, 1
			}
		},
		{
			wait = false,
			time = 2,
			type = "small_mouse",
			args = {
				{{x = 320, y = 0}, {x = 240, y = 60}, {x = 160, y = 0}}, {x = 240, y = 60}, 1
			}
		},
		{
			wait = false,
			time = 2,
			type = "small_mouse",
			args = {
				{{x = 320, y = 0}, {x = 240, y = 60}, {x = 160, y = 0}}, {x = 240, y = 60}, 1
			}
		},

		-- Second wave
		{
			wait = false,
			time = 4,
			type = "small_mouse",
			args = {
				{{x = 320, y = 180}, {x = 240, y = 120}, {x = 160, y = 180}}, {x = 240, y = 120}, 1
			}
		},
		{
			wait = false,
			time = 2,
			type = "small_mouse",
			args = {
				{{x = 320, y = 180}, {x = 240, y = 120}, {x = 160, y = 180}}, {x = 240, y = 120}, 1
			}
		},
		{
			wait = false,
			time = 2,
			type = "small_mouse",
			args = {
				{{x = 320, y = 180}, {x = 240, y = 120}, {x = 160, y = 180}}, {x = 240, y = 120}, 1
			}
		},
		{
			wait = false,
			time = 2,
			type = "small_mouse",
			args = {
				{{x = 320, y = 180}, {x = 240, y = 120}, {x = 160, y = 180}}, {x = 240, y = 120}, 1
			}
		},
		{
			wait = false,
			time = 2,
			type = "small_mouse",
			args = {
				{{x = 320, y = 180}, {x = 240, y = 120}, {x = 160, y = 180}}, {x = 240, y = 120}, 1
			}
		},

		-- Third wave
		-- Big ships
		{
			wait = true,
			time = 4,
			type = "mouse",
			args = { {x = 320, y = 0}, {x = 240, y = 60} }
		},
		{
			wait = false,
			time = 0,
			type = "mouse",
			args = { {x = 320, y = 180}, {x = 240, y = 120} }
		},
		
		-- Small ships
		{
			wait = true,
			time = 1,
			type = "small_mouse",
			args = {
				{{x = 320, y = 180}, {x = 240, y = 120}, {x = 160, y = 180}}, {x = 240, y = 120}, 1
			}
		},
		{
			wait = false,
			time = 1,
			type = "small_mouse",
			args = {
				{{x = 320, y = 0}, {x = 240, y = 60}, {x = 160, y = 0}}, {x = 240, y = 60}, 1
			}
		},
		{
			wait = false,
			time = 1,
			type = "small_mouse",
			args = {
				{{x = 320, y = 180}, {x = 240, y = 120}, {x = 160, y = 180}}, {x = 240, y = 120}, 1
			}
		},
		{
			wait = false,
			time = 1,
			type = "small_mouse",
			args = {
				{{x = 320, y = 0}, {x = 240, y = 60}, {x = 160, y = 0}}, {x = 240, y = 60}, 1
			}
		},
		{
			wait = false,
			time = 1,
			type = "small_mouse",
			args = {
				{{x = 320, y = 180}, {x = 240, y = 120}, {x = 160, y = 180}}, {x = 240, y = 120}, 1
			}
		},
		{
			wait = false,
			time = 1,
			type = "small_mouse",
			args = {
				{{x = 320, y = 0}, {x = 240, y = 60}, {x = 160, y = 0}}, {x = 240, y = 60}, 1
			}
		},
		{
			wait = false,
			time = 1,
			type = "small_mouse",
			args = {
				{{x = 320, y = 180}, {x = 240, y = 120}, {x = 160, y = 180}}, {x = 240, y = 120}, 1
			}
		},
		{
			wait = false,
			time = 1,
			type = "small_mouse",
			args = {
				{{x = 320, y = 0}, {x = 240, y = 60}, {x = 160, y = 0}}, {x = 240, y = 60}, 1
			}
		},
		{
			wait = false,
			time = 1,
			type = "small_mouse",
			args = {
				{{x = 320, y = 180}, {x = 240, y = 120}, {x = 160, y = 180}}, {x = 240, y = 120}, 1
			}
		},
		{
			wait = false,
			time = 1,
			type = "small_mouse",
			args = {
				{{x = 320, y = 0}, {x = 240, y = 60}, {x = 160, y = 0}}, {x = 240, y = 60}, 1
			}
		},
		{
			wait = false,
			time = 1,
			type = "small_mouse",
			args = {
				{{x = 320, y = 180}, {x = 240, y = 120}, {x = 160, y = 180}}, {x = 240, y = 120}, 1
			}
		},
		{
			wait = false,
			time = 1,
			type = "small_mouse",
			args = {
				{{x = 320, y = 0}, {x = 240, y = 60}, {x = 160, y = 0}}, {x = 240, y = 60}, 1
			}
		},
		{
			wait = false,
			time = 1,
			type = "small_mouse",
			args = {
				{{x = 320, y = 180}, {x = 240, y = 120}, {x = 160, y = 180}}, {x = 240, y = 120}, 1
			}
		},
		{
			wait = false,
			time = 1,
			type = "small_mouse",
			args = {
				{{x = 320, y = 0}, {x = 240, y = 60}, {x = 160, y = 0}}, {x = 240, y = 60}, 1
			}
		},
		{
			wait = false,
			time = 1,
			type = "small_mouse",
			args = {
				{{x = 320, y = 180}, {x = 240, y = 120}, {x = 160, y = 180}}, {x = 240, y = 120}, 1
			}
		},
		{
			wait = false,
			time = 1,
			type = "small_mouse",
			args = {
				{{x = 320, y = 0}, {x = 240, y = 60}, {x = 160, y = 0}}, {x = 240, y = 60}, 1
			}
		},
		{
			wait = false,
			time = 1,
			type = "small_mouse",
			args = {
				{{x = 320, y = 180}, {x = 240, y = 120}, {x = 160, y = 180}}, {x = 240, y = 120}, 1
			}
		},
		{
			wait = false,
			time = 1,
			type = "small_mouse",
			args = {
				{{x = 320, y = 0}, {x = 240, y = 60}, {x = 160, y = 0}}, {x = 240, y = 60}, 1
			}
		},
		{
			wait = false,
			time = 1,
			type = "small_mouse",
			args = {
				{{x = 320, y = 180}, {x = 240, y = 120}, {x = 160, y = 180}}, {x = 240, y = 120}, 1
			}
		},
		{
			wait = false,
			time = 1,
			type = "small_mouse",
			args = {
				{{x = 320, y = 0}, {x = 240, y = 60}, {x = 160, y = 0}}, {x = 240, y = 60}, 1
			}
		},
		{
			wait = false,
			time = 1,
			type = "small_mouse",
			args = {
				{{x = 320, y = 180}, {x = 240, y = 120}, {x = 160, y = 180}}, {x = 240, y = 120}, 1
			}
		},
		{
			wait = false,
			time = 1,
			type = "small_mouse",
			args = {
				{{x = 320, y = 0}, {x = 240, y = 60}, {x = 160, y = 0}}, {x = 240, y = 60}, 1
			}
		},
		
		-- Five wave
		-- Big ships
		{
			wait = true,
			time = 4,
			type = "mouse",
			args = { {x = 320, y = 0}, {x = 160, y = 60} }
		},
		{
			wait = false,
			time = 0,
			type = "mouse",
			args = { {x = 320, y = 180}, {x = 160, y = 120} }
		},
		{
			wait = false,
			time = 0,
			type = "mouse",
			args = { {x = 320, y = 90}, {x = 240, y = 90} }
		},
		
		-- Small ships
		{
			wait = false,
			time = 4,
			type = "small_mouse",
			args = {
				{{x = 320, y = 180}, {x = 240, y = 120}, {x = 160, y = 180}}, {x = 240, y = 120}, 2
			}
		},
		{
			wait = false,
			time = 2,
			type = "small_mouse",
			args = {
				{{x = 320, y = 0}, {x = 240, y = 60}, {x = 160, y = 0}}, {x = 240, y = 60}, 2
			}
		},
				{
			wait = false,
			time = 2,
			type = "small_mouse",
			args = {
				{{x = 320, y = 180}, {x = 240, y = 120}, {x = 160, y = 180}}, {x = 240, y = 120}, 2
			}
		},
		{
			wait = false,
			time = 2,
			type = "small_mouse",
			args = {
				{{x = 320, y = 0}, {x = 240, y = 60}, {x = 160, y = 0}}, {x = 240, y = 60}, 2
			}
		},
				{
			wait = false,
			time = 2,
			type = "small_mouse",
			args = {
				{{x = 320, y = 180}, {x = 240, y = 120}, {x = 160, y = 180}}, {x = 240, y = 120}, 2
			}
		},
		{
			wait = false,
			time = 2,
			type = "small_mouse",
			args = {
				{{x = 320, y = 0}, {x = 240, y = 60}, {x = 160, y = 0}}, {x = 240, y = 60}, 2
			}
		},
		{
			wait = false,
			time = 2,
			type = "small_mouse",
			args = {
				{{x = 320, y = 180}, {x = 240, y = 120}, {x = 160, y = 180}}, {x = 240, y = 120}, 2
			}
		},
		{
			wait = false,
			time = 2,
			type = "small_mouse",
			args = {
				{{x = 320, y = 0}, {x = 240, y = 60}, {x = 160, y = 0}}, {x = 240, y = 60}, 2
			}
		},
		{
			wait = false,
			time = 2,
			type = "small_mouse",
			args = {
				{{x = 320, y = 180}, {x = 240, y = 120}, {x = 160, y = 180}}, {x = 240, y = 120}, 2
			}
		},
		{
			wait = false,
			time = 2,
			type = "small_mouse",
			args = {
				{{x = 320, y = 0}, {x = 240, y = 60}, {x = 160, y = 0}}, {x = 240, y = 60}, 2
			}
		},
		{
			wait = false,
			time = 2,
			type = "small_mouse",
			args = {
				{{x = 320, y = 180}, {x = 240, y = 120}, {x = 160, y = 180}}, {x = 240, y = 120}, 2
			}
		},
		{
			wait = false,
			time = 2,
			type = "small_mouse",
			args = {
				{{x = 320, y = 0}, {x = 240, y = 60}, {x = 160, y = 0}}, {x = 240, y = 60}, 2
			}
		},
		{
			wait = false,
			time = 1,
			type = "small_mouse",
			args = {
				{{x = 320, y = 180}, {x = 240, y = 120}, {x = 160, y = 180}}, {x = 240, y = 120}, 2
			}
		},
		{
			wait = false,
			time = 1,
			type = "small_mouse",
			args = {
				{{x = 320, y = 0}, {x = 240, y = 60}, {x = 160, y = 0}}, {x = 240, y = 60}, 2
			}
		},
		{
			wait = false,
			time = 1,
			type = "small_mouse",
			args = {
				{{x = 320, y = 180}, {x = 240, y = 120}, {x = 160, y = 180}}, {x = 240, y = 120}, 2
			}
		},
		{
			wait = false,
			time = 1,
			type = "small_mouse",
			args = {
				{{x = 320, y = 0}, {x = 240, y = 60}, {x = 160, y = 0}}, {x = 240, y = 60}, 2
			}
		},
		{
			wait = false,
			time = 1,
			type = "small_mouse",
			args = {
				{{x = 320, y = 180}, {x = 240, y = 120}, {x = 160, y = 180}}, {x = 240, y = 120}, 2
			}
		},
		{
			wait = false,
			time = 1,
			type = "small_mouse",
			args = {
				{{x = 320, y = 0}, {x = 240, y = 60}, {x = 160, y = 0}}, {x = 240, y = 60}, 2
			}
		},
		{
			wait = false,
			time = 1,
			type = "small_mouse",
			args = {
				{{x = 320, y = 180}, {x = 240, y = 120}, {x = 160, y = 180}}, {x = 240, y = 120}, 2
			}
		},
		{
			wait = false,
			time = 1,
			type = "small_mouse",
			args = {
				{{x = 320, y = 0}, {x = 240, y = 60}, {x = 160, y = 0}}, {x = 240, y = 60}, 2
			}
		},
		{
			wait = false,
			time = 1,
			type = "small_mouse",
			args = {
				{{x = 320, y = 180}, {x = 240, y = 120}, {x = 160, y = 180}}, {x = 240, y = 120}, 2
			}
		},
		{
			wait = false,
			time = 1,
			type = "small_mouse",
			args = {
				{{x = 320, y = 0}, {x = 240, y = 60}, {x = 160, y = 0}}, {x = 240, y = 60}, 2
			}
		},
		{
			wait = false,
			time = 1,
			type = "small_mouse",
			args = {
				{{x = 320, y = 180}, {x = 240, y = 120}, {x = 160, y = 180}}, {x = 240, y = 120}, 2
			}
		},
		{
			wait = false,
			time = 1,
			type = "small_mouse",
			args = {
				{{x = 320, y = 0}, {x = 240, y = 60}, {x = 160, y = 0}}, {x = 240, y = 60}, 2
			}
		},
		{
			wait = false,
			time = 1,
			type = "small_mouse",
			args = {
				{{x = 320, y = 180}, {x = 240, y = 120}, {x = 160, y = 180}}, {x = 240, y = 120}, 2
			}
		},
		{
			wait = false,
			time = 1,
			type = "small_mouse",
			args = {
				{{x = 320, y = 0}, {x = 240, y = 60}, {x = 160, y = 0}}, {x = 240, y = 60}, 2
			}
		}
	}
}