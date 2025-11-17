#! /bin/bash

url_linux_crypto="https://github.com/zoff99/iocipher_pack/raw/refs/heads/master/002_src_libsqlfs/openssl_libs/libcrypto.a"
url_linux_ssl="https://github.com/zoff99/iocipher_pack/raw/refs/heads/master/002_src_libsqlfs/openssl_libs/libssl.a"

url_win_x86_64_libcrypto='https://github.com/zoff99/iocipher_pack/raw/refs/heads/master/002_src_libsqlfs/openssl_win64_libs/libcrypto.a'
url_win_x86_64_libssl='https://github.com/zoff99/iocipher_pack/raw/refs/heads/master/002_src_libsqlfs/openssl_win64_libs/libssl.a'

_HOME2_=$(dirname $0)
export _HOME2_
_HOME_=$(cd $_HOME2_;pwd)
export _HOME_

basedir="$_HOME_""/../"
cd "$basedir"

mkdir -p "$basedir""/openssl_libs/"
wget "$url_linux_crypto" -O ./openssl_libs/Linux-x86_64/libcrypto.a || exit 1
wget "$url_linux_ssl" -O ./openssl_libs/Linux-x86_64/libssl.a || exit 1

wget https://github.com/zoff99/iocipher_pack/raw/refs/heads/master/003_src_iocipher/libiocipher2-c/src/main/jniLibs/arm64-v8a/libcrypto.a -O ./openssl_libs/android-arm64/libcrypto.a || exit 1
wget https://github.com/zoff99/iocipher_pack/raw/refs/heads/master/003_src_iocipher/libiocipher2-c/src/main/jniLibs/arm64-v8a/libssl.a -O ./openssl_libs/android-arm64/libssl.a || exit 1

wget https://github.com/zoff99/iocipher_pack/raw/refs/heads/master/003_src_iocipher/libiocipher2-c/src/main/jniLibs/armeabi-v7a/libcrypto.a -O ./openssl_libs/android-arm/libcrypto.a || exit 1
wget https://github.com/zoff99/iocipher_pack/raw/refs/heads/master/003_src_iocipher/libiocipher2-c/src/main/jniLibs/armeabi-v7a/libssl.a -O ./openssl_libs/android-arm/libssl.a || exit 1

wget https://github.com/zoff99/iocipher_pack/raw/refs/heads/master/003_src_iocipher/libiocipher2-c/src/main/jniLibs/x86/libcrypto.a -O ./openssl_libs/android-x86/libcrypto.a || exit 1
wget https://github.com/zoff99/iocipher_pack/raw/refs/heads/master/003_src_iocipher/libiocipher2-c/src/main/jniLibs/x86/libssl.a -O ./openssl_libs/android-x86/libssl.a || exit 1

wget https://github.com/zoff99/iocipher_pack/raw/refs/heads/master/003_src_iocipher/libiocipher2-c/src/main/jniLibs/x86_64/libcrypto.a -O ./openssl_libs/android-x86_64/libcrypto.a || exit 1
wget https://github.com/zoff99/iocipher_pack/raw/refs/heads/master/003_src_iocipher/libiocipher2-c/src/main/jniLibs/x86_64/libssl.a -O ./openssl_libs/android-x86_64/libssl.a || exit 1

wget "$url_win_x86_64_libcrypto" -O ./openssl_libs/Windows-x86_64/libcrypto.a
wget "$url_win_x86_64_libssl" -O  ./openssl_libs/Windows-x86_64/libssl.a

mkdir -p "$basedir""/openssl_includes/temp/"
cd "$basedir""/openssl_includes/temp/" || exit 1
git clone https://github.com/zoff99/iocipher_pack || exit 1
cd iocipher_pack/ || exit 1
rm -Rfv "$basedir"/openssl_includes/openssl/
cp -av ./002_src_libsqlfs/openssl_includes/openssl/ "$basedir"/openssl_includes/ || exit 1
cd "$basedir""/openssl_includes/"
rm -Rf ./temp/


cd "$basedir"
