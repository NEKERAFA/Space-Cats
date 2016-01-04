/*
	texture.cpp
	Creado por Rafael Alcalde Azpiazu (nekerafa@gmail.com) el jue 24 dic 2015 01:30

	Implementación de la clase textura para la implementación de texturas de SDL.

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
#include <SDL2/SDL_image.h>
#include <SDL2/SDL_ttf.h>
#include <string>
#include <iostream>
#include "../include/window.h"
#include "../include/texture.h"

// Constructor de la clase
texture::texture() {
	savetexture = NULL;
	path = NULL;
	width = 0; height = 0;
	realwidth = 0; realheight = 0;
	angle = 0.0;
	center.x = 0; center.y = 0;
	flip = SDL_FLIP_NONE;
}

// Destructor de la clase
texture::~texture() {
	if (savetexture != NULL) SDL_DestroyTexture(savetexture);
}

// Crea una textura desde una imagen
bool texture::load( std::string path ) {
	// Se elimina la textura anterior si existiese
	if (savetexture != NULL) SDL_DestroyTexture(savetexture);
	
	// Carga la imagen especifica
	SDL_Surface * imagesurface = IMG_Load(path.c_str());

	// Comprueba que se ha cargado
	if (imagesurface == NULL)
		std::cerr << "¡No se ha podido cargar la imagen '" << path.c_str() << "'!\nError: " << IMG_GetError() << "\n";
	// Comprueba que se ha convertido
	else if ((savetexture = SDL_CreateTextureFromSurface(SCREEN, imagesurface)) == NULL)
		std::cerr << "¡No se ha podido crear la textura de '" << path.c_str() << "'!\nError: " << SDL_GetError() << "\n";
	else {
		path = path.c_str();
		width = imagesurface->w; realwidth = width;
		height = imagesurface->h; realheight = height;
		std::cout << "'" << path.c_str() << "' cargada.\n";
	}
	SDL_FreeSurface(imagesurface);

	return savetexture != NULL;
}

// Crea una textura desde texto
bool texture::load( TTF_Font * font, std::string text, SDL_Color color ) {
	// Se elimina la textura anterior si existiese
	if (savetexture != NULL) SDL_DestroyTexture(savetexture);
	
	// Renderiza el texto especificado
	SDL_Surface * textsurface = TTF_RenderText_Blended(font, text.c_str(), color);

	// Comprueba que se ha creado
	if (textsurface == NULL)
		std::cerr << "¡No se ha podido renderizar el texto '" << text.c_str() << "'!\nError: " << TTF_GetError() << "\n";
	// Comprueba que se ha convertido
	else if ((savetexture = SDL_CreateTextureFromSurface(SCREEN, textsurface)) == NULL)
		std::cerr << "¡No se ha podido crear la textura del texto renderizado!\nError: " << SDL_GetError() << "\n";
	else {
		width = textsurface->w; realwidth = width;
		height = textsurface->h; realheight = height;
	}
	SDL_FreeSurface(textsurface);

	return savetexture != NULL;
}
// Cambia los colores
void texture::setColor( SDL_Color color ) {
	if (savetexture != NULL) {
		SDL_SetTextureColorMod(savetexture, color.r, color.g, color.b);
		SDL_SetTextureAlphaMod(savetexture, color.a);
	}
}

// Cambia la trasparencia
void texture::setAlpha( unsigned char a ) {
	if (savetexture != NULL) SDL_SetTextureAlphaMod(savetexture, a);
}

// Rota la imagen
void texture::rotate(double angle) { this->angle = angle; }

// Voltea la imagen
void texture::setFlip( SDL_RendererFlip flip ) { this->flip = flip; }

// Posiciona el centro de la imagen
void texture::setCenter(int x, int y){
	center.x = x; center.y = y;
}

// Obtiene las dimensiones de la imagen
int texture::getWidth() { return width; }
int texture::getHeight() { return height; }

// Obtiene las dimensiones reales
int texture::getRealWidth() { return realwidth; }
int texture::getRealHeight() { return realheight; }

// Redimensiona una imagen
void texture::resize( int width, int height )	{
	this->width = width; this->height = height;
}
// Escala la imagen proporcionalmente
void texture::scale( double percentage )	{
	this->width = (int) percentage*realwidth;
	this->height = (int) percentage*realheight;
}

// Renderiza la textura en una posición
void texture::render( int x, int y ) {
	SDL_Rect renderRect = {x, y, width, height};
	SDL_RenderCopyEx(SCREEN, savetexture, NULL, &renderRect, angle, &center, flip);
}

// Renderiza parte de la imagen
void texture::render( int x, int y, int x_pos, int y_pos, int width, int height )	{
	SDL_Rect renderRect = {x, y, width*this->width/this->realwidth, height*this->height/this->realheight};
	SDL_Rect clip = {x_pos, y_pos, width, height};
	SDL_RenderCopyEx(SCREEN, savetexture, &clip, &renderRect, angle, &center, flip);
}

// Reinicia las modificaciones hechas
void texture::reset() {
	width = realwidth; height = realheight;
	angle = 0.0;
	center.x = 0; center.y = 0;
	flip = SDL_FLIP_NONE;
}
