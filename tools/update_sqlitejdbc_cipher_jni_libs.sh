#! /bin/bash
base_url='https://github.com/zoff99/sqlite-jdbc/releases/download/nightly/'

file_arm64='linux-android-arm64__libsqlitejdbc.so'
file_arm='linux-android-arm__libsqlitejdbc.so'
file_x86='linux-android-x86__libsqlitejdbc.so'
file_x86_64='linux-android-x64__libsqlitejdbc.so'

file_jnilib='libsqlitejdbc.so'

_HOME2_=$(dirname $0)
export _HOME2_
_HOME_=$(cd $_HOME2_;pwd)
export _HOME_

basedir1="$_HOME_""/../src/main/resources/org/sqlite/native/Linux-Android/"
basedir2="$_HOME_""/../example_android//app/nativelibs/"

cd "$basedir1"
wget "$base_url""$file_arm64" -O ./aarch64/"$file_jnilib"
wget "$base_url""$file_arm" -O ./arm/"$file_jnilib"
wget "$base_url""$file_x86" -O ./x86/"$file_jnilib"
wget "$base_url""$file_x86_64" -O ./x86_64/"$file_jnilib"

cp -v "$basedir1"/aarch64/"$file_jnilib" "$basedir2"/arm64-v8a/"$file_jnilib"
cp -v "$basedir1"/arm/"$file_jnilib" "$basedir2"/armeabi-v7a/"$file_jnilib"
cp -v "$basedir1"/x86/"$file_jnilib" "$basedir2"/x86/"$file_jnilib"
cp -v "$basedir1"/x86_64/"$file_jnilib" "$basedir2"/x86_64/"$file_jnilib"
