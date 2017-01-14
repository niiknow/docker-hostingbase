FROM phusion/baseimage

MAINTAINER friends@niiknow.org

ENV DEBIAN_FRONTEND noninteractive \
    LANG C.UTF-8

# start
RUN \
    apt-get -o Acquire::GzipIndexes=false update \
    && apt-get update && apt-get -y upgrade \
    && apt-get -y install wget curl unzip nano vim rsync sudo tar git \
       apt-utils software-properties-common build-essential \
       python-dev python-pip libxml2-dev libxslt1-dev zlib1g-dev libffi-dev libssl-dev \
       libmagickwand-dev imagemagick perl netcat php-dev php-pear mcrypt pwgen \
       memcached tcl redis-server netcat openssl libpcre3 dnsmasq procps

# setup imagick, mariadb, fix python
RUN \
    dpkg --configure -a \
    && cd /tmp \
    && pecl install imagick \
    && curl -s -o /tmp/python-support_1.0.15_all.deb https://launchpadlibrarian.net/109052632/python-support_1.0.15_all.deb \
    && dpkg -i /tmp/python-support_1.0.15_all.deb \
    && apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8 \
    && add-apt-repository 'deb [arch=amd64,i386,ppc64el] http://nyc2.mirrors.digitalocean.com/mariadb/repo/10.1/ubuntu xenial main' \

# add php repo
    && apt-add-repository -y ppa:ondrej/php \

# getting golang
    && cd /tmp \
    && curl -s -o /tmp/go1.7.linux-amd64.tar.gz https://storage.googleapis.com/golang/go1.7.linux-amd64.tar.gz \
    && tar -xvf go1.7.linux-amd64.tar.gz \
    && mv go /usr/local \

# setting up java, aws-cli, and mongodb tools
    && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6 \
    && echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" \  
        | sudo tee /etc/apt/sources.list.d/mongodb-3.4.list \
    && echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections \
    && add-apt-repository -y ppa:webupd8team/java \
    && apt-get update && apt-get -y upgrade \
    && apt-get -y install mongodb-org-tools oracle-java8-installer \
    && curl -O https://bootstrap.pypa.io/get-pip.py \
    && python get-pip.py \
    && pip install awscli \

# cleanup
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/* \
    && rm -rf /var/cache/oracle-jdk8-installer

# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

CMD ["/sbin/my_init"]