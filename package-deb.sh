#!/bin/bash
cd build

# Clearing rubbish files
rm -rfv *~

# Copy files to binary package
echo -e "\n\033[1;32mCopying sources...\033[0m"
cp -Rv SpaceCats.love debian/usr/games/

# Create love compile
echo -e "\n\033[1;32mCreating Debian distribution...\033[0m"
dpkg-deb -d SpaceCats

echo -e "\nDONE"
