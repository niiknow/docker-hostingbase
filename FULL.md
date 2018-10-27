FROM hyperknot/baseimage16:1.0.6 as v8builder
ENV V8_VERSION=6.8.275.32
RUN apt-get update && \
    apt-get install -y \
        build-essential \
        curl \
        git \
        libglib2.0-dev \
        libxml2 \
        python && \
    cd /tmp && \
    git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git && \
    export PATH=`pwd`/depot_tools:"$PATH" && \
    fetch v8 && \
    cd v8 && \
    git checkout $V8_VERSION && \
    gclient sync && \
    tools/dev/v8gen.py -vv x64.release -- is_component_build=true && \
    ninja -C out.gn/x64.release/

FROM hyperknot/baseimage16:1.0.6
LABEL maintainer="noogen <friends@niiknow.org>"
ENV DEBIAN_FRONTEND=noninteractive \
    LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 TERM=xterm container=docker
COPY --from=v8builder /tmp/v8/out.gn/x64.release/lib*.so /opt/libv8-6.8/lib/
COPY --from=v8builder /tmp/v8/out.gn/x64.release/*_blob.bin /opt/libv8-6.8/lib/
COPY --from=v8builder /tmp/v8/out.gn/x64.release/icudtl.dat /opt/libv8-6.8/lib/
COPY --from=v8builder /tmp/v8/include /opt/libv8-6.8/include
COPY rootfs/. /
RUN cd /tmp \
    && rsync --update -ahp --progress /opt/libv8-6.8/ /usr/local/ \
    # ... other things ...
