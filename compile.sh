#!/bin/bash
# Create build/bytecode directory
if [ -d build/bytecode ]; then
	echo -e "\033[1;32mRemove old build...\033[0m"
	rm -rfv build/bytecode
fi

# Create build
mkdir -v build/bytecode

# Copy source to build directory
echo -e "\n\033[1;32mCopying sources...\033[0m"
cp -Rv src/main build/bytecode
cp -v conf.lua build/bytecode
cp -v main.lua build/bytecode

# Move to source code
cd build/bytecode
rm -r main/levels # Levels will do errors, so I don't compile it

# Compile source code
echo -e "\n\033[1;32mCompiling sources...\033[0m"
for file in $(find . -iname "*.lua") ; do
	echo -e "Compiling ${file}"
	luajit -b ${file} ${file}
	chmod +x ${file}
done

echo -e "\nDONE"
