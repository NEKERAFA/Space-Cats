![Banner](itch/banner.png "Spaces Cats")

![Powered by Lua](icons/lua.png "Powered by Lua") ![Made with Löve 0.10.2](icons/löve.png "Made with Löve 0.10.2")

Space Cats es un videojuego Shoot'em Up espacial en un universo de fantasías con animales antropomorfos.

Información del proyecto
--------------------------------------------------------------------------------
En cada carpeta se encuentra un archivo README.md que describe información del
contenido de cada carpeta, pero aquí hay un breve resumen de como se organiza
el proyecto.

![Diagrama de carpetas](docs/diagrams/folders.png "Carpetas del proyecto")

### Creación de archivos de distribución
Se recomienda usar bash para crear los compilados y binarios de LÖVE debido a
que existe un makefile que está configurado con los siguientes comandos:
* ```make compile``` : compila el código fuente en bytecode para la máquina
virtual de Lua. El código resultante está en la carpeta build/bytecode.

* ```make love``` : con el código compilado, añade las bibliotecas y assets en
un comprimido para poder ser ejecutado mediante LÖVE. El comprimido es
build/SpaceCats.love, y los archivos incluidos están en la carpeta build/love.

* ```make deb``` : con el ejecutable de LÖVE, crea un instalador de SpaceCats
para Debian y distros basadas en Debian, como Ubuntu, Linux Mint o Mate. El
ejecutable es build/SpaceCats.deb, que se puede instalar con GDebi o por
terminal como:
```
$ dpkg -i build/SpaceCats.deb
```

* ```make win``` : con el ejecutable de LÖVE, añade este al ejecutable de LÖVE
creando el ejecutable SpaceCats.exe y crea un comprimido. Los archivos para
Windows (32 bits) están en build/win32, y el archivo resultante está en
build/SpaceCats-Win32.zip. Este es el paso previo para crear el instalador
mediante Inno Setup.

* ```make mac``` : con el ejecutable de LÖVE, crea un instalable de SpaceCats
para MacOS. Este instalador es build/SpaceCats-MacOS.zip

### Lista de tareas
Se puede encontrar esta lista en la pestaña Projects/Development en el repositorio de GitHub, aún así hago un resumen pensándolo en orden cronológico:

+ Acabar el editor de niveles.

+ (en paralelo) Añadir el soporte con mando.

+ (en paralelo) Redactar la historia principal.

+ Empezar a implementar la historia principal.

 + Empaquetar la siguiente versión.

+ *En revisión*

Versiones
--------------------------------------------------------------------------------

### BETA 0.2 (1.1-demo)
Se ha reorganizado la carpeta de librerías para mantenerlas estáticas.
Se crea e implementa el editor de niveles.

### BETA 0.1 (1.0-demo)
Primera release de Space Cats publicada con las mecánicas acabadas, forma parte
de primera versión demo.

### ALPHAKA 0.9
Se ha limpiado el código y algunos assets para una mejor organización.

### ALPHAKA 0.8
Las mecánicas están acabadas, solo falta pulirlas y pronto maquetaré una demo
jugable.

### ALPHAKA 0.6
Se ha portado el juego de C++ a Löve, ya que me es más fácil programar en este
lenguaje debido a lo muy especializado que estoy con el, por lo que a partir de
ahora se desarrollará en este lenguaje.

### ALPHAKA 0.5
He añadido los archivos base de una prueba de concepto. Esta casi todo
operativo y funcional.
Se necesita actualmente tener instalados SDL2, SDL2_Image y SDL2_tff.

Licencia
--------------------------------------------------------------------------------
> GNU LESSER GENERAL PUBLIC LICENSE 3.0
>
> Version 3, 29 June 2007
>
>Copyright (C) 2007 Free Software Foundation, Inc. <http://fsf.org/>
>
>Everyone is permitted to copy and distribute verbatim copies
>of this license document, but changing it is not allowed.
>
>
>This version of the GNU Lesser General Public License incorporates
>the terms and conditions of version 3 of the GNU General Public
>License, supplemented by the additional permissions listed in LICENSE file.
