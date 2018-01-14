all: love

compile:
	./compile.sh

love: compile
	./package-love.sh

deb: love
	./package-deb.sh

win: love
	./package-win.sh

mac: love
	./package-mac.sh

clean:
	find . -type f -name '*~' -exec rm -v {} +
	rm -rfv build/bytecode
	rm -rfv build/love
	rm -fv build/SpaceCats.love
	rm -fv build/SpaceCats.deb
	rm -fv build/SpaceCats-MacOS.zip
	rm -fv build/win32/SpaceCats.love
	rm -fv build/win32/SpaceCats.exe
	rm -fv build/debian/usr/games/SpaceCats.love
