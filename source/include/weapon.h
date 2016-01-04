/*
	weapon.h
	Creado por Rafael Alcalde Azpiazu (nekerafa@gmail.com) el dom 27 dic 2015 04:32:54 (CET)

	Cabecera de la clase arma.

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

#ifndef   _WEAPON_CLASS_
#define   _WEAPON_CLASS_

#include <SDL2/SDL.h>
#include "texture.h"
#include "bullet.h"
#include "timer.h"

#define MAX_WEAPON 32

class weapon {
private:
	bullet * obj_bullet[MAX_WEAPON];
	timer * shoot_bullet;
	int count_bullet;
	Uint32 time;

public:
	// Crea un arma
	weapon(texture * img_bullet, Uint32 time);
	// Destruye un arma
	~weapon();
	// Muestra las balas
	void render();
	// Dispara una bala
	void shoot(int x, int y, int vel);
	// Destruye una bala
	void kill(int i);
	// Obtiene el numero de balas disparadas
	int shotBullets();
	// Obtiene la hitbox de una bala
	SDL_Rect getHitBox(int i);
};

#endif // _WEAPON_CLASS_
