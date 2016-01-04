#	Space Cats MAKEFILE
#	Creado por Rafael Alcalde Azpiauzu (nekerafa@gmail.com) el jue 24 dic 2015 18:57:07 CET 
#
#	Space Cats is free software: you can redistribute it and/or modify
#	it under the terms of the GNU General Public License as published by
#	the Free Software Foundation, either version 3 of the License, or
#	(at your option) any later version.
#
#	Space cat is distributed in the hope that it will be useful,
#	but WITHOUT ANY WARRANTY; without even the implied warranty of
#	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#	GNU General Public License for more details.
#
#	You should have received a copy of the GNU General Public License
#	along with Foobar.  If not, see <http://www.gnu.org/licenses/>.

# COMPILERS
CCplusplus = g++
#CCpluspus = x86_64-w64-mingw32-g++
CFLAGS = -O0 -g -Wall -std=c++11
# OBJS
O_DIR = objs
OBJS = $(O_DIR)/app.o $(O_DIR)/texture.o $(O_DIR)/timer.o $(O_DIR)/star.o \
$(O_DIR)/ship.o $(O_DIR)/playership.o $(O_DIR)/enemyship.o \
$(O_DIR)/smouse_ship.o \
$(O_DIR)/game.o $(O_DIR)/utils.o \
$(O_DIR)/bullet.o $(O_DIR)/weapon.o
# HEADERS
H_DIR = include
H_SHIP_DIR = include/ship
# CLASSES
C_DIR = class
C_SHIP_DIR = class/ship
# LINKERS FLAGS
LFLAGS = -lSDL2 -lSDL2_image -lSDL2_ttf -lSDL2_mixer
#LFLAGS = -static-libgcc -static-libstdc++ -lmingw32 -lSDL2main -lSDL2 -lSDL2_image -lSDL2_ttf -lSDL2_mixer -mwindows
OBJ_NAME = Space_Cats
EXTENSION = out

all : $(OBJ_NAME)

$(OBJ_NAME) : $(OBJS) main.cpp
	$(CCplusplus) $(CFLAGS) $(OBJS) main.cpp $(LFLAGS) -o $(OBJ_NAME).$(EXTENSION)

$(O_DIR)/app.o : $(H_DIR)/app.h app.cpp
	$(CCplusplus) -c $(CFLAGS) app.cpp $(LFLAGS) -o $(O_DIR)/app.o

$(O_DIR)/texture.o : $(H_DIR)/texture.h $(C_DIR)/texture.cpp
	$(CCplusplus) -c $(CFLAGS) $(C_DIR)/texture.cpp $(LFLAGS) -o $(O_DIR)/texture.o

$(O_DIR)/timer.o : $(H_DIR)/timer.h $(C_DIR)/timer.cpp
	$(CCplusplus) -c $(CFLAGS) $(C_DIR)/timer.cpp $(LFLAGS) -o $(O_DIR)/timer.o

$(O_DIR)/ship.o : $(H_SHIP_DIR)/ship.hpp $(C_SHIP_DIR)/ship.cpp
	$(CCplusplus) -c $(CFLAGS) $(C_SHIP_DIR)/ship.cpp $(LFLAGS) -o $(O_DIR)/ship.o

$(O_DIR)/playership.o : $(H_SHIP_DIR)/playership.hpp $(C_SHIP_DIR)/playership.cpp
	$(CCplusplus) -c $(CFLAGS) $(C_SHIP_DIR)/playership.cpp $(LFLAGS) -o $(O_DIR)/playership.o

$(O_DIR)/enemyship.o : $(H_SHIP_DIR)/enemyship.hpp $(C_SHIP_DIR)/enemyship.cpp
	$(CCplusplus) -c $(CFLAGS) $(C_SHIP_DIR)/enemyship.cpp $(LFLAGS) -o $(O_DIR)/enemyship.o
	
$(O_DIR)/smouse_ship.o : $(H_SHIP_DIR)/smouse_ship.hpp $(C_SHIP_DIR)/smouse_ship.cpp
	$(CCplusplus) -c $(CFLAGS) $(C_SHIP_DIR)/smouse_ship.cpp $(LFLAGS) -o $(O_DIR)/smouse_ship.o

$(O_DIR)/bullet.o : $(H_DIR)/bullet.h $(C_DIR)/bullet.cpp
	$(CCplusplus) -c $(CFLAGS) $(C_DIR)/bullet.cpp $(LFLAGS) -o $(O_DIR)/bullet.o

$(O_DIR)/weapon.o : $(H_DIR)/weapon.h $(C_DIR)/weapon.cpp
	$(CCplusplus) -c $(CFLAGS) $(C_DIR)/weapon.cpp $(LFLAGS) -o $(O_DIR)/weapon.o

$(O_DIR)/game.o : $(H_DIR)/game.h game.cpp
	$(CCplusplus) -c $(CFLAGS) game.cpp $(LFLAGS) -o $(O_DIR)/game.o
	
$(O_DIR)/star.o : $(H_DIR)/star.h $(C_DIR)/star.cpp
	$(CCplusplus) -c $(CFLAGS) $(C_DIR)/star.cpp $(LFLAGS) -o $(O_DIR)/star.o

$(O_DIR)/utils.o : utils.cpp
	$(CCplusplus) -c $(CFLAGS) utils.cpp $(LFLAGS) -o $(O_DIR)/utils.o
