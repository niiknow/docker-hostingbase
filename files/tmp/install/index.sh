#!/bin/sh
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

export DEBIAN_FRONTEND=noninteractive
export LC_ALL=en_US.UTF-8 
export LANG=en_US.UTF-8 
export LANGUAGE=en_US.UTF-8 
export TERM=xterm
export container=docker

# start
apt-get -o Acquire::GzipIndexes=false update \
    && apt-get update && apt-get -y upgrade \
    && apt-get -y install wget curl unzip nano vim rsync sudo tar git apt-transport-https openssh-client openssh-server \
       apt-utils software-properties-common build-essential python-dev tcl openssl libpcre3 dnsmasq ca-certificates \
       libxml2-dev libxslt1-dev zlib1g-dev libffi-dev libssl-dev libmagickwand-dev procps imagemagick perl netcat \
       php-dev php-pear mcrypt pwgen language-pack-en-base libicu-dev libv8-dev libv8-dbg g++ cpp \
    && dpkg --configure -a \

cd /tmp \
    && pecl install imagick \

# fix python
    && curl -s -o /tmp/python-support_1.0.15_all.deb https://launchpadlibrarian.net/109052632/python-support_1.0.15_all.deb \
    && dpkg -i /tmp/python-support_1.0.15_all.deb \

# add a bunch of repos
# add php repo
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4F4EA0AAE5267A6C \
    && apt-add-repository -y ppa:ondrej/php \

# add mariadb repo
    && apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8 \
    && add-apt-repository 'deb [arch=amd64] http://nyc2.mirrors.digitalocean.com/mariadb/repo/10.1/ubuntu xenial main' \

# add mongodb repo
    && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6 \
    && echo 'deb [arch=amd64] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse' \  
        | sudo tee /etc/apt/sources.list.d/mongodb-3.4.list \

# add java repo
    && echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections \
    && add-apt-repository -y ppa:webupd8team/java \

# update newly added repos
    && apt-get update && apt-get -y upgrade \

# install java, memcached:11211, redis-server:6739, openvpn:1194
    && apt-get install -y oracle-java8-installer memcached redis-server openvpn \
    && rm -rf /var/cache/oracle-jdk8-installer \

# setting up aws-cli, dotnet, golang
    && bash /tmp/install/awscli.sh \
    && bash /tmp/install/dotnet.sh \
    && bash /tmp/install/golang.sh \
    && echo -e "\n\nJAVA_HOME=/usr/lib/jvm/java-8-oracle\nexport JAVA_HOME\n" >> ~/.profile \

# cleanup
    && rm -rf /tmp/* \
    && apt-get clean \
    && rm -rf /core \
    && rm -rf /var/lib/apt/lists/*
