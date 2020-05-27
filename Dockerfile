FROM php:5.6.35-fpm

RUN printf "deb http://archive.debian.org/debian/ jessie main\ndeb-src http://archive.debian.org/debian/ jessie main\ndeb http://security.debian.org jessie/updates main\ndeb-src http://security.debian.org jessie/updates main" > /etc/apt/sources.list
RUN apt-get update && apt-get install nano htop git wget build-essential apt-transport-https ca-certificates apt-utils dirmngr -y --force-yes

RUN apt-get update -y --force-yes && apt-get install -y --force-yes \
		libfreetype6-dev \
		libjpeg62-turbo-dev \
		libpng-dev \
		mcrypt \
		imagemagick \
		libruby \
		memcached \
		zip unzip libzip-dev \
		libc-client-dev \
		libkrb5-dev \
		libpspell-dev \
		libxslt1-dev libxslt1-dev \
		libmagickwand-dev \
        iputils-ping \
        htop \
        nano \
        git \
        curl \
        libcurl3 \
        zlib1g-dev libicu-dev g++ \
        mysql-client \
        libwebp-dev libjpeg62-turbo-dev libpng-dev libxpm-dev libfreetype6-dev \
	&& mkdir -p /usr/local/etc/php/conf.d/
RUN pecl install imagick \
	&& docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
	&& docker-php-ext-install imap \
	&& docker-php-ext-configure gd --with-gd --with-webp-dir --with-jpeg-dir --with-png-dir --with-zlib-dir --with-xpm-dir --with-freetype-dir --enable-gd-native-ttf \
	&& docker-php-ext-install gd \
    && docker-php-ext-install shmop \
    && docker-php-ext-install pdo \
    && docker-php-ext-configure pdo_mysql --with-zlib-dir --with-pdo-mysql \
	&& docker-php-ext-install pdo_mysql  \
    && docker-php-ext-install mysqli \
	&& docker-php-ext-install bz2 \
	&& docker-php-ext-install dom \
	&& docker-php-ext-install gettext \
	&& docker-php-ext-configure intl \
	&& docker-php-ext-install intl \
	&& docker-php-ext-install json \
	&& docker-php-ext-configure mbstring --enable-mbst \
	&& docker-php-ext-install mbstring \
	&& docker-php-ext-install session \
	&& docker-php-ext-install simplexml \
	&& docker-php-ext-install soap \
	&& docker-php-ext-install sockets \
    && docker-php-ext-install mysqli \
	&& docker-php-ext-install exif \
    && docker-php-ext-install iconv \
    && docker-php-ext-install pspell \
    && docker-php-ext-install xsl \
    && docker-php-ext-install zip \
	&& docker-php-ext-enable imagick \
    && docker-php-ext-install mysql \
	&& docker-php-ext-enable mysql \
    && cp /usr/lib/x86_64-linux-gnu/libcurl.so.3 /usr/lib/
RUN apt-get update && apt-get install libcurl4-gnutls-dev -y --force-yes
ENV env LD_PRELOAD=/usr/lib/libcurl.so.3
RUN docker-php-ext-install curl

RUN apt-get install -y --force-yes libmemcached-dev zlib1g-dev \
    && pecl install memcached-2.2.0 \
    && docker-php-ext-enable memcached

RUN pecl install apcu-4.0.8 \
    && echo extension=apcu.so > /usr/local/etc/php/conf.d/apcu.ini

RUN pecl install timezonedb-2019.1 \
    && docker-php-ext-enable timezonedb

RUN apt-get install -y --force-yes libgpgme11-dev

RUN pecl install gnupg-1.4.0 \
    && docker-php-ext-enable gnupg


RUN docker-php-ext-enable apcu bz2 curl dom exif gd gettext gnupg iconv imagick imap intl json mbstring memcached mysqli opcache pdo pdo_mysql pspell session shmop simplexml soap sockets timezonedb xsl zip mysql


RUN mkdir -p /opt/scripts
RUN mkdir -p /var/log/php
RUN chmod 777 /var/log/php -R
COPY ./get_composer-npm-yarn.sh /opt/scripts/get_composer-npm-yarn.sh
COPY ./startup.sh /opt/scripts/startup.sh
RUN chmod +x /opt/scripts/get_composer-npm-yarn.sh
RUN chmod +x /opt/scripts/startup.sh

RUN apt-get install git -y --force-yes && cd /tmp/ && git clone -n https://github.com/crypt1d/redi.sh.git --depth 1 /tmp/redish && cd /tmp/redish && git checkout HEAD redi.sh && cp redi.sh /usr/bin && chmod +x /usr/bin/redi.sh

ENV DB_ENV_MYSQL_ROOT_PASSWORD [blank]

