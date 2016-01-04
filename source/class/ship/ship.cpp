/*
	ship.cpp
	Creado por Rafael Alcalde Azpiazu (nekerafa@gmail.com) el jue 24 dic 2015 20:06:19 CET 

	Constructor de la clase nave.

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
#include "../../include/texture.h"
#include "../../include/timer.h"
#include "../../include/ship/ship.hpp"

// Crea una nueva nave
ship::ship(int x, int y, int life) : x (x), y (y), life (life), frameboost (0), frameboom (0), kill (false) {
	textureship = new texture();
	textureboost = new texture();
	textureboom = new texture();
	timerboost = new timer();
	timerboom = new timer();
	timerboost->start();
}

// Destruye la nave
ship::~ship() {
	delete textureship; delete textureboost; delete textureboom;
	delete weaponship; delete timerboost; delete timerboom;
}

// Obtiene la posición de la nave
int ship::getX() { return x; }
int ship::getY() { return y; }

// Obtiene la vida
int ship::getLife() { return life; }

// Elimina una vida
void ship::makeDamage() { --life; }

// Reinicia la información de la nave
void ship::reset(int x, int y, int life) {
	this->x = x; this->y = y; this->life = life; kill = false;
	frameboom = 0; frameboost = 0;
	timerboost->reset(); timerboost->start();
	timerboom->reset();
	for(int i = 0; i < MAX_WEAPON; ++i) weaponship->kill(i);
}

// Destruye una bala
void ship::killBullet(int i) { weaponship->kill(i); }

// Obtiene la hitbox de una bala
SDL_Rect ship::getBulletHitBox(int i) {
	return weaponship->getHitBox(i);
}

// Devuelve el estado de la nave
bool ship::isKilled() { return kill; }
