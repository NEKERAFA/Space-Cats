/*
	timer.cpp
	Creado por Rafael Alcalde Azpiazu (nekerafa@gmail.com) el dom 30 ago 2015 14:55:24 (CEST)

	Constructor de la clase timer para la implementación de temporizadores en SDL.

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
#include <string>
#include <cmath>
#include <SDL2/SDL.h>
#include <SDL2/SDL_image.h>
#include <SDL2/SDL_ttf.h>
#include "../include/timer.h"

// Inicializa las variables
timer::timer() {
	start_time = 0;
	stop_time = 0;
	running = false;
}

// Inicia un temporizador
void timer::start() {
	if(!running) {
		running = true;
		start_time = SDL_GetTicks();
		stop_time = 0;
	}
}

// Detiene un temporizador
void timer::stop() {
	if(running) {
		running = false;
		stop_time = SDL_GetTicks();
		start_time = 0;
	}
}

// Reinicia un temporizador
void timer::reset() {
	stop_time = 0;
	start_time = 0;
	running = false;
}

// Obtiene el tiempo del temporizador
Uint32 timer::time() {
	Uint32 current_time = 0;
	if (running) current_time = SDL_GetTicks() - start_time; 
	else current_time = stop_time;
	return current_time;
}
