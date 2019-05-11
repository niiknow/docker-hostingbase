# Full Build
Because full build of v8 takes too long causing docker hub to cancel build, we have to include v8 as part of this build.  Though, this would the script to use if one wish to build locally.

```
FROM phusion/baseimage:0.10.2 as v8builder
ENV V8_VERSION=7.4.288.21
RUN apt-get update && \
    apt-get install -y \
        build-essential \
        curl \
        git \
        libglib2.0-dev \
        libxml2 \
        python && \
        && cd /tmp \
        \
        && git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git --progress --verbose \
        && export PATH="$PATH:/tmp/depot_tools" \
        \
        && fetch v8 \
        && cd v8 \
        && git checkout 7.4.195 \
        && gclient sync \
        \
        && tools/dev/v8gen.py -vv x64.release -- \
        binutils_path=\"/usr/bin\" \
        target_os=\"linux\" \
        target_cpu=\"x64\" \
        v8_target_cpu=\"x64\" \
        v8_use_external_startup_data=false \
        is_official_build=true \
        is_component_build=true \
        is_cfi=false \
        is_clang=false \
        use_custom_libcxx=false \
        use_sysroot=false \
        use_gold=false \
        use_allocator_shim=false \
        treat_warnings_as_errors=false \
        symbol_level=0 \
        \
        && ninja -C out.gn/x64.release/

FROM phusion/baseimage:0.10.2
LABEL maintainer="noogen <friends@niiknow.org>"
ENV DEBIAN_FRONTEND=noninteractive \
    LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 TERM=xterm container=docker
COPY --from=v8builder /tmp/v8/out.gn/x64.release/lib*.so /opt/libv8-7.4/lib/
COPY --from=v8builder /tmp/v8/out.gn/x64.release/*_blob.bin /opt/libv8-7.4/lib/
COPY --from=v8builder /tmp/v8/out.gn/x64.release/icudtl.dat /opt/libv8-7.4/lib/
COPY --from=v8builder /tmp/v8/include /opt/libv8-7.4/include
COPY rootfs/. /
RUN cd /tmp \
    # install rsync and other things, and before install v8js push the lib
    && rsync --update -ahp --progress /opt/libv8-7.4/ /usr/local/ \
    # additional things
```
