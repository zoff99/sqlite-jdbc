FROM gotson/crossbuild
ARG DEBIAN_FRONTEND=noninteractive
#RUN export DEBIAN_FRONTEND=noninteractive && apt update && apt install -y make yasm wget git \
#    coreutils autoconf libtool pkg-config nano
RUN mkdir -p /src/
RUN wget https://raw.githubusercontent.com/zoff99/iocipher_pack/refs/heads/master/000_deps/openssl.tar.gz -O /tmp/file.txt && \
    wget https://github.com/zoff99/iocipher_pack/raw/refs/heads/master/000_deps/"$(cat /tmp/file.txt 2>/dev/null)" -O /src/openssl.tar.gz && \
    rm -f /tmp/file.txt
RUN cd /src/ && tar -xzvf openssl.tar.gz && cd openssl-* && \
    CROSS_TRIPLE=aarch64-apple-darwin \
    CC="/usr/osxcross/bin/aarch64-apple-darwin20.4-cc" CROSS_PREFIX="/usr/osxcross/bin/aarch64-apple-darwin20.4-" \
    AR="/usr/osxcross/bin/aarch64-apple-darwin20.4-ar" \
    LD="/usr/osxcross/bin/aarch64-apple-darwin20.4-ld" \
    RANLIB="/usr/osxcross/bin/aarch64-apple-darwin20.4-ranlib" \
    ./Configure no-apps no-docs no-dso no-dgram darwin64-arm64 --prefix=/opt/openssl --openssldir=/usr/local/ssl && \
    make -j $(nproc)
RUN cd /src/ && cd openssl-* && make install
RUN ls -al /opt/openssl/lib/
WORKDIR /work
