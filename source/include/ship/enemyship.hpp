/*
	enemyship.hpp
	Creado por Rafael Alcalde Azpiazu (nekerafa@gmail.com) el jue 31 dic 2015 03:05:20 (CET)

	Cabecera de la clase nave enemiga.

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

#ifndef   _ENEMYSHIP_CLASS_
#define   _ENEMYSHIP_CLASS_

#include <SDL2/SDL.h>
#include "./ship.hpp"
#include "./../timer.h"

class enemyship : public ship {
protected:
	int burst;
	timer * shootburst;
public:
	// Crea una nave
	enemyship(int life, int burst);
	// Destruye la nave
	~enemyship() =0;
	// Reinicia la información de la nave
	void reset(int life, int burst);
};

#endif // _ENEMYSHIP_CLASS_
