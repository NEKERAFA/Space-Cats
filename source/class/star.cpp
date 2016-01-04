/*
	star.cpp
	Creado por Rafael Alcalde Azpiazu (nekerafa@gmail.com) el dom 30 ago 2015 14:54:38 (CEST)

	Constructor de la clase star.

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
#include <cmath>
#include <SDL2/SDL.h>
#include <SDL2/SDL_image.h>
#include <SDL2/SDL_ttf.h>
#include "../include/texture.h"
#include "../include/star.h"

extern texture * img_star;

star::star() {
	x = 0; y = 0;
	vel_x = 0; vel_y = 0;
}

void star::create(int new_x, int new_y) {
	x = new_x;
	y = new_y;
}

void star::set_velocity(int new_x_vel, int new_y_vel) {
	vel_x = new_x_vel;
	vel_y = new_y_vel;
}

void star::render( SDL_Color color ) {
	img_star->setColor(color);
	img_star->render(x, y);
	x += vel_x; y += vel_y;
}

int star::getx() { return x; }

int star::gety() { return y; }	
