#! /bin/bash

docker build -f Dockerfile -t sqlite-jdbc_and_x86_64 .
docker run --rm sqlite-jdbc_and_x86_64 > ./dockcross-android-x86_64
chmod +x ./dockcross-android-x86_64
