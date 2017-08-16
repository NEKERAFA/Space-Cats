#!/bin/sh
# Compile
sh ./compile.sh

# Create love directory
if [ -d binary/spacecats_1.0-demo-love ]; then
	echo "Remove old build..."
	rm -rf binary/spacecats_1.0-demo-love
fi


# Copy files to binary package
mkdir -pv binary/spacecats_1.0-demo-love/src

# Copy source to build directory
echo "Copying sources..."
cp -Rv build/main binary/spacecats_1.0-demo-love/src
cp -v build/conf.lua binary/spacecats_1.0-demo-love/
cp -v build/main.lua binary/spacecats_1.0-demo-love/

cp -Rv lang binary/spacecats_1.0-demo-love/
cp -Rv lib binary/spacecats_1.0-demo-love/
cp -Rv src/assets binary/spacecats_1.0-demo-love/src/assets
cp -Rv src/main/levels binary/spacecats_1.0-demo-love/src/main/levels
cp -v icon.png binary/spacecats_1.0-demo-love/

cd binary/spacecats_1.0-demo-love/
zip -9 -r ../spacecats_1.0-demo.love .
