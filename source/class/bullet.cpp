/*
	bullet.cpp
	Creado por Rafael Alcalde Azpiazu (nekerafa@gmail.com) el sáb 26 dic 2015 16:30:21 (CET)

	Constructor la clase bala.

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
#include "../include/texture.h"
#include "../include/bullet.h"
#include "../include/window.h"

// Crea una bala
bullet::bullet(texture * img_bullet) {
	x = 0; y = 0; vel_x = 0; vel_y = 0;
	this->img_bullet = img_bullet;
	dead = true;
}

// Inicializa una bala
void bullet::create( int x, int y, int vel_x, int vel_y ) {
	this->x = x; this->y = y;
	this->vel_x = vel_x; this->vel_y = vel_y;
	dead = false;
}

// Muestra la bala
void bullet::show() {
	if (!dead) {
		img_bullet->render(x, y); x += vel_x; y += vel_y;
		if ((x < 0) || (x > SCREEN_WIDTH) || (y < 0) || (y > SCREEN_HEIGHT)) dead = true;
	}
}

// Obtiene las posiciones de la bala
int bullet::getX() { return x; }
int bullet::getY() { return y; }

// Mata la bala
void bullet::kill() { dead = true; }

// Mira si la bala ha muerto
bool bullet::isDead() { return dead; }

// Obtiene la hit box de la bala
SDL_Rect bullet::getHitBox() {
	SDL_Rect hit_box {x, y, 8, 8};
	if(dead) {hit_box.x = 0; hit_box.y = 0; hit_box.w = 0; hit_box.h = 0;}
	return hit_box;
}
