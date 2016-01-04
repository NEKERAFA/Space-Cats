/*
	utils.cpp
	Creado por Rafael Alcalde Azpiazu (nekerafa@gmail.com) el dom 30 ago 2015 14:55:35 (CEST)

	Utilidades y funciones diversas para el juego.

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

#include <cstdlib>
#include <iostream>
#include <string>
#include <cmath>
#include <SDL2/SDL.h>
#include <SDL2/SDL_image.h>
#include <SDL2/SDL_ttf.h>
#include "include/texture.h"
#include "include/window.h"
#include "include/star.h"

using namespace std;

// Estrellas
star bg_stars[8];

// Color blanco
extern SDL_Color white;

// Randomer: Create a random number
int randomer(int from, int until) {
	// Save random number
	int random_value;
	// Set random value
	random_value = rand()%(until-from+1) + from;

	return random_value;
}

// Definición de estrellas
void generate_stars() {
	for(int i = 0; i < 8; i++)
	{
		bg_stars[i].create(randomer(0, SCREEN_WIDTH), randomer(0, SCREEN_HEIGHT));
		bg_stars[i].set_velocity(-randomer(4, 8), 0);
	}
}

// Muestra las estrellas
void show_stars() {
	for(int i = 0; i < 8; i++)
	{
		bg_stars[i].render(white);
		if(bg_stars[i].getx() < 0) {
			bg_stars[i].create(SCREEN_WIDTH, randomer(0, SCREEN_HEIGHT));
			bg_stars[i].set_velocity(-randomer(4, 8), 0);
		}
	}
}

int chartoint(char c) { return c-'0'; }

bool colision(SDL_Rect a, SDL_Rect b) {
	return ((a.x < b.x+b.w) && (a.x+a.w > b.x) && (a.y < b.y+b.h) && (a.y+a.h > b.y));
}
