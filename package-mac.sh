#!/bin/bash
./package-love.sh

cd build

# Clearing rubbish files
rm -rfv *~

# Copy files to binary package
echo -e "\n\033[1;32mCopying sources...\033[0m"
cp -Rv SpaceCats.love SpaceCats.app/Contents/Resources

# Create love compile
echo -e "\n\033[1;32mCreating mac distribution...\033[0m"
cd SpaceCats.app
zip -9 -y -ll -rv ../SpaceCats.zip .

echo -e "\nDONE"
