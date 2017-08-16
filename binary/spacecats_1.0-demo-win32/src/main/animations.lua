--- Definition of all tweenings and animations
--
-- @author	Rafael Alcalde Azpiazu (NEKERAFA)
-- @license GNU General Public License v3

local timer     = require "lib.vrld.hump.timer"
local gamestate = require "lib.vrld.hump.gamestate"

-- Module animation
local animation = {}

--- Show menu
function animation.show_menu()
	timer.tween(2, menu.ship.position, {x = app.width+32}, 'linear', function() menu.current = "start" end)
end

--- Move down title menu
function animation.title_down()
	timer.tween(1, menu, {title_delta = 2}, 'out-quad', animation.title_up)
end

--- Move up title
function animation.title_up()
	timer.tween(1, menu, {title_delta = -2}, 'out-quad', animation.title_down)
end

--- Increment alpha bright
function animation.inc_alpha()
	timer.tween(0.5, menu, {b_alpha = 255}, 'in-quad', animation.dec_alpha)
end

--- Decrement alpha bright
function animation.dec_alpha()
	timer.tween(0.5, menu, {b_alpha = 0}, 'in-quad', animation.inc_alpha)
end

--- Save text animation
function animation.save_text()
	timer.script(function(wait)
			-- Show text
			timer.tween(1, menu, {t_alpha = 255}, 'in-quad')
			wait(2)
			-- Move text if it need
			if txt.saved:getWidth() > app.width-5 then
				timer.tween(4, menu, {x_delta = app.width - 10 - txt.saved:getWidth()}, 'out-quad')
				wait(6)
			else
				wait(6)
			end
			-- Remove text
			timer.tween(1, menu, {t_alpha = 0}, 'in-quad')
			wait(1)
			menu.x_delta = 0
	end)
end

--- Change to start menu
function animation.change_start()
	menu.current = "change start"
	timer.tween(0.5, menu, {delta = 0}, 'out-quad', function() menu.current = "start" end)
	timer.tween(0.5, menu, {planet = {x0 = 92}}, 'out-expo')
end

--- Change to settings menu
function animation.change_settings()
	menu.current = "change settings"
	timer.tween(0.5, menu, {delta = app.width}, 'out-quad', function() menu.current = "settings" end)
	timer.tween(0.5, menu, {planet = {x0 = 32}}, 'out-expo')
end

--- Change to level selection menu
function animation.change_levels()
	menu.current = "change levels"
	timer.tween(0.5, menu, {delta = -app.width}, 'out-quad', function() menu.current = "levels" end)
	timer.tween(0.5, menu, {planet = {x0 = 0}}, 'out-expo')
end

--- Show game opening animation
function animation.game_opening()
	timer.script(function(wait)
		-- Show level title
		timer.tween(0.5, game.anim, {x_label = 160}, "in-quad")
		wait(2)
		-- Show player
		timer.tween(1, game.anim.player.position, {x = 32}, 'out-quad')
		timer.tween(1, game.anim.player.position, {y = 90}, 'linear')
		wait(1)
		-- Remove lines and level title
		timer.tween(1, game.anim, {x_lines = 320}, "linear")
		wait(1)
		timer.tween(0.5, game.anim, {x_label = 328 + game.anim.label:getWidth()}, "out-quad")
		wait(1)
		-- Set true game start
		game.started = true
	end)
end

--- Show game ending animation
function animation.game_ending()
	timer.script(function(wait)
		-- Show level title and lines
		timer.tween(1, game.anim, {x_lines = 0}, "linear")
		timer.tween(0.5, game.anim, {x_label = 160}, "out-quad")
		wait(3)
		timer.tween(0.5, game.anim, {x_label = -8-game.anim.label:getWidth()}, "out-quad")
		wait(1)
		-- Go back menu
		gamestate.switch(menu)
	end)
end

return animation