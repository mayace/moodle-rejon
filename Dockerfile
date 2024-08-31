FROM php:8.1.29-apache

# Install required PHP extensions for Moodle
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    zip \
    unzip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd \
    && docker-php-ext-install zip \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install opcache \
    && docker-php-ext-enable opcache

# Install Xdebug
RUN pecl install xdebug \
    && docker-php-ext-enable xdebug

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Set up the Moodle directory
# RUN mkdir -p /var/www/html
# RUN mkdir -p /bitnami/moodledata
WORKDIR /var/www/html

# Copy Moodle files (you need to have Moodle source in the directory)
COPY . .

RUN echo "ServerName localhost:80" >> /etc/apache2/apache2.conf

# Set the proper permissions
# RUN chown -R www-data:www-data /var/www/html
# RUN chown -R www-data:www-data /bitnami/moodledata


CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]