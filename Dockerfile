FROM hyperknot/baseimage16

MAINTAINER friends@niiknow.org

ENV DEBIAN_FRONTEND=noninteractive
ENV LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 TERM=xterm container=docker

ADD ./files /
RUN \
    cd /tmp \
    && bash /tmp/install/index.sh

# define commonly used JAVA_HOME variable
ENV JAVA_HOME=/usr/lib/jvm/java-8-oracle
ENV DEBIAN_FRONTEND=teletype

CMD ["/sbin/my_init"]

EXPOSE 1194 6379 11211
