testTerminal:
	cd src/ui/tty && lua ./line_test.lua

testChar:
	cd src/action/ && lua ./char_test.lua

testAll:
	cd tests/ && lua ./all.lua
