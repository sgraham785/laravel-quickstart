.DEFAULT_GOAL :=

APP_NAME=laravel-test
DOCKER_REPO=257101242541.dkr.ecr.us-east-1.amazonaws.com/${APP_NAME}
AWS_REGION=us-east-1
TAG=latest

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


.PHONY: ecr-login push-image tag-image

publish: build-image tag-image ecr-login push-image ; $(info Image published...)

build-image: ecr-login ; $(info Building docker image...)
	docker build -f build/docker/Dockerfile -t $(APP_NAME):$(TAG) .

tag-image: ; $(info Tagging docker image...)
	docker tag $(APP_NAME):$(TAG) $(DOCKER_REPO):$(TAG)

push-image: ecr-login ; $(info Pushing docker image...)
	docker push $(DOCKER_REPO):$(TAG)

ecr-login: ; $(info Logging in to Amazon ECR...)
	$(shell AWS_PROFILE=upwork-sam-walker-sgraham aws ecr get-login --no-include-email --region $(AWS_REGION))
