/*
	bullet.h
	Creado por Rafael Alcalde Azpiazu (nekerafa@gmail.com) el sáb 26 dic 2015 15:35:59 (CET)

	Cabecera la clase bala.

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

#ifndef   _BULLET_CLASS_
#define   _BULLET_CLASS_

#include <SDL2/SDL.h>
#include "texture.h"

// Clase bala
class bullet {
private:
	int x; int y;
	int vel_x; int vel_y;
	texture * img_bullet;
	bool dead;

public:
	// Crea una bala
	bullet( texture * img_bullet );
	// Inicializa la bala
	void create( int x, int y, int vel_x, int vel_y );
	// Muestra la bala
	void show();
	// Obtiene las posiciones de la bala
	int getX(); int getY();
	// Mata la bala
	void kill();
	// Mira si la bala ha muerto
	bool isDead();
	// Obtiene la hit box de la bala
	SDL_Rect getHitBox();
};

#endif // _BULLET_CLASS_
