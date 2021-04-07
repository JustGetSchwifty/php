#!/bin/sh

ENV=/scripts/installed.txt
if [ -f "$ENV" ]; then
  echo "Composer, NPM and Yarn already installed"
else
  echo "Installing Composer, NPM and Yarn"
  /bin/bash /scripts/get_composer-npm-yarn.sh
  echo "1" > /scripts/installed.txt
  echo "Composer, NPM and Yarn is installed"
fi

echo "Starting PHP-FPM"
chown www-data:www-data /var/www/html -R


php-fpm -F