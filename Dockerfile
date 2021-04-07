FROM php:8.0.3-fpm-buster

RUN cat /etc/apt/sources.list | sed 's/https:\/\/deb.debian/http:\/\/deb.debian/g' | sed 's/http:\/\/deb.debian.org/http:\/\/cdn-fastly.deb.debian.org/g' > /sources.tmp
RUN cp /sources.tmp /etc/apt/sources.list
RUN cat /etc/apt/sources.list #cache busting
RUN apt-get update && apt-get install nano htop git wget build-essential apt-transport-https ca-certificates apt-utils dirmngr -y

RUN apt-get update -y && apt-get install -y \
	libfreetype6-dev \
	libjpeg62-turbo-dev \
	libpng-dev \
	mcrypt \
	imagemagick \
	libruby \
	memcached \
	libmcrypt-dev \
	zip unzip libzip-dev \
	libc-client-dev \
	libkrb5-dev \
	libpspell-dev \
	aspell-en \
	aspell-cs \
	aspell-sk \
	aspell-de \
	aspell-fr \
	libxslt1-dev libxslt1-dev \
	libmagickwand-dev \
	iputils-ping \
	htop \
	nano \
	git \
	curl \
	libtidy-dev \
	libsnmp-dev \
	librecode0 \
	librecode-dev \
	libxml2-dev \
	libssl-dev \
	libxslt-dev \
	libpq-dev \
	libldb-dev \
	libsqlite3-dev \
	libsqlite3-0 \
	libc-client-dev \
	libkrb5-dev \
	libldap2-dev \
	firebird-dev \
	libcurl4 \
	snmp libsnmp-dev \
	zlib1g-dev libicu-dev g++ \
    libwebp-dev libjpeg62-turbo-dev libpng-dev libxpm-dev libfreetype6-dev \
	&& mkdir -p /usr/local/etc/php/conf.d/
RUN cd /tmp && git clone https://github.com/Imagick/imagick && cd imagick && phpize && ./configure && make && make install
RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl
RUN docker-php-ext-install imap
RUN docker-php-ext-configure gd \
	&& docker-php-ext-install -j$(nproc) gd
RUN docker-php-ext-install shmop
RUN docker-php-ext-install pdo
RUN docker-php-ext-configure pdo_mysql --with-zlib-dir --with-pdo-mysql=mysqlnd \
	&& docker-php-ext-install mysqli \
	&& docker-php-ext-install pdo_mysql  \
	&& docker-php-ext-install mysqli
RUN docker-php-ext-install bz2
RUN docker-php-ext-install dom
RUN docker-php-ext-install gettext
RUN docker-php-ext-install intl
RUN apt-get install libonig-dev -y
RUN docker-php-ext-configure mbstring \
	&& docker-php-ext-install mbstring
RUN docker-php-ext-install phar
RUN docker-php-ext-install session
RUN docker-php-ext-install simplexml
RUN docker-php-ext-install soap
RUN docker-php-ext-install sockets
RUN docker-php-ext-install exif
RUN docker-php-ext-install iconv
RUN docker-php-ext-install pspell
RUN docker-php-ext-install xsl
RUN docker-php-ext-install zip
RUN docker-php-ext-install bcmath
RUN docker-php-ext-enable imagick
RUN docker-php-ext-install opcache
RUN docker-php-ext-install calendar
RUN docker-php-ext-install ctype
RUN docker-php-ext-install dba
RUN docker-php-ext-install tokenizer
RUN docker-php-ext-install pgsql \
    && docker-php-ext-install pdo_pgsql
RUN docker-php-ext-install pdo_sqlite
RUN docker-php-ext-install pdo_firebird
RUN docker-php-ext-install pcntl
RUN docker-php-ext-install posix
RUN docker-php-ext-install snmp
RUN docker-php-ext-install sysvmsg \
    && docker-php-ext-install sysvsem \
    && docker-php-ext-install sysvshm
RUN docker-php-ext-install tidy
RUN pecl install xmlrpc-1.0.0RC2
RUN docker-php-ext-install xmlwriter
RUN docker-php-ext-install ftp
RUN docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu \
	&& docker-php-ext-install ldap
RUN cp /usr/lib/x86_64-linux-gnu/libcurl.so.4 /usr/lib/
RUN apt-get install libcurl4-gnutls-dev -y
ENV env LD_PRELOAD=/usr/lib/libcurl.so.4
RUN docker-php-ext-install curl

#3.1.3
RUN apt-get install -y libmemcached-dev zlib1g-dev \
	&& pecl install memcached-3.1.5 \
	&& docker-php-ext-enable memcached

#apcu-beta
RUN pecl install apcu-5.1.20 \
	&& echo extension=apcu.so > /usr/local/etc/php/conf.d/apcu.ini

#2019.1
RUN pecl install timezonedb-2021.1 \
	&& docker-php-ext-enable timezonedb

RUN apt-get install -y libgpgme11-dev

#1.4.0
RUN pecl install gnupg-1.5.0RC2 \
	&& docker-php-ext-enable gnupg

RUN docker-php-ext-enable imagick imap gd shmop pdo pdo_mysql mysqli bz2 dom gettext intl mbstring session simplexml soap sockets exif iconv pspell xsl zip bcmath opcache calendar ctype dba tokenizer pgsql pdo_pgsql pdo_sqlite pdo_firebird pcntl posix snmp sysvmsg sysvsem sysvshm tidy xmlrpc xmlwriter ftp ldap apcu opcache curl gnupg memcached timezonedb

RUN mkdir -p /scripts
RUN mkdir -p /var/log/php
RUN chmod 777 /scripts
RUN chown www-data:www-data /scripts
RUN apt-get install bash -y
COPY ./get_composer-npm-yarn.sh /scripts/get_composer-npm-yarn.sh
COPY ./startup.sh /scripts/startup.sh
RUN chmod +x /scripts/get_composer-npm-yarn.sh
RUN chmod +x /scripts/startup.sh

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*

ENV DB_ENV_MYSQL_ROOT_PASSWORD [blank]

ENTRYPOINT /scripts/startup.sh