/*
	main.cpp
	Creado por Rafael Alcalde Azpiazu (nekerafa@gmail.com) el vie 25 dic 2015 21:07:01 (CET)

	Space Cats es un juego Shoot'em up basado en una guerra espacial de gatos.

	Space Cats is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	Space Cats is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with Foobar. If not, see <http://www.gnu.org/licenses/>.
*/

#include <iostream>
#include <SDL2/SDL.h>
#include <SDL2/SDL_image.h>
#include <SDL2/SDL_ttf.h>
#include "include/app.h"
#include "include/window.h"
#include "include/game.h"

using namespace std;

bool quit = false;

int main(int argc, char * argv[]) {
	int  rval = 0;
	
	// Numeros aleatorios
	srand((unsigned)time(NULL));
	
	// Inicio la aplicación
	if (open_app()) {
		
		load_game();
		
		// Hasta que no se salga de la aplicación, bucle infinito
		while(!quit) {
			// Actualizo eventos
			update_events();
			if(!WINDOW_MINIMIZED) {
				control_game();
				run_game();
				show_fps();
				show_version();
				update_screen();
			}
		}
		
		close_game();

	} else {
		cout << "¡El programa no se pudo inicializar!\n"; rval = -1;
	}

	close_app();

	return rval;
}
