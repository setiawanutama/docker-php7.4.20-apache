FROM php:7.4.20-apache

# install GD extension
RUN apt-get clean \
    && apt-get update \
    && apt-get install -y \
    libfreetype6-dev \
    libpng-dev \
    libjpeg-dev \
    && docker-php-ext-configure gd \
    && docker-php-ext-install -j$(nproc) \
    gd \
    && apt-get purge -y \
    libfreetype6-dev \
    libpng-dev \
    libjpeg-dev

# install pgsql extension
RUN apt-get install -y libpq-dev \
    && docker-php-ext-install pgsql pdo pdo_pgsql

# install Git
RUN apt-get install -y git

# install zip & unzip
RUN apt-get install -y zip unzip

# install locale
RUN apt-get install -y locales locales-all

# enable Apache mod_rewrite module
RUN a2enmod rewrite

# enable Apache mod_expires module
RUN a2enmod expires

# install & enable phpredis extension
RUN pecl install redis-5.3.3 \
    &&  rm -rf /tmp/pear \
    && docker-php-ext-enable redis

# install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# change timezone to Asia/Jakarta by creating symbolic link
RUN ln -sf /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

# bind port to the host
EXPOSE 80/tcp
