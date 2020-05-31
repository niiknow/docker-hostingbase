FROM phusion/baseimage:0.10.2
ENV V8_VERSION=7.8.279.23
RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        curl \
        git \
        libglib2.0-dev \
        libxml2 \
        python \
        patchelf \
        && cd /tmp \
        \
        && git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git --progress --verbose \
        && export PATH="$PATH:/tmp/depot_tools" \
        \
        && fetch v8 \
        && cd v8 \
        && git checkout $V8_VERSION \
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
        && ninja -C out.gn/x64.release/ \
        && mkdir -p /opt/libv8-7.4/lib \
        && mkdir /opt/libv8-7.4/include \
        && cp out.gn/x64.release/lib*.so out.gn/x64.release/icudtl.dat \
        /opt/libv8-7.4/lib/ \
        && cp -R include/* /opt/libv8-7.4/include/ \
        && for A in /opt/libv8-7.4/lib/*.so; do patchelf --set-rpath '$ORIGIN' $A;done
