/*
	weapon.cpp
	Creado por Rafael Alcalde Azpiazu (nekerafa@gmail.com) el dom 27 dic 2015 04:32:54 (CET)

	Constructor de la clase arma.

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
#include "../include/texture.h"
#include "../include/bullet.h"
#include "../include/timer.h"
#include "../include/weapon.h"

int next_bullet(int i) { ++i; if (i==MAX_WEAPON) i=0; return i; }

// Crea un arma
weapon::weapon(texture * img_bullet, Uint32 time) {
	this->time = time;
	shoot_bullet = new timer;
	shoot_bullet->start();
	count_bullet = -1;
	
	for(int n = 0; n < MAX_WEAPON; ++n) obj_bullet[n] = new bullet(img_bullet);
}

// Destruye un arma
weapon::~weapon() {
	for(int n = 0; n < MAX_WEAPON; ++n) delete obj_bullet[n];
	delete shoot_bullet;
}

// Muestra las balas
void weapon::render() {
	if (count_bullet != -1)
		for(int n = 0; n < MAX_WEAPON; ++n) obj_bullet[n]->show();
}

// Destruye una bala
void weapon::kill(int i) { obj_bullet[i]->kill(); }

// Dispara una bala
void weapon::shoot(int x, int y, int vel) {
	if (time < shoot_bullet->time()) {
		count_bullet = next_bullet(count_bullet);
		obj_bullet[count_bullet]->create(x, y, vel, 0);
		shoot_bullet->reset(); shoot_bullet->start();
	}
}

// Obtiene el numero de balas disparadas
int weapon::shotBullets() {
	int bullets = 0;
	for(int n = 0; n < MAX_WEAPON; ++n) if (!obj_bullet[n]->isDead()) ++bullets;
	return bullets;
}

// Obtiene la hitbox de una bala
SDL_Rect weapon::getHitBox(int i) {
	return obj_bullet[i]->getHitBox();
}
