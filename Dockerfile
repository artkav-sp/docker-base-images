FROM composer/composer:2.8.3-bin AS composer-image

FROM php:8.4-fpm-alpine3.21 AS base

LABEL maintainer="Spendy Development Team"
LABEL description="Base PHP 8.4-FPM image with extensions for Laravel applications"

RUN apk add --no-cache --virtual .build-dependencies \
    $PHPIZE_DEPS \
    autoconf \
    g++ \
    make \
    build-base \
    linux-headers

RUN apk add --no-cache \
    bash \
    curl \
    git \
    zip \
    unzip \
    icu-dev \
    libzip-dev \
    zlib-dev \
    libpq-dev \
    oniguruma-dev \
    libsodium-dev \
    openssl-dev \
    gettext-dev \
    libpng \
    libpng-dev \
    libjpeg-turbo \
    libjpeg-turbo-dev \
    libwebp \
    libwebp-dev \
    freetype \
    freetype-dev \
    libxpm-dev \
    imagemagick \
    imagemagick-dev \
    redis \
     libcurl curl-dev \
     rabbitmq-c-dev

RUN docker-php-ext-configure gd \
        --with-freetype \
        --with-jpeg \
        --with-webp \
        --with-xpm \
    && docker-php-ext-configure zip \
    && docker-php-ext-configure intl \
    && docker-php-ext-install -j$(nproc) \
        pdo \
        pdo_mysql \
        pdo_pgsql \
        pgsql \
        mbstring \
        gettext \
        gd \
        exif \
        zip \
        intl \
        bcmath \
        pcntl \
        sockets \
        sodium \
        opcache

RUN pecl install redis \
    && docker-php-ext-enable redis

RUN pecl install imagick \
    && docker-php-ext-enable imagick

RUN pecl install amqp \
 && docker-php-ext-enable amqp

COPY --from=composer-image /composer /usr/local/bin/composer

RUN addgroup -g 1000 laravel \
    && adduser -D -u 1000 -G laravel laravel

EXPOSE 9000

CMD ["php-fpm"]

