.PHONY: build create up run exec refresh ssg

build:
	@docker compose build

create:
	@docker run --rm -it -v $PWD:/app -w /app node:18 yarn create astro
	@sudo chown -R toshi:toshi ./
	@docker compose run --rm blog yarn install

up:
	@sudo chown -R toshi:toshi ./
	@docker compose up -d

run:
	@docker compose run -p 3000:3000 blog bash

refresh:
	@sudo chown -R toshi:toshi ./
	@docker compose stop
	@docker compose start

del:
	@docker compose down -v

exec:
	@sudo chown -R toshi:toshi ./
	@docker exec -it blog bash
