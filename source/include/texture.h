/*
   texture.h
   Creado por Rafael Alcalde Azpiazu (nekerafa@gmail.com) el jue 24 dic 2015 01:05

   Clase textura para la implementación de texturas de SDL.

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

#ifndef   _TEXTURE_CLASS_
#define   _TEXTURE_CLASS_

#include <SDL2/SDL.h>
#include <SDL2/SDL_image.h>
#include <SDL2/SDL_ttf.h>
#include <string>

class texture {
private:
   // Textura actual
   SDL_Texture * savetexture;
   // Ruta de la textura
   char * path;
   // Tamaño actual
   int width, height;
   // Tamaño real
   int realwidth, realheight;
   // Ángulo
   double angle;
   // Centro de la imagen
   SDL_Point center;
   // Volteo
   SDL_RendererFlip flip;

public:
   // Constructor de la clase
   texture();
   // Destructor de la clase
   ~texture();
   // Crea una textura desde una imagen
   bool load( std::string path );
   // Crea una textura desde texto
   bool load( TTF_Font * font, std::string text, SDL_Color color );
   // Cambia los colores
   void setColor( SDL_Color color );
   // Cambia la trasparencia
   void setAlpha( unsigned char a );
   // Rota la imagen
   void rotate( double angle );
   // Voltea la imagen
   void setFlip( SDL_RendererFlip flip );
   // Posiciona el centro de la imagen
   void setCenter( int x, int y );
   // Obtiene las dimensiones de la imagen
   int getWidth();
   int getHeight();
   // Obtiene las dimensiones reales
   int getRealWidth();
   int getRealHeight();
   // Redimensiona una imagen
   void resize( int width, int height );
   // Escala la imagen proporcionalmente
   void scale( double percentage );
   // Renderiza la textura en una posición
   void render( int x, int y );
   // Renderiza parte de la imagen
   void render( int x, int y, int x_pos, int y_pos, int width, int height );
   // Reinicia las modificaciones hechas
   void reset();
};

#endif // _TEXTURE_CLASS_
