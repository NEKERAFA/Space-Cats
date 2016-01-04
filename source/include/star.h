/*
	star.h
	Creado por Rafael Alcalde Azpiazu (nekerafa@gmail.com) el dom 30 ago 2015 14:55:00 (CEST)
	Cabecera la clase star.

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

#ifndef _STAR_H_
#define _STAR_H_

class star {
public:
	// Inicializa las variables
	star();
	// Crea una estrella
	void create(int new_x, int new_y);
	// Pone una velocidad
	void set_velocity(int new_x_vel, int new_y_vel);
	// La imprime mostrando un color
	void render( SDL_Color color );
	// Devuelve las posiciones de las estrellas
	int getx();
	int gety();	

private:
	// Posición actual
	int x; int y;
	// Velocidad
	int vel_x; int vel_y;
};

#endif /* _STAR_H_ */
