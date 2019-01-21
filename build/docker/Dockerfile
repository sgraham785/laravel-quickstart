FROM 257101242541.dkr.ecr.us-east-1.amazonaws.com/alpine-fpm-php:7.2

WORKDIR /var/www
COPY . .
RUN composer install && php artisan key:generate
ENV DB_CONNECTION=sqlite
ENV DB_DATABASE=/database/database.sqlite

RUN php artisan migrate

CMD [ "php", "artisan", "serve", "--host=0.0.0.0", "--port=8000" ]
