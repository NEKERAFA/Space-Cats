#!/bin/bash
./package-love.sh

cd build

# Clearing rubbish files
rm -rfv *~

# Copy files to binary package
echo -e "\n\033[1;32mCopying sources...\033[0m"
cp -Rv SpaceCats.love win32

# Create love compile
echo -e "\n\033[1;32mCreating exe...\033[0m"
cd win32
cat love.exe SpaceCats.love > SpaceCats.exe

echo -e "\nDONE"
