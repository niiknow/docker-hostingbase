#!/bin/sh
#
# getting golang
GOLANG_VERSION=1.7.4
GOLANG_DOWNLOAD_URL=https://storage.googleapis.com/golang/go$GOLANG_VERSION.linux-amd64.tar.gz

cd /tmp \
	&& curl -SL $GOLANG_DOWNLOAD_URL --output /tmp/golang.tar.gz \
	&& tar -zxf golang.tar.gz \
	&& mv go /usr/local

echo -e "\n\nJAVA_HOME=/usr/lib/jvm/java-8-oracle\nexport JAVA_HOME\n" >> ~/.profile \
echo -e "\n\GOROOT=/usr/local/go\nexport GOROOT\n" >> ~/.profile \
