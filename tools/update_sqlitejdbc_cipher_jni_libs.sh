#! /bin/bash

base_url='https://github.com/zoff99/sqlite-jdbc/releases/download/nightly/'

file_arm64='linux-android-arm64__libsqlitejdbc.so'
file_arm='linux-android-arm__libsqlitejdbc.so'
file_x86='linux-android-x86__libsqlitejdbc.so'
file_x86_64='linux-android-x64__libsqlitejdbc.so'

file_linux_x86_64='linux64__libsqlitejdbc.so'
file_linux_arm64='linux-arm64__libsqlitejdbc.so'
file_win_x86_64='win64__libsqlitejdbc.so'
file_macos_arm64='mac-arm64__libsqlitejdbc.so'

file_jnilib='libsqlitejdbc.so'
file_win_jnilib='sqlitejdbc.dll'
file_macos_jnilib='libsqlitejdbc.dylib'

_HOME2_=$(dirname $0)
export _HOME2_
_HOME_=$(cd $_HOME2_;pwd)
export _HOME_

basedir1="$_HOME_""/../src/main/resources/org/sqlite/native/Linux-Android/"
basedir2="$_HOME_""/../example_android/androidjdbc/nativelibs/"
basedir3="$_HOME_""/../src/main/resources/org/sqlite/native/Linux/x86_64/"
basedir4="$_HOME_""/../src/main/resources/org/sqlite/native/Windows/x86_64/"
basedir5="$_HOME_""/../src/main/resources/org/sqlite/native/Linux/aarch64/"
basedir6="$_HOME_""/../src/main/resources/org/sqlite/native/Mac/aarch64/"

mkdir -p "$basedir1"
mkdir -p "$basedir2"
mkdir -p "$basedir3"

cd "$basedir1"

mkdir -p ./aarch64/
mkdir -p ./arm/
mkdir -p ./x86/
mkdir -p ./x86_64/

wget "$base_url""$file_arm64" -O ./aarch64/"$file_jnilib"
wget "$base_url""$file_arm" -O ./arm/"$file_jnilib"
wget "$base_url""$file_x86" -O ./x86/"$file_jnilib"
wget "$base_url""$file_x86_64" -O ./x86_64/"$file_jnilib"


cd "$basedir3"
wget "$base_url""$file_linux_x86_64" -O ./"$file_jnilib"

cd "$basedir4"
wget "$base_url""$file_win_x86_64" -O ./"$file_win_jnilib"

cd "$basedir5"
wget "$base_url""$file_linux_arm64" -O ./"$file_jnilib"

cd "$basedir6"
wget "$base_url""$file_macos_arm64" -O ./"$file_macos_jnilib"

cd "$basedir1"

mkdir -p "$basedir2"/arm64-v8a/
mkdir -p "$basedir2"/armeabi-v7a/
mkdir -p "$basedir2"/x86/
mkdir -p "$basedir2"/x86_64/

cp -v "$basedir1"/aarch64/"$file_jnilib" "$basedir2"/arm64-v8a/"$file_jnilib"
cp -v "$basedir1"/arm/"$file_jnilib" "$basedir2"/armeabi-v7a/"$file_jnilib"
cp -v "$basedir1"/x86/"$file_jnilib" "$basedir2"/x86/"$file_jnilib"
cp -v "$basedir1"/x86_64/"$file_jnilib" "$basedir2"/x86_64/"$file_jnilib"

