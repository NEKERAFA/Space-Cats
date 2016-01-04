/*
	timer.h
	Creado por Rafael Alcalde Azpiazu (nekerafa@gmail.com) el dom 30 ago 2015 14:55:30 (CEST) 

	Cabecera la clase timer para la implementación de temporizadores en SDL.

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

#ifndef   _TIMER_CLASS_
#define   _TIMER_CLASS_

class timer {
private:
	// Tiempo inicial
	Uint32 start_time;
	// Tiempo cuando fue parados
	Uint32 stop_time;
	bool running;
public:
	// Inicializa las variables
	timer();
	// Inicia un temporizador
	void start();
	// Detiene un temporizador
	void stop();
	// Reinicia un temporizador
	void reset();
	// Obtiene el tiempo del temporizador
	Uint32 time();
};

#endif // _TEXTURE_CLASS_
