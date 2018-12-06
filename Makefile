.DEFAULT_GOAL :=

dep:
	composer install

build: dep
  php artisan key:generate

migrate:
	docker-compose run --rm app php artisan migrate

serve:
	php artisan serve

test:
	./vendor/bin/phpunit

