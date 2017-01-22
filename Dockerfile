FROM hyperknot/baseimage16

MAINTAINER friends@niiknow.org

ENV DEBIAN_FRONTEND=noninteractive
ENV LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 TERM=xterm container=docker

RUN apt-get -o Acquire::GzipIndexes=false update \
    && apt-get update && apt-get -y upgrade \
    && apt-get -y install wget curl unzip nano vim rsync sudo tar git apt-transport-https openssh-client openssh-server \
       apt-utils software-properties-common build-essential python-dev tcl openssl libpcre3 dnsmasq ca-certificates \
       libxml2-dev libxslt1-dev zlib1g-dev libffi-dev libssl-dev libmagickwand-dev procps imagemagick perl netcat \
       php-dev php-pear mcrypt pwgen language-pack-en-base libicu-dev libv8-dev g++ cpp \
    && dpkg --configure -a

ADD ./files /
RUN \
    cd /tmp \
    && chmod +x /tmp/install/*.sh \
    && /tmp/install/index.sh

# define commonly used JAVA_HOME variable
ENV JAVA_HOME=/usr/lib/jvm/java-8-oracle
ENV DEBIAN_FRONTEND=teletype

CMD ["/sbin/my_init"]
