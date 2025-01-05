#! /bin/bash

_HOME2_=$(dirname "$0")
export _HOME2_
_HOME_=$(cd "$_HOME2_" || exit;pwd)
export _HOME_
echo "$_HOME_"
cd "$_HOME_" || exit

docker build -f Dockerfile -t sqlite-jdbc_and_arm64 .
pwd
ls -al
docker run --rm sqlite-jdbc_and_arm64 > ./dockcross-android-arm64
chmod +x ./dockcross-android-arm64
