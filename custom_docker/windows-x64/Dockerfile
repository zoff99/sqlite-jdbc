FROM ubuntu:22.04
ARG DEBIAN_FRONTEND=noninteractive
RUN export DEBIAN_FRONTEND=noninteractive && apt update && apt install -y make yasm wget git \
    coreutils autoconf libtool pkg-config nano
RUN DEBIAN_FRONTEND=noninteractive \
          apt-get install -y --no-install-recommends \
          wine libwine-dev libwine wine64 wine64-tools \
          make wget git coreutils autoconf \
          libtool pkg-config gcc-mingw-w64-x86-64 \
          gcc-mingw-w64-x86-64 g++-mingw-w64-x86-64 binutils-mingw-w64-x86-64 \
          mingw-w64-tools pkg-config-mingw-w64-x86-64 \
          mingw-w64-x86-64-dev

WORKDIR /work
