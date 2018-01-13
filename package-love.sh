#!/bin/bash
# Compile
sh ./compile.sh

# Create love directory
if [ -d build/love ]; then
	echo -e "\033[1;32mRemove old build...\033[0m"
	rm -rfv build/love
fi

# Copy files to binary package
mkdir -pv build/love

# Copy source to build directory
echo -e "\n\033[1;32mCopying sources...\033[0m"
mkdir -pv build/love/src/
cp -Rv build/bytecode/main build/love/src/main
cp -v build/bytecode/conf.lua build/love/
cp -v build/bytecode/main.lua build/love/

cp -Rv lang build/love
cp -Rv lib build/love
cp -Rv src/assets build/love/src/assets
cp -Rv src/main/levels build/love/src/main/levels

# Create love compile
echo -e "\n\033[1;32mCreating love...\033[0m"
cd build/love
find . -type f -name '*.md' -exec rm -v {} +
zip -9 -rv ../SpaceCats.love .

echo -e "\nDONE"
