# docker-hostingbase
Based off https://github.com/phusion/baseimage-docker, this image contain latest runtime of various language and framework including: dotnet, java, python, and php.  Ideal base image for hosting panels.

## sshd
For convienience, sshd is enabled by default; just don't expose docker port 22 if you don't want to use sshd.

## php files
1. precompiled v8js-0.6.4 for php5.6
2. pecl install v8js-1.4.1 for php7.0+
3. pecl install pcs and couchbase for couchdb
4. imagemagick lib for php-imagick support
5. composer

## other runtimes
1. oracle-java8-sdk
2. nodejs 8.x
3. .NET CORE required libraries

## add repositories
1. php
2. mariadb 10.1
3. mongodb 3.4
4. couchbase and couchdb
4. java

# MIT