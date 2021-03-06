# docker-hostingbase
Based off https://github.com/phusion/baseimage-docker, this primarily build to include v8js and other common runtimes.

## sshd
For convienience, sshd is enabled by default; just don't expose docker port 22 if you don't want to use sshd.

## php files
1. pecl install latest v8 and v8js for php7.3+
2. pecl install pcs and couchbase for couchdb
3. imagemagick lib for php-imagick support

## add repositories
1. php 7.3+
2. mariadb 10.2
3. mongodb 3.6
4. couchbase and couchdb

## Note
1.6.1 - remove php 7.2 and add php8.0 - note that couchbase and v8js are not yet compatible for php8.0

1.5.1 - This container will go into EOL on April 2021 following Ubuntu 16.04 LTS lifecycle policy.  At best, I may start a new branch/repo for Ubuntu 20.04 LTS.

1.5.0 - removed deprecated php7.1 and add php7.4 - note that, pcs, igbinary, couchbase, and v8js are not yet compatible for php7.4

1.4.2 - remove composer

1.4.0 - removed v8 now that we can build v8js in all versions of php

1.3.0 - add php 7.3 build.  Everything works except pecl v8js for php7.3 build.  Note: Use the alternative pecl v8 module for php7.3 if you need v8 for while waiting for php7.3 v8js pecl updates.

1.2.1 - update v8js build.  Remove things that can be defer later.

1.1.0 - 10/26/2018 remove support for php5.6 and php7.0 as both will be end of life (EOL) by the end of this year: http://php.net/supported-versions.php

1.0.4 - remove support of v8js for php-5.6 due to deprecation of older v8 - https://github.com/phpv8/v8js/issues/345.  Upgrade from 3.4 to 3.6 for mongodb.

# MIT