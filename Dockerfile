FROM php:7-fpm

RUN php -r "copy('https://getcomposer.org/installer', '/tmp/composer-setup.php');"
RUN php /tmp/composer-setup.php --no-ansi --install-dir=/usr/local/bin --filename=composer && \
    rm -rf /tmp/composer-setup.php

RUN apt-get update && \
    apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
        libsqlite3-dev \
        libcurl4-gnutls-dev \
    && apt-get install -y libmcrypt-dev mysql-client \
    && docker-php-ext-install -j$(nproc) iconv mcrypt pdo_mysql gd zip curl bcmath opcache mbstring \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-enable iconv mcrypt pdo_mysql gd zip curl bcmath opcache mbstring \
    && apt-get autoremove -y

RUN apt-get update && \
    apt-get -y install --fix-missing \
        python \
        python-dev \
        python-pip \
        python-numpy \
        python-pandas \
        python-scipy \
    && pip install -U pip setuptools \
    && pip install -U scikit-learn \
    && pip install pandas --upgrade

COPY php.ini /usr/local/etc/php

WORKDIR /var/www