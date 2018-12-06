FROM 257101242541.dkr.ecr.us-east-1.amazonaws.com/alpine-fpm-php:7.2

WORKDIR /var/www
COPY . .
RUN composer install && php artisan key:generate
