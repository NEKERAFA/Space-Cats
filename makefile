all: love

compile:
	./compile.sh

love:
	./package-love.sh

deb:
	./package-deb.sh

win:
	./package-win.sh

mac:
	./package-mac.sh

clean:
	rm -rfv build/bytecode
	rm -rfv build/love
	rm -fv build/SpaceCats.love
	rm -fv build/SpaceCats.deb
	rm -fv build/win32/SpaceCats.exe
