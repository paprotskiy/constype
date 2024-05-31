autotests:
	cd src/tests/ && lua ./all.lua

seedDb:
	docker compose up --build seeder

unittests:
	docker compose up --build constype-unit-tests

fonttests:
	docker compose up --build constype-test-fonts

launch:
	docker compose up --build --no-start constype && docker compose run constype
