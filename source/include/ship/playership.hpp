/*
	playership.hpp
	Creado por Rafael Alcalde Azpiazu (nekerafa@gmail.com) el vie 25 dic 2015 00:39:21 (CET)

	Cabecera de la clase nave del jugador.

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


#ifndef   _PLAYERSHIP_CLASS_
#define   _PLAYERSHIP_CLASS_

#include <SDL2/SDL.h>
#include "./ship.hpp"
#include "../timer.h"

class playership : public ship {
private:
	timer * invulnerabity;
public:
	// Crea una nave
	playership(int x, int y, int life);
	// Destruye la nave
	~playership();
	// Elimina una vida
	void makeDamage();
	// Actualiza los elementos internos
	void update();
	// Renderiza la nave
	void render();
	// Mueve la nave
	void move();
	// Obtiene la hit box de la nave
	SDL_Rect getHitBox();
};

#endif // _PLAYERSHIP_CLASS_
