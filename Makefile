autotests:
	cd src/tests/ && lua ./all.lua

testTerminal:
	cd src/tests/ && lua ./line_test.lua

unittests:
	docker-compose up --build constype-unit-tests

fonttests:
	docker-compose up --build constype-test-fonts

launch:
	docker-compose up --build --no-start constype && docker-compose run constype
