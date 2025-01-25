# FROM xerial/centos5-linux-x86_64
FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive
RUN export DEBIAN_FRONTEND=noninteractive && apt update && apt install -y make yasm wget git coreutils autoconf libtool pkg-config nano
WORKDIR /work
