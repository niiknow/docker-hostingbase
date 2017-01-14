FROM phusion/baseimage

MAINTAINER friends@niiknow.org

ENV DEBIAN_FRONTEND=noninteractive
ENV LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 TERM=xterm container=docker
ENV DOTNET_VERSION=1.1.0
ENV DOTNET_DOWNLOAD_URL=https://dotnetcli.blob.core.windows.net/dotnet/release/1.1.0/Binaries/$DOTNET_VERSION/dotnet-debian-x64.$DOTNET_VERSION.tar.gz

# start
RUN \
    apt-get -o Acquire::GzipIndexes=false update \
    && apt-get update && apt-get -y upgrade \
    && apt-get -y install wget curl unzip nano vim rsync sudo tar git apt-transport-https \
       apt-utils software-properties-common build-essential python-dev python-pip tcl \
       libxml2-dev libxslt1-dev zlib1g-dev libffi-dev libssl-dev libmagickwand-dev \
       memcached imagemagick perl netcat php-dev php-pear mcrypt pwgen netcat \
       redis-server openssl libpcre3 dnsmasq procps ca-certificates \

# dotnet deps
       libc6 libcurl3 libgcc1 libgssapi-krb5-2 liblttng-ust0 \
       libssl1.0.0 libstdc++6 libunwind8 libuuid1 zlib1g \

    && dpkg --configure -a \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -f /core

# setup imagick, mariadb, fix python, add php repo
RUN \
    cd /tmp \
    && pecl install imagick \

# fix python
    && curl -s -o /tmp/python-support_1.0.15_all.deb https://launchpadlibrarian.net/109052632/python-support_1.0.15_all.deb \
    && dpkg -i /tmp/python-support_1.0.15_all.deb \

# fix dotnet
    && curl -s -o /tmp/libicu52_52.1-8_amd64.deb https://launchpadlibrarian.net/201330288/libicu52_52.1-8_amd64.deb
    && dpkg -i /tmp/libicu52_52.1-8_amd64.deb \

# add mariadb
    && apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8 \
    && add-apt-repository 'deb [arch=amd64] http://nyc2.mirrors.digitalocean.com/mariadb/repo/10.1/ubuntu xenial main' \

# add php
    && apt-add-repository -y ppa:ondrej/php \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4F4EA0AAE5267A6C \

# getting repos for mongodb, java
    && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6 \
    && echo 'deb [arch=amd64] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse' \  
        | sudo tee /etc/apt/sources.list.d/mongodb-3.4.list \

    && echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections \
    && add-apt-repository -y ppa:webupd8team/java \

    && apt-get update && apt-get -y upgrade \

# setting up java, mongodb tools, and aws-cli
    && apt-get -y install oracle-java8-installer mongodb-org-tools \
    && curl -O https://bootstrap.pypa.io/get-pip.py \
    && python get-pip.py \
    && pip install awscli \

# setting up dotnet
    && curl -SL $DOTNET_DOWNLOAD_URL --output /tmp/dotnet.tar.gz \
    && mkdir -p /usr/share/dotnet \
    && tar -zxf /tmp/dotnet.tar.gz -C /usr/share/dotnet \
    && ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet

# getting golang, comment out to wait for 1.8 official release
#    && cd /tmp \
#    && curl -s -o /tmp/go1.8.linux-amd64.tar.gz https://storage.googleapis.com/golang/go1.8.linux-amd64.tar.gz \
#    && tar -zxf go1.8.linux-amd64.tar.gz \
#    && mv go /usr/local \

# cleanup
    && rm -rf /tmp/* \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/oracle-jdk8-installer

# define commonly used JAVA_HOME variable
ENV JAVA_HOME=/usr/lib/jvm/java-8-oracle
ENV DEBIAN_FRONTEND=teletype

CMD ["/sbin/my_init"]