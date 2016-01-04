/*
	playership.cpp
	Creado por Rafael Alcalde Azpiazu (nekerafa@gmail.com) el vie 25 dic 2015 00:39:21 (CET)

	Cabecera de la clase nave del jugador.

	Space Cats is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	Space Cats is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with Foobar.  If not, see <http://www.gnu.org/licenses/>.
*/


#include <SDL2/SDL.h>
#include <SDL2/SDL_image.h>
#include <SDL2/SDL_ttf.h>
#include <string>
#include <algorithm>
#include "../../include/window.h"
#include "../../include/texture.h"
#include "../../include/timer.h"
#include "../../include/weapon.h"
#include "../../include/ship/ship.hpp"
#include "../../include/ship/playership.hpp"

extern texture * img_bullet;

// Crea una nave
playership::playership(int x, int y, int life) : ship(x, y, life) {
	textureship->load("./res/ships/ship-cat.png");
	textureboost->load("./res/ships/combustion.png");
	textureboom->load("./res/ships/explosion.png");
	weaponship = new weapon(img_bullet, 250);
}

// Destruye la nave
playership::~playership() {}

// Actualiza los elementos internos
void playership::update() {
	frameboost = std::min((int) timerboost->time()/100, 3);
	if (timerboost->time() >= 300) { timerboost->reset(); timerboost->start(); }
	if (life == 0 && timerboom->time() == 0) timerboom->start();
	frameboom = std::min((int) timerboom->time()/100, 7);
	if (timerboom->time() >= 700 && !kill) { kill = true; }
}

// Renderiza la nave
void playership::render() {
	if(life > 0) {
		textureship->render(x-16, y-16);
		textureboost->render(x-32, y-8, 0, frameboost*16, 16, 16);
	} else textureboom->render(x-16, y-16, 0, frameboom*32, 32, 32);
	weaponship->render();
}

// Mueve la nave
void playership::move() {
	const Uint8 *key = SDL_GetKeyboardState(NULL);
	
	if (key[SDL_SCANCODE_W] && y > 45) y -= 2;
	if (key[SDL_SCANCODE_S] && y < SCREEN_HEIGHT-16) y += 2;
	if (key[SDL_SCANCODE_A] && x > 16) x -= 2;
	if (key[SDL_SCANCODE_D] && x < SCREEN_WIDTH-16) x += 2;
	if (key[SDL_SCANCODE_SPACE]) weaponship->shoot(x+16, y, 4);
}

// Obtiene la hit box de la nave
SDL_Rect playership::getHitBox() {
	SDL_Rect hit_box = {x-16, y-16, 32, 32};
	return hit_box;
}
