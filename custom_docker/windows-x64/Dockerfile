FROM dockcross/windows-static-x64:latest
ARG DEBIAN_FRONTEND=noninteractive
RUN export DEBIAN_FRONTEND=noninteractive && apt update && apt install -y make yasm wget git \
    coreutils autoconf libtool pkg-config nano
RUN mkdir -p /src/
RUN wget https://github.com/openssl/openssl/releases/download/openssl-3.6.0/openssl-3.6.0.tar.gz -O /src/openssl.tar.gz
#RUN cd /src/ && tar -xzvf openssl.tar.gz && cd openssl-* && \
#    ./Configure no-apps no-docs no-dso no-dgram linux-aarch64 --prefix=/opt/openssl --openssldir=/usr/local/ssl && \
#    ln -s / aarch64-unknown-linux-gnu- && \
#    make -j $(nproc)
#RUN cd /src/ && cd openssl-* && make install
WORKDIR /work
