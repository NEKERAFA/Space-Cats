/*
	smouse_ship.hpp
	Creado por Rafael Alcalde Azpiazu (nekerafa@gmail.com) el dom 03 ene 2015 14:49:16 (CET)

	Cuerpo de la clase constructora de nave pequeña ratón.

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

#include <iostream>
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
#include "../../include/ship/enemyship.hpp"
#include "../../include/ship/smouse_ship.hpp"

extern texture * img_bullet;

// Crea una nave
smouse_ship::smouse_ship(int type): enemyship(1, 3), status (0), type (type) {
	x = SCREEN_WIDTH;
	textureship->load("./res/ships/ship-mouse.png");
	textureboost->load("./res/ships/combustion.png");
	textureboost->setFlip(SDL_FLIP_HORIZONTAL);
	textureboom->load("./res/ships/explosion.png");
	weaponship = new weapon(img_bullet, 100);
}

// Destruye la nave
smouse_ship::~smouse_ship() {}

// Elimina una vida
void smouse_ship::makeDamage() {
	if(status != 0) --life;
}

// Reinicia la información de la nave
void smouse_ship::reset(int type) {
	enemyship::reset(1, 3);
	this->status = 0; this->type = type;
	this->x = SCREEN_WIDTH;
}

// Actualiza los elementos internos
void smouse_ship::update() {
	frameboost = std::min((int) timerboost->time()/100, 3);
	if (timerboost->time() >= 300) { timerboost->reset(); timerboost->start(); }
	if (life == 0 && timerboom->time() == 0) timerboom->start();
	frameboom = std::min((int) timerboom->time()/100, 7);
	if (timerboom->time() >= 700 && !kill) { kill = true; }
}

// Renderiza la nave
void smouse_ship::render() {
	if(life > 0) {
		textureship->render(x-16, y-16);
		textureboost->render(x+16, y-8, 0, frameboost*16, 16, 16);
	} else textureboom->render(x-16, y-16, 0, frameboom*32, 32, 32);
	weaponship->render();
}

// Mueve la nave
void smouse_ship::move() {
	if(life > 0)
		switch(status) {
			// Start move
			case 0:
				if (weaponship->shotBullets() < 1) weaponship->shoot(x-8, y, -4);
				--x; if (y < 154) y += 2;
				if (x < 237) {status = 1; shootburst->start();}
				break;
			case 1:
				if (weaponship->shotBullets() < 3) weaponship->shoot(x-8, y, -4);
				else status = 2;
				break;
			case 2:
				--y; if (y < 50) status = 3;
				break;
			case 3:
				if (weaponship->shotBullets() < 3) weaponship->shoot(x-8, y, -4);
				else status = 4;
				break;
			case 4:
				++y; if (y > 154) status = 1;
				break;
		}
}

/* Mueve la nave
void smouse_ship::move(playership * player_ship) {
	switch(status) {
		// Start move
		case 0:
			--x; if (y < player_ship->getY()) y += 2;
			if (x < 237) {status = 1; shootburst->start();}
			break;
		case 1:
			if (weaponship->shotBullets() < 3) weaponship->shoot(x-8, y, -4);
			else status = 2;
			break;
		case 2:
			--y; if (y < 50) status = 3;
			break;
		case 3:
			if (weaponship->shotBullets() < 3) weaponship->shoot(x-8, y, -4);
			else status = 4;
			break;
		case 4:
			if (y > player_ship->getY()) --y;
			else if (y < player_ship->getY()) ++y;
			else status = 1;
			break;
	}
}*/

// Obtiene la hit box de la nave
SDL_Rect smouse_ship::getHitBox() {
	SDL_Rect hit_box = {x-16, y-16, 32, 32};
	return hit_box;
}
