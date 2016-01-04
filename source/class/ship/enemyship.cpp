/*
	enemyship.cpp
	Creado por Rafael Alcalde Azpiazu (nekerafa@gmail.com) el jue 31 dic 2015 03:21:33 (CET)

	Cuerpo de la clase nave enemiga.

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

#include <SDL2/SDL.h>
#include "../../include/ship/ship.hpp"
#include "../../include/ship/enemyship.hpp"

// Crea una nave
enemyship::enemyship(int life, int burst) : ship(0, 0, life), burst (burst) {
	shootburst = new timer();
}

enemyship::~enemyship() { delete shootburst; }

// Reinicia la información de la nave
void enemyship::reset(int life, int burst) {
	ship::reset(0, 0, life);
	this->burst = burst; shootburst->reset();
}
