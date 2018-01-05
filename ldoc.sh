#!/bin/bash
rm -rfv docs/ldoc
mv lib ../lib
ldoc -d docs/ldoc -v -f markdown -p 'Space Cats' ./
mv ../lib lib
