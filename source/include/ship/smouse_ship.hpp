/*
	smouse_ship.hpp
	Creado por Rafael Alcalde Azpiazu (nekerafa@gmail.com) el dom 03 ene 2015 14:39:07 (CET)

	Cabecera de la clase constructora de nave pequeña ratón.

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

#ifndef   _SMALLMOUSE_SHIP_CLASS_
#define   _SMALLMOUSE_SHIP_CLASS_

#include <SDL2/SDL.h>
#include <SDL2/SDL_image.h>
#include <SDL2/SDL_ttf.h>
#include "./ship.hpp"
#include "./enemyship.hpp"
#include "./playership.hpp"

class smouse_ship : public enemyship {
private:
	int status;
	int type;
public:
	// Crea una nave
	smouse_ship(int type);
	// Destruye la nave
	~smouse_ship();
	// Elimina una vida
	void makeDamage();
	// Reinicia la información de la nave
	void reset(int type);
	// Actualiza los elementos internos
	void update();
	// Renderiza la nave
	void render();
	// Mueve la nave
	void move();
	// Mueve la nave
	void move(playership * player_ship);
	// Obtiene la hit box de la nave
	SDL_Rect getHitBox();
};

#endif // _SMALLMOUSE_SHIP_CLASS_
