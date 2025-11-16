#! /bin/bash

_HOME2_=$(dirname "$0")
export _HOME2_
_HOME_=$(cd "$_HOME2_" || exit;pwd)
export _HOME_
echo "$_HOME_"
cd "$_HOME_" || exit

docker build -f Dockerfile -t sqlite-jdbc_windows-static-x64-posix .
pwd
ls -al
docker run --rm sqlite-jdbc_windows-static-x64-posix > ./dockcross-windows-static-x64-posix
chmod +x ./dockcross-windows-static-x64-posix
cd ../../
