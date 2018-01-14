#!/bin/bash
cd build

# Clearing rubbish files
rm -rfv *~

# Copy files to binary package
echo -e "\n\033[1;32mCopying sources...\033[0m"
cp -Rv SpaceCats.love win32

# Create love compile
echo -e "\n\033[1;32mCreating Windows distribution...\033[0m"
cd win32
cat love.exe SpaceCats.love > SpaceCats.exe
rm -f SpaceCats.love
zip -9 -rv ../SpaceCats-Win32.zip .

echo -e "\nDONE"
