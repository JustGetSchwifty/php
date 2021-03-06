#!/bin/sh

cd /tmp
EXPECTED_SIGNATURE="$(wget -q -O - https://composer.github.io/installer.sig)"
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
ACTUAL_SIGNATURE="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"

if [ "$EXPECTED_SIGNATURE" != "$ACTUAL_SIGNATURE" ]
then
    >&2 echo 'ERROR: Invalid installer signature'
    rm composer-setup.php
    exit 1
fi

php composer-setup.php --quiet --install-dir=/bin --filename=composer
rm composer-setup.php

curl -sL http://deb.nodesource.com/setup_12.x | bash -
echo "deb http://deb.nodesource.com/node_12.x stretch main" > /etc/apt/sources.list.d/nodesource.list
echo "deb-src http://deb.nodesource.com/node_12.x stretch main" >> /etc/apt/sources.list.d/nodesource.list
curl -sS http://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
echo "deb http://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
apt-get update
apt-get install -y nodejs yarn

rm -r /var/lib/apt/lists/*
 
docker-php-ext-enable bcmath apcu bz2 curl dom exif gd gettext gnupg iconv imagick imap intl json mbstring memcached mysqli pdo pdo_mysql phar pspell session shmop simplexml soap sockets timezonedb xsl zip