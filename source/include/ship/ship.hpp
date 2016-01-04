/*
	ship.hpp
	Creado por Rafael Alcalde Azpiazu (nekerafa@gmail.com) el jue 24 dic 2015 19:32:27 CET 

	Cabecera de la clase nave.

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

#ifndef   _SHIP_CLASS_
#define   _SHIP_CLASS_

#include <SDL2/SDL.h>
#include <SDL2/SDL_image.h>
#include <SDL2/SDL_ttf.h>
#include <string>
#include "./../texture.h"
#include "./../timer.h"
#include "./../weapon.h"

class ship {
protected:
	int x; int y;
	int life;
	weapon * weaponship;
	texture * textureship;
	texture * textureboost;
	texture * textureboom;
	timer * timerboost;
	timer * timerboom;
	int frameboost;
	int frameboom;
	bool kill;

public:
	// Crea una nueva nave
	ship(int x, int y, int life);
	// Borra la nave
	virtual ~ship();
	// Obtiene la posición de la nave
	int getX(); int getY();
	// Obtiene la vida
	int getLife();
	// Elimina una vida
	void makeDamage();
	// Reinicia la información de la nave
	void reset(int x, int y, int life);
	// Actualiza los elementos internos
	virtual void update() =0;
	// Renderiza la nave
	virtual void render() =0;
	// Mueve la nave
	virtual void move() =0;
	// Obtiene la hit box de la nave
	SDL_Rect virtual getHitBox() =0;
	// Obtiene la hitbox de una bala
	SDL_Rect getBulletHitBox(int i);
	// Destruye una bala
	void killBullet(int i);
	// Devuelve el estado de la nave
	bool isKilled();
};

#endif // _SHIP_CLASS_
