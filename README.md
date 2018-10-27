# docker-hostingbase
Based off https://github.com/phusion/baseimage-docker, this primarily build to include v8js and other common runtimes.

## sshd
For convienience, sshd is enabled by default; just don't expose docker port 22 if you don't want to use sshd.

## php files
1. pecl install latest v8js for php7.1+
2. pecl install pcs and couchbase for couchdb
3. imagemagick lib for php-imagick support
4. composer

## add repositories
1. php
2. mariadb 10.2
3. mongodb 3.6
4. couchbase and couchdb

## Note
1.2.1 - update v8js build.  Remove things that can be defer later.

1.1.0 - 10/26/2018 remove support for php5.6 and php7.0 as both will be end of life (EOL) by the end of this year: http://php.net/supported-versions.php

1.0.4 - remove support of v8js for php-5.6 due to deprecation of older v8 - https://github.com/phpv8/v8js/issues/345.  Upgrade from 3.4 to 3.6 for mongodb.

# MIT