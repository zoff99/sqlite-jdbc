FROM dockcross/linux-arm64:latest
# FROM arm64v8/ubuntu:24.04
ARG DEBIAN_FRONTEND=noninteractive
RUN export DEBIAN_FRONTEND=noninteractive && apt update && apt install -y make yasm wget git \
    coreutils autoconf libtool pkg-config nano
RUN mkdir -p /src/
RUN wget https://raw.githubusercontent.com/zoff99/iocipher_pack/refs/heads/master/000_deps/openssl.tar.gz -O /tmp/file.txt && \
    wget https://github.com/zoff99/iocipher_pack/raw/refs/heads/master/000_deps/"$(cat /tmp/file.txt 2>/dev/null)" -O /src/openssl.tar.gz && \
    rm -f /tmp/file.txt
RUN cd /src/ && tar -xzvf openssl.tar.gz && cd openssl-* && \
    ./Configure no-apps no-docs no-dso no-dgram linux-aarch64 --prefix=/opt/openssl --openssldir=/usr/local/ssl && \
    ln -s / aarch64-unknown-linux-gnu- && \
    make -j $(nproc)
RUN cd /src/ && cd openssl-* && make install
WORKDIR /work
