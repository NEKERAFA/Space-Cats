--- Definition of all tweenings and animations
--
-- @module  animation
-- @author	Rafael Alcalde Azpiazu (NEKERAFA)
-- @license GNU General Public License v3

local timer  = require "lib.vrld.hump.timer"

-- Module animation
animation = {}

--- Show menu
function animation.show_menu()
	timer.tween(2, menu, {player = {x = app.width + 32}}, 'in-quad', function() menu.current = "start" end)
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
				timer.tween(4, menu, {x_delta = app.width - 5 - txt.saved:getWidth()}, 'out-quad')
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