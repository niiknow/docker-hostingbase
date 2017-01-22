FROM hyperknot/baseimage16

MAINTAINER friends@niiknow.org

ENV DEBIAN_FRONTEND=noninteractive
ENV LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 TERM=xterm container=docker
ENV DOTNET_VERSION=1.1.0
ENV DOTNET_DOWNLOAD_URL=https://dotnetcli.blob.core.windows.net/dotnet/release/1.1.0/Binaries/$DOTNET_VERSION/dotnet-debian-x64.$DOTNET_VERSION.tar.gz
ENV GOLANG_VERSION=1.7.4
ENV GOLANG_DOWNLOAD_URL=https://storage.googleapis.com/golang/go$GOLANG_VERSION.linux-amd64.tar.gz

# start
RUN \
    apt-get -o Acquire::GzipIndexes=false update \
    && apt-get update && apt-get -y upgrade \
    && apt-get -y install wget curl unzip nano vim rsync sudo tar git apt-transport-https openssh-client openssh-server \
       apt-utils software-properties-common build-essential python-dev tcl openssl libpcre3 dnsmasq ca-certificates \
       libxml2-dev libxslt1-dev zlib1g-dev libffi-dev libssl-dev libmagickwand-dev procps imagemagick perl netcat \
       php-dev php-pear mcrypt pwgen language-pack-en-base libicu-dev g++ cpp \

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
    && curl -o /tmp/libicu52_52.1-8ubuntu0.2_amd64.deb http://security.ubuntu.com/ubuntu/pool/main/i/icu/libicu52_52.1-8ubuntu0.2_amd64.deb \
    && dpkg -i /tmp/libicu52_52.1-8ubuntu0.2_amd64.deb \

# add php
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4F4EA0AAE5267A6C \
    && apt-add-repository -y ppa:ondrej/php \
    && apt-add-repository -y ppa:pinepain/libv8-5.4 \

# add mariadb
    && apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8 \
    && add-apt-repository 'deb [arch=amd64] http://nyc2.mirrors.digitalocean.com/mariadb/repo/10.1/ubuntu xenial main' \

# getting repos for mongodb, java
    && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6 \
    && echo 'deb [arch=amd64] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse' \  
        | sudo tee /etc/apt/sources.list.d/mongodb-3.4.list \

    && echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections \
    && add-apt-repository -y ppa:webupd8team/java \

    && apt-get update && apt-get -y upgrade \

# setting up java, mongodb tools, and aws-cli
    && apt-get -y install oracle-java8-installer memcached redis-server openvpn mongodb-org libv8-5.4-dev\
    && echo -e "\n\nJAVA_HOME=/usr/lib/jvm/java-8-oracle\nexport JAVA_HOME\n" >> /root/.profile \

# cleanup
    && rm -rf /tmp/* \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/oracle-jdk8-installer

# setting up dotnet
RUN curl -SL $DOTNET_DOWNLOAD_URL --output /tmp/dotnet.tar.gz \
    && mkdir -p /usr/share/dotnet \
    && tar -zxf /tmp/dotnet.tar.gz -C /usr/share/dotnet \
    && ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet \

# aws cli
    && curl -O https://bootstrap.pypa.io/get-pip.py \
    && python get-pip.py \
    && pip install awscli \

# getting golang
    && cd /tmp \
    && curl -SL $GOLANG_DOWNLOAD_URL --output /tmp/golang.tar.gz \
    && tar -zxf golang.tar.gz \
    && mv go /usr/local \
    && echo -e "\n\GOROOT=/usr/local/go\nexport GOROOT\n" >> /root/.profile \

# cleanup
    && rm -rf /tmp/*

ENV DEBIAN_FRONTEND=teletype

CMD ["/sbin/my_init"]
