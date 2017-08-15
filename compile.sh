#!/bin/sh
# Create build directory
if [ -d build ]; then
	echo "Remove old build"
	rm -rf build
fi

# Create build
mkdir -v build

# Copy source to build directory
echo "Copying sources..."
cp -Rv src/main build

# Move to source code
cd build
rm -r main/levels # Levels will do errors, so I don't compile it

# Compile source code
echo "Compiling sources..."
for file in $(find . -iname "*.lua") ; do
	echo "Compiling ${file}"
	luajit -b ${file} ${file}
done
echo "Done"
