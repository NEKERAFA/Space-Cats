/*
	game.cpp
	Creado por Rafael Alcalde Azpiazu (nekerafa@gmail.com) el vie 25 dic 2015 22:36:06 (CET)

	Definición de funciones del juego.

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
#include "include/texture.h"
#include "include/ship/playership.hpp"
#include "include/ship/smouse_ship.hpp"
#include "include/weapon.h"

/******************************************************************************/
// Variables
playership * player_ship;
smouse_ship * enemy_ship;
texture * bgspace;
texture * life;

bool enemy = true;

// Cabeceras externas
void show_stars();
void generate_stars();
bool colision(SDL_Rect a, SDL_Rect b);

/******************************************************************************/
// Funciones

// Carga el juego
void load_game() {
	player_ship = new playership(32, 102, 4);
	if(enemy) { enemy_ship = new smouse_ship(0); }
	else { enemy_ship = new smouse_ship(1); }
	bgspace = new texture();
	life = new texture();
	bgspace->load("./res/bg/space.png");
	life->load("./res/hud/life.png");
	generate_stars();
}

// Cierra el juego y elimina los recursos
void close_game() {
	delete player_ship;
	delete enemy_ship;
	delete bgspace;
	delete life;
}

// Controla los elementos del juego
void control_game() {
	player_ship->move();
	enemy_ship->move();
}

// Muestra la vida del jugador
void show_life() {
	for (int i = 1; i <= player_ship->getLife(); i++)
		life->render((i-1)*18+160-((18*player_ship->getLife())-2)/2, 9);
}

// Comprueba las colisiones
void check_bullets_colision() {
	for(int i = 0; i < MAX_WEAPON; i++) {
		if(colision(player_ship->getHitBox(), enemy_ship->getBulletHitBox(i))) {
			player_ship->makeDamage(); enemy_ship->killBullet(i);
		}
		if(colision(enemy_ship->getHitBox(), player_ship->getBulletHitBox(i))) {
			enemy_ship->makeDamage(); player_ship->killBullet(i);
		}
	}

	if(enemy_ship->isKilled() && enemy == true) { enemy_ship->reset(1); enemy = false; }
	else if(enemy_ship->isKilled() && enemy == false) { enemy_ship->reset(0); enemy = true; }
}

// Actualiza varios elementos del juego
void update_game() {
	player_ship->update();
	enemy_ship->update();
	check_bullets_colision();
}

// Renderiza elementos del juego
void render_game() {
	bgspace->render(0,0);
	show_stars();
	player_ship->render();
	enemy_ship->render();
	show_life();
}

// Corre el juego
void run_game() {
	update_game();
	render_game();
}
