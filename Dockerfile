# @version 1.2.0
# Configures PHP-FPM.

FROM php:fpm-alpine
LABEL maintainer="marcosfreitas@c4network.com.br"

ARG APP_ENVIROMENT

# performance boosting env substitution
ARG PHP_PM=dynamic
ARG PHP_PM_MAX_CHILDREN=40
ARG PHP_PM_START_SERVERS=8
ARG PHP_PM_MIN_SPARE_SERVERS=2
ARG PHP_PM_MAX_SPARE_SERVERS=10
ARG PHP_PM_MAX_REQUESTS=50
ARG PHP_PM_IDLE_TIMEOUT=10s
ARG PHP_PM_REQUEST_TERMINATE_TIMEOUT=60s
ARG PHP_PM_RESPONSE_TERMINATE_TIMEOUT=120s

RUN sed -i "s/pm = dynamic/pm = ${PHP_PM}/" /usr/local/etc/php-fpm.d/www.conf \
    && sed -i "s/pm.max_children = 5/pm.max_children = ${PHP_PM_MAX_CHILDREN}/" /usr/local/etc/php-fpm.d/www.conf \
    && sed -i "s/pm.start_servers = 2/pm.start_servers = ${PHP_PM_START_SERVERS}/" /usr/local/etc/php-fpm.d/www.conf \
    && sed -i "s/pm.min_spare_servers = 1/pm.min_spare_servers = ${PHP_PM_MIN_SPARE_SERVERS}/" /usr/local/etc/php-fpm.d/www.conf \
    && sed -i "s/pm.max_spare_servers = 3/pm.max_spare_servers = ${PHP_PM_MAX_SPARE_SERVERS}/" /usr/local/etc/php-fpm.d/www.conf \
    && sed -i "s/;pm.max_requests = 500/pm.max_requests = ${PHP_PM_MAX_REQUESTS}/" /usr/local/etc/php-fpm.d/www.conf \
    && sed -i "s/;pm.process_idle_timeout = 10s/pm.process_idle_timeout = ${PHP_PM_IDLE_TIMEOUT}/" /usr/local/etc/php-fpm.d/www.conf \
    && sed -i "s/;pm.request_terminate_timeout = 0/pm.request_terminate_timeout = ${PHP_PM_REQUEST_TERMINATE_TIMEOUT}/" /usr/local/etc/php-fpm.d/www.conf \
    && sed -i "s/;pm.response_terminate_timeout = 0/pm.response_terminate_timeout = ${PHP_PM_RESPONSE_TERMINATE_TIMEOUT}/" /usr/local/etc/php-fpm.d/www.conf \
    && sed -i "s/;slowlog = log\/$pool.log.slow/slowlog = log\/$pool.log.slow/" /usr/local/etc/php-fpm.d/www.conf \
    && sed -i "s/;catch_workers_output = yes/catch_workers_output = yes/" /usr/local/etc/php-fpm.d/www.conf

EXPOSE 9000

# Added script to easy install PHP extensions

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/bin/

# @info fix permissions
# Use the default production configuration
RUN apk update \
    && apk add --no-cache shadow bash composer \
    && composer self-update --2 \
    && usermod -u 1000 www-data \
    && mv "$PHP_INI_DIR/php.ini-$APP_ENVIROMENT" "$PHP_INI_DIR/php.ini" \
    && install-php-extensions mysqli pdo_mysql bcmath gd imagick \
    && php-fpm -m

# @todo implement dynamic entrypoint
ENTRYPOINT [ "php-fpm" ]