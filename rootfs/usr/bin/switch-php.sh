#!/bin/bash

# Check if ran with root permissions
if [ `id -u` -ne 0 ]; then
   printf "The script must be run as root! (you can use sudo)\n"
   exit 1
fi

function main {
  local VERSION=$1

  printf "Switching PHP to %s\n" "$VERSION"
  ls -la /usr/bin/php$VERSION
  update-alternatives --set php /usr/bin/php$VERSION
  ls -la /usr/bin/phar$VERSION
  update-alternatives --set phar /usr/bin/phar$VERSION
  ls -la /usr/bin/phar.phar$VERSION
  update-alternatives --set phar.phar /usr/bin/phar.phar$VERSION
  ls -la /usr/bin/phpize$VERSION
  update-alternatives --set phpize /usr/bin/phpize$VERSION
  ls -la /usr/bin/php-config$VERSION
  update-alternatives --set php-config /usr/bin/php-config$VERSION

  EXT_DIR=$(/usr/bin/php-config$VERSION --extension-dir)
  pecl config-set ext_dir /usr/lib/php/$EXT_DIR
  pecl config-set php_ini /etc/php/$VERSION/cli/php.ini
  pecl config-set php_bin /usr/bin/php$VERSION
  pecl config-set php_suffix $VERSION
}

main $1

