FROM hyperknot/baseimage16:1.0.2

MAINTAINER friends@niiknow.org

ENV DEBIAN_FRONTEND=noninteractive \
    LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 TERM=xterm container=docker

# start
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4F4EA0AAE5267A6C \
    && add-apt-repository -y ppa:pinepain/libv8-5.4  \
    && curl -s -o /tmp/couchbase-release-1.0-4-amd64.deb http://packages.couchbase.com/releases/couchbase-release/couchbase-release-1.0-4-amd64.deb \
    && dpkg -i /tmp/couchbase-release-1.0-4-amd64.deb \
    && add-apt-repository -y ppa:couchdb/stable \
    && apt-add-repository -y ppa:ondrej/php \

# install
    && apt-get update && apt-get -y --no-install-recommends upgrade \
    && apt-get -y --no-install-recommends --allow-unauthenticated install wget curl unzip nano vim rsync apt-transport-https openssh-client openssh-server \
       sudo tar git apt-utils software-properties-common build-essential python-dev tcl openssl libpcre3 dnsmasq ca-certificates libpcre3-dev \
       libxml2-dev libxslt1-dev zlib1g-dev libffi-dev libssl-dev libmagickwand-dev procps imagemagick netcat libv8-5.4-dev pkg-config \
       mcrypt pwgen language-pack-en-base libicu-dev g++ cpp libglib2.0-dev incron libcouchbase-dev libcouchbase2-libevent \
       php7.2-dev php-pear php-xml php7.2-xml php7.0-dev php7.0-xml php7.1-dev php7.1-xml \

# dotnet deps
       libc6 libcurl3 libgcc1 libgssapi-krb5-2 liblttng-ust0 libssl1.0.0 libstdc++6 libunwind8 libuuid1 zlib1g \

    && systemctl disable incron \
    && echo 'root' >> /etc/incron.allow \
    && dpkg --configure -a \

# install for php 7.2
    && update-alternatives --set php /usr/bin/php7.2 \
    && update-alternatives --set phar /usr/bin/phar7.2 \
    && update-alternatives --set phar.phar /usr/bin/phar.phar7.2 \
    && pecl config-set php_ini /etc/php/7.2/cli/php.ini \
    && pecl config-set ext_dir /usr/lib/php/20170718 \
    && pecl config-set php_bin /usr/bin/php7.2 \
    && pecl config-set php_suffix 7.2 \

    && pecl install -f -a -l v8js \
    && pecl install -f pcs \
    && pecl install -f couchbase \
    && pecl install -f imagick \

    && rm -rf /tmp/pear/ \
# install for php 7.0
    && update-alternatives --set php /usr/bin/php7.0 \
    && update-alternatives --set phar /usr/bin/phar7.0 \
    && update-alternatives --set phar.phar /usr/bin/phar.phar7.0 \
    && pecl config-set php_ini /etc/php/7.0/cli/php.ini \
    && pecl config-set ext_dir /usr/lib/php/20151012 \
    && pecl config-set php_bin /usr/bin/php7.0 \
    && pecl config-set php_suffix 7.0 \

    && pecl install -f -a -l v8js \
    && pecl install -f pcs \
    && pecl install -f couchbase \
    && pecl install -f imagick \

    && rm -rf /tmp/pear/ \
# install for php 7.1
    && update-alternatives --set php /usr/bin/php7.1 \
    && update-alternatives --set phar /usr/bin/phar7.1 \
    && update-alternatives --set phar.phar /usr/bin/phar.phar7.1 \
    && pecl config-set php_ini /etc/php/7.1/cli/php.ini \
    && pecl config-set ext_dir /usr/lib/php/20160303 \
    && pecl config-set php_bin /usr/bin/php7.1 \
    && pecl config-set php_suffix 7.1 \

    && pecl install -f -a -l v8js \
    && pecl install -f pcs \
    && pecl install -f couchbase \
    && pecl install -f imagick \

    && apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -f /core \
    && rm -rf /tmp/* \

# re-enable all default services
    && find /etc/service/ -name "down" -exec rm -f {} \;

COPY rootfs/. /

# setup imagick is required early to support php package later
# setup mariadb, fix python, add php repo
RUN cd /tmp \
    && chmod +x /etc/service/sshd/run \
    && chmod +x /usr/bin/backup-creds.sh \

# incrond is disabled by default, user should delete the down file after init
    && chmod +x /etc/service/incrond/run \

# fixes for python
    && curl -s -o /tmp/python-support_1.0.15_all.deb https://launchpadlibrarian.net/109052632/python-support_1.0.15_all.deb \
    && dpkg -i /tmp/python-support_1.0.15_all.deb \

# fixes for dotnet
    && curl -o /tmp/libicu52_52.1-8ubuntu0.2_amd64.deb http://security.ubuntu.com/ubuntu/pool/main/i/icu/libicu52_52.1-8ubuntu0.2_amd64.deb \
    && dpkg -i /tmp/libicu52_52.1-8ubuntu0.2_amd64.deb \

# add mariadb 10.1 repo
    && apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8 \
    && add-apt-repository 'deb [arch=amd64,i386] http://nyc2.mirrors.digitalocean.com/mariadb/repo/10.1/ubuntu xenial main' \

# getting repos for mongodb, java
    && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6 \
    && echo 'deb [arch=amd64,i386] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse' \
        | sudo tee /etc/apt/sources.list.d/mongodb-3.4.list \

    && echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections \
    && add-apt-repository -y ppa:webupd8team/java \

    && apt-get update && apt-get -y --no-install-recommends upgrade \

# setting up java, mongodb tools, and nodejs
    && apt-get -y --no-install-recommends --allow-unauthenticated install oracle-java8-installer oracle-java8-set-default \
    && dpkg --configure -a \

# setup other things
    && echo "\n\nJAVA_HOME=/usr/lib/jvm/java-8-oracle\nexport JAVA_HOME\n" >> /root/.profile \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash - \

# cleanup
    && rm -rf /tmp/* \
    && apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/oracle-jdk8-installer

ENV DEBIAN_FRONTEND=teletype

VOLUME ["/backup"]

CMD ["/sbin/my_init"]
