#! /bin/bash

_HOME2_=$(dirname "$0")
export _HOME2_
_HOME_=$(cd "$_HOME2_" || exit;pwd)
export _HOME_
echo "$_HOME_"
cd "$_HOME_" || exit

cd ../

# remove current libs
echo "remove current libs ..."
rm -f ./src/main/resources/org/sqlite/native/Linux-Android/aarch64/libsqlitejdbc.so \
 ./src/main/resources/org/sqlite/native/Linux-Android/arm/libsqlitejdbc.so \
 ./src/main/resources/org/sqlite/native/Linux-Android/x86/libsqlitejdbc.so \
 ./src/main/resources/org/sqlite/native/Linux-Android/x86_64/libsqlitejdbc.so

make || exit 1

# copy the libs into the android example source
echo "copy the libs into the android example source ..."
cp -v ./src/main/resources/org/sqlite/native/Linux-Android/aarch64/libsqlitejdbc.so ./example_android/app/nativelibs/arm64-v8a/libsqlitejdbc.so
cp -v ./src/main/resources/org/sqlite/native/Linux-Android/arm/libsqlitejdbc.so ./example_android/app/nativelibs/armeabi-v7a/libsqlitejdbc.so
cp -v ./src/main/resources/org/sqlite/native/Linux-Android/x86/libsqlitejdbc.so ./example_android/app/nativelibs/x86/libsqlitejdbc.so
cp -v ./src/main/resources/org/sqlite/native/Linux-Android/x86_64/libsqlitejdbc.so ./example_android/app/nativelibs/x86_64/libsqlitejdbc.so

