/*
   window.h
   Creado por Rafael Alcalde Azpiazu (nekerafa@gmail.com) el jue 24 dic 2015 02:45

   Cabeceras globales de la ventana.

   Space Cats is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   Space Cats is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
   GNU General Public License for more details in
   <http://www.gnu.org/licenses/>.
*/

#include <SDL2/SDL.h>

extern SDL_Window   * WINDOW;
extern SDL_Renderer * SCREEN;
extern SDL_Event      EVENTS;

extern int  SCREEN_WIDTH;
extern int  SCREEN_HEIGHT;
extern float SCREEN_SCALE;
extern bool WINDOW_MINIMIZED;
