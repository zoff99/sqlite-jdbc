FROM multiarch/crossbuild
ARG DEBIAN_FRONTEND=noninteractive
RUN mkdir -p /src/
RUN wget https://raw.githubusercontent.com/zoff99/iocipher_pack/refs/heads/master/000_deps/openssl.tar.gz -O /tmp/file.txt && \
    wget https://github.com/zoff99/iocipher_pack/raw/refs/heads/master/000_deps/"$(cat /tmp/file.txt 2>/dev/null)" -O /src/openssl.tar.gz && \
    rm -f /tmp/file.txt
RUN cd /src/ && tar -xzvf openssl.tar.gz && cd openssl-* && \
    CROSS_TRIPLE=x86_64-apple-darwin \
    CC="/usr/osxcross/bin/x86_64-apple-darwin14-cc" CROSS_PREFIX="/usr/osxcross/bin/x86_64-apple-darwin14-cc-" \
    AR="/usr/osxcross/bin/x86_64-apple-darwin14-ar" \
    LD="/usr/osxcross/bin/x86_64-apple-darwin14-ld" \
    RANLIB="/usr/osxcross/bin/x86_64-apple-darwin14-ranlib" \
    ./Configure no-apps no-docs no-dso no-dgram darwin64-x86_64 --prefix=/opt/openssl --openssldir=/usr/local/ssl && \
    make -j $(nproc)
RUN cd /src/ && cd openssl-* && make install
RUN ls -al /opt/openssl/lib/
WORKDIR /work
