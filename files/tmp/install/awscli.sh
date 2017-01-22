#!/bin/sh
#
export DEBIAN_FRONTEND=noninteractive
export LC_ALL=en_US.UTF-8 
export LANG=en_US.UTF-8 
export LANGUAGE=en_US.UTF-8 
export TERM=xterm
export container=docker

curl -O https://bootstrap.pypa.io/get-pip.py \
    && python get-pip.py \
    && pip install awscli
