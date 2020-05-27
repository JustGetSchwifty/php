#!/bin/bash

ENV=/opt/installed.txt
if [ -f "$ENV" ]; then
  docker-php-ext-enable apcu bz2 curl dom exif gd gettext gnupg iconv imagick imap intl json mbstring memcached mysqli opcache pdo pdo_mysql pspell session shmop simplexml soap sockets timezonedb xsl zip mysql
  #echo "Updating Composer, NPM and Yarn"
  #/bin/bash /opt/scripts/update_composer-npm-yarn.sh
else
  echo "Installing Composer, NPM and Yarn"
  /bin/bash /opt/scripts/get_composer-npm-yarn.sh
  echo "1" > /opt/installed.txt
  echo "Composer, NPM and Yarn is installed"
fi

echo "Starting PHP-FPM"

php-fpm -F