# docker-hostingbase
Based off https://github.com/phusion/baseimage-docker, this image contain latest runtime of various language and framework including: dotnet, java, python, and php.  Ideal base image for hosting panels.

## sshd
For convienience, sshd is enabled by default; just don't expose docker port 22 if you don't want to use sshd.

## php files
1. pecl install latest v8js for php7.0+
2. pecl install pcs and couchbase for couchdb
3. imagemagick lib for php-imagick support
4. composer

## other runtimes
1. oracle-java8-sdk
2. nodejs 8.x
3. .NET CORE required libraries

## add repositories
1. php
2. mariadb 10.2
3. mongodb 3.6
4. couchbase and couchdb
4. java

## Note
1.0.4 - remove support of v8js for php-5.6 due to deprecation of older v8 - https://github.com/phpv8/v8js/issues/345.  Upgrade from 3.4 to 3.6 for mongodb.

# MIT