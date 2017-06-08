FROM hyperknot/baseimage16:1.0.0

MAINTAINER friends@niiknow.org

ENV DEBIAN_FRONTEND=noninteractive
ENV LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 TERM=xterm container=docker

# start
RUN \
    apt-get -o Acquire::GzipIndexes=false update \
    && apt-get update && apt-get -y upgrade \
    && apt-get -y install wget curl unzip nano vim rsync sudo tar git apt-transport-https openssh-client openssh-server \
       apt-utils software-properties-common build-essential python-dev tcl openssl libpcre3 dnsmasq ca-certificates \
       libxml2-dev libxslt1-dev zlib1g-dev libffi-dev libssl-dev libmagickwand-dev procps imagemagick netcat \
       php-dev php-pear mcrypt pwgen language-pack-en-base libicu-dev g++ cpp libglib2.0-dev incron \
       libpcre3-dev \

# dotnet deps
       libc6 libcurl3 libgcc1 libgssapi-krb5-2 liblttng-ust0 \
       libssl1.0.0 libstdc++6 libunwind8 libuuid1 zlib1g \

    && echo 'root' >> /etc/incron.allow \
    && dpkg --configure -a \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \

# re-enable all default services
    && rm -f /etc/service/syslog-forwarder/down \
    && rm -f /etc/service/cron/down \
    && rm -f /etc/service/syslog-ng/down \
    && rm -f /core

ADD ./files /

# setup imagick is required early to support php package later
# setup mariadb, fix python, add php repo
RUN \
    cd /tmp \
    && chmod +x /etc/service/sshd/run \
    && chmod +x /usr/bin/backup-creds.sh \
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
    && add-apt-repository -y ppa:pinepain/libv8-5.4 \
    && curl -s -o /tmp/couchbase-release-1.0-2-amd64.deb http://packages.couchbase.com/releases/couchbase-release/couchbase-release-1.0-2-amd64.deb \
    && dpkg -i /tmp/couchbase-release-1.0-2-amd64.deb \

# add mariadb
    && apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8 \
    && add-apt-repository 'deb [arch=amd64] http://nyc2.mirrors.digitalocean.com/mariadb/repo/10.1/ubuntu xenial main' \

# add couchdb
    && add-apt-repository -y ppa:couchdb/stable \

# getting repos for mongodb, java
    && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6 \
    && echo 'deb [arch=amd64] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse' \  
        | sudo tee /etc/apt/sources.list.d/mongodb-3.4.list \

    && echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections \
    && add-apt-repository -y ppa:webupd8team/java \

    && apt-get update && apt-get -y upgrade \

# setting up java, mongodb tools, and nodejs
    && apt-get -y install oracle-java8-installer libcouchbase-dev libv8-5.4 --allow-unauthenticated \
    && echo "\n\nJAVA_HOME=/usr/lib/jvm/java-8-oracle\nexport JAVA_HOME\n" >> /root/.profile \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash - \

# cleanup
    && rm -rf /tmp/* \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/oracle-jdk8-installer

ENV DEBIAN_FRONTEND=teletype

VOLUME ["/backup"]

CMD ["/sbin/my_init"]
