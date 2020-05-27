#!/bin/bash

ENV=/opt/installed.txt
if [ -f "$ENV" ]; then
  echo "Composer, NPM and Yarn already installed"
else
  echo "Installing Composer, NPM and Yarn"
  /bin/bash /opt/scripts/get_composer-npm-yarn.sh
  echo "1" > /opt/installed.txt
  echo "Composer, NPM and Yarn is installed"
fi

echo "Starting PHP-FPM"
chown www-data:www-data /var/www/html -R

php-fpm -F