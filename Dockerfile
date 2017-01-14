FROM phusion/baseimage

MAINTAINER friends@niiknow.org

ENV DEBIAN_FRONTEND noninteractive \
    LANG C.UTF-8

# start
RUN \
    DEBIAN_FRONTEND=noninteractive apt-get -o Acquire::GzipIndexes=false update \
    && apt-get update && apt-get -y upgrade \
    && apt-get -y install wget curl unzip nano vim rsync sudo tar git apt-transport-https \
       apt-utils software-properties-common build-essential python-dev python-pip tcl \
       libxml2-dev libxslt1-dev zlib1g-dev libffi-dev libssl-dev libmagickwand-dev \
       memcached imagemagick perl netcat php-dev php-pear mcrypt pwgen netcat \
       redis-server openssl libpcre3 dnsmasq procps \
    && dpkg --configure -a \
    && apt-get clean

# setup imagick, mariadb, fix python, add php repo
RUN \
    DEBIAN_FRONTEND=noninteractive cd /tmp \
    && pecl install imagick \
    && curl -s -o /tmp/python-support_1.0.15_all.deb https://launchpadlibrarian.net/109052632/python-support_1.0.15_all.deb \
    && dpkg -i /tmp/python-support_1.0.15_all.deb \
    && apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8 \
    && add-apt-repository 'deb [arch=amd64,i386,ppc64el] http://nyc2.mirrors.digitalocean.com/mariadb/repo/10.1/ubuntu xenial main' \
    && apt-add-repository -y ppa:ondrej/php \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4F4EA0AAE5267A6C \

# getting golang
    && cd /tmp \
    && curl -s -o /tmp/go1.7.linux-amd64.tar.gz https://storage.googleapis.com/golang/go1.7.linux-amd64.tar.gz \
    && tar -xvf go1.7.linux-amd64.tar.gz \
    && mv go /usr/local \

# getting repos for dotnet, mongodb, java
#    && echo "deb [arch=amd64] https://apt-mo.trafficmanager.net/repos/dotnet-release/ xenial main" \
#        | sudo tee /etc/apt/sources.list.d/dotnetdev.list \
#    && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 417A0893 \

    && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6 \
    && echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" \  
        | sudo tee /etc/apt/sources.list.d/mongodb-3.4.list \

    && echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections \
    && add-apt-repository -y ppa:webupd8team/java \
    && rm -rf /tmp/*

RUN \
    DEBIAN_FRONTEND=noninteractive apt-get update && apt-get -y upgrade \

# setting up dotnet, java, mongodb tools, and aws-cli
#   && apt-get -y install dotnet-dev-1.0.0-preview4-004233 \
    && apt-get -y install oracle-java8-installer mongodb-org-tools \
    && curl -O https://bootstrap.pypa.io/get-pip.py \
    && python get-pip.py \
    && pip install awscli \

# cleanup
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/oracle-jdk8-installer

# define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle \
    DEBIAN_FRONTEND teletype

CMD ["/sbin/my_init"]