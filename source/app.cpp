/*
	app.cpp
	Creado por Rafael Alcalde Azpiazu (nekerafa@gmail.com) el vie 25 dic 2015 02:13:56 (CET)

	Definición de funciones globales.

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
#include <sstream>
#include <string>
#include <SDL2/SDL.h>
#include <SDL2/SDL_image.h>
#include <SDL2/SDL_ttf.h>
#include "include/game.h"
#include "include/texture.h"
#include "include/timer.h"

using namespace std;

/******************************************************************************/
// VARIABLES GLOBALES

// Variables de la ventana
char WINDOW_TITLE[]   = "Space Cats";
bool WINDOW_MINIMIZED = false;
char APP_VERSION[]    = "0.5.0 (alphaka)";
int SCREEN_WIDTH      = 320;
int SCREEN_HEIGHT     = 180;
float SCREEN_SCALE    = 4.0;
int SCREEN_TOTAL_FPS  = 0;
stringstream SCREEN_FPS;
timer * SCREEN_FPS_TIMER = new timer();

// Variables globales
SDL_Window   * WINDOW = NULL;
SDL_Renderer * SCREEN = NULL;
SDL_Event      EVENTS;

// Variables externas
extern bool quit;

// Fuentes
TTF_Font * font_12;

// Colores
SDL_Color yellow = {255, 210, 0};
SDL_Color white = {255, 255, 255, 255};

// Texturas
texture * img_star = new texture();
texture * txt_version = new texture();
texture * txt_fps = new texture();
texture * img_bullet = new texture();

/******************************************************************************/
// FUNCIONES

// Inicia SDL
bool load_SDL() {
	if (SDL_Init(SDL_INIT_EVERYTHING) < 0) {
		cerr << "¡SDL no se pudo inicializar!\nError: " << SDL_GetError() << "\n";
		return false;
	}
	cout << "¡SDL iniciado!\n"; return true;
}

// Inicia más elementos de SDL
bool load_SDL_addons() {
	// Inicia la carga de PNG
	int imgFlags = IMG_INIT_PNG | IMG_INIT_JPG;
	if (!(IMG_Init(imgFlags) & imgFlags)) {
		cerr << "¡No se ha podido iniciar SDL_IMG!\nError: " << IMG_GetError() << "\n";
		return false;
	}
	
	// Inicia el uso de TTF
	if(TTF_Init() == -1) {
		cerr << "¡No se ha podido iniciar SDL_TTF!\nError: " << TTF_GetError() << "\n";
		return false;
	}
	
	return true;
}

// Inicia la ventana
bool load_window() {
	// Crea una nueva ventana
	WINDOW = SDL_CreateWindow(WINDOW_TITLE, SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, SCREEN_WIDTH*SCREEN_SCALE, SCREEN_HEIGHT*SCREEN_SCALE, SDL_WINDOW_SHOWN);// | SDL_WINDOW_FULLSCREEN_DESKTOP);
	
	if (WINDOW == NULL) {
		cerr << "¡SDL no ha podido crear la ventana!\nError: " << SDL_GetError() << "\n";
		return false;
	}
	
	return true;
}

// Inicia el renderizador
bool load_render() {
	// Crea un nuevo renderizado
	SCREEN = SDL_CreateRenderer(WINDOW, -1, SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC);
	
	if (SCREEN == NULL) {
		cerr << "¡SDL no ha podido crear la ventana!\nError: " << SDL_GetError() << "\n";
		return false;
	} else if(!SDL_SetHint(SDL_HINT_RENDER_SCALE_QUALITY, "0")) {
		cerr << "¡SDL no ha podido iniciar hint!\nError: " << SDL_GetError() << "\n";
		return false;
	} else if(SDL_RenderSetLogicalSize(SCREEN, SCREEN_WIDTH, SCREEN_HEIGHT) != 0) {
		cerr << "¡SDL no ha podido escalar el renderizador!\nError: " << SDL_GetError() << "\n";
		return false;
	} else if(SDL_SetRenderDrawColor(SCREEN, 0x00, 0x00, 0x00, 0xFF) != 0) {
		cerr << "¡SDL no ha podido limpiar la pantalla!\nError: " << SDL_GetError() << "\n\n";
		return false;
	}
	
	cout << "¡Render iniciado!\n"; return true;
}

// Carga el icono de la aplicación
bool load_icon() {
	SDL_Surface * icon = IMG_Load("./icon.png");
	if(icon == NULL) {
		cerr << "¡No se ha podido cargar el icono!\nError: " << IMG_GetError( ) << "\n";
		return false;
	}
	SDL_SetWindowIcon(WINDOW, icon);
	SDL_FreeSurface(icon);
	return true;
}

// Carga los elementos externos
bool load_media() {
	// Fuentes
	if ((font_12 = TTF_OpenFont("./res/fonts/terminus.ttf", 12)) == NULL) {
		cerr << "¡No se ha podido cargar la fuente por defecto!\nError: " << TTF_GetError() << "\n\n";
		return false;
	}

	// Texturas
	if (!img_star->load("./res/bg/star.png")) return false;
	if (!img_bullet->load("./res/ships/ball.png")) return false;
	if (!txt_version->load(font_12, APP_VERSION, yellow)) return false;
	return true;
}

// Libera los elementos externos
void free_media() {
	TTF_CloseFont(font_12);
	delete img_star;
	delete img_bullet;
	delete txt_version;
}

// Inicia la aplicación
bool open_app() {
	if(load_SDL() && load_SDL_addons() && load_window() && load_render() && load_media()) {
		SCREEN_FPS_TIMER->start();
		load_icon();
		cout << "¡Listo para funcionar!\n"; return true;
	} else return false;
}

// Cierra la aplicación
void close_app() {
	// Destruimos los elementos
	SDL_DestroyRenderer(SCREEN);
	SDL_DestroyWindow(WINDOW);
	WINDOW = NULL;
	SCREEN = NULL;

	// Cerramos los subsistemas de SDL
	TTF_Quit();
	IMG_Quit();
	SDL_Quit();
}

// Actualiza la pantalla
void update_screen() {
	if(!WINDOW_MINIMIZED) {
		SDL_RenderPresent(SCREEN);
		SDL_SetRenderDrawColor(SCREEN, 0x00, 0x00, 0x00, 0xFF);
		SDL_RenderClear(SCREEN);
		++SCREEN_TOTAL_FPS;
	}
}

// Actualiza los procesos
void update_events() {
	while (SDL_PollEvent(&EVENTS) != 0) {
		const Uint8 *key = SDL_GetKeyboardState( NULL );
		
		if ((EVENTS.type == SDL_QUIT) || key[SDL_SCANCODE_ESCAPE]) {
			quit = true; cout << "Cerrando aplicación...\n";
		}

		if (EVENTS.type == SDL_WINDOWEVENT) {
			if(EVENTS.window.event == SDL_WINDOWEVENT_MINIMIZED)
				WINDOW_MINIMIZED = true;
			else if(EVENTS.window.event == SDL_WINDOWEVENT_MAXIMIZED && EVENTS.window.event == SDL_WINDOWEVENT_RESTORED)
				WINDOW_MINIMIZED = false;
		}
	}
}

void show_version() { txt_version->render(10, 170-txt_fps->getHeight()); }

void show_fps() {
	int avg_fps = SCREEN_TOTAL_FPS/(SCREEN_FPS_TIMER->time()/1000.f);
	if(avg_fps > 1000) { avg_fps = 0; }
	SCREEN_FPS.str("");
	SCREEN_FPS << avg_fps << "fps";
	txt_fps->load(font_12, SCREEN_FPS.str(), white);
	txt_fps->render(310-txt_fps->getWidth(), 170-txt_fps->getHeight());
}
