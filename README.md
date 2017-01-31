# docker-hostingbase
Based off https://github.com/phusion/baseimage-docker, this image contain latest runtime of various language and framework including: dotnet, java, python, and php.  Ideal base image for hosting panels.

## sshd
For convienience, sshd is enabled by default.  Just don't expose the port if you don't want to use sshd.

## php files
1. precompiled v8js.so v0.6.4 for php5.6 and v1.3.3 for php7.0+
2. pcs.so and couchbase.so
3. precompiled imagick so you can add it later with phpX.X-imagick package
4. composer

## other runtimes
1. oracle-java8-sdk
2. nodejs 6.x
3. .NET 1.1.0 required libraries

## add repositories
1. php
2. mariadb
3. mongodb
4. couchbase and couchdb
4. java

# LICENSE

The MIT License (MIT)

Copyright (c) 2017 friends@niiknow.org

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.