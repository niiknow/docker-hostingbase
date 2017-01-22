#!/bin/sh
#
DOTNET_VERSION=1.1.0
DOTNET_DOWNLOAD_URL=https://dotnetcli.blob.core.windows.net/dotnet/release/1.1.0/Binaries/$DOTNET_VERSION/dotnet-debian-x64.$DOTNET_VERSION.tar.gz

# dotnet deps
apt-get install -y libc6 libcurl3 libgcc1 libgssapi-krb5-2 liblttng-ust0 \
       libssl1.0.0 libstdc++6 libunwind8 libuuid1 zlib1g \

# fix dotnet
    && curl -o /tmp/libicu52_52.1-8ubuntu0.2_amd64.deb http://security.ubuntu.com/ubuntu/pool/main/i/icu/libicu52_52.1-8ubuntu0.2_amd64.deb \
    && dpkg -i /tmp/libicu52_52.1-8ubuntu0.2_amd64.deb

# setting up dotnet
curl -SL $DOTNET_DOWNLOAD_URL --output /tmp/dotnet.tar.gz \
    && mkdir -p /usr/share/dotnet \
    && tar -zxf /tmp/dotnet.tar.gz -C /usr/share/dotnet \
    && ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet
