#! /bin/bash

_HOME2_=$(dirname $0)
export _HOME2_
_HOME_=$(cd $_HOME2_;pwd)
export _HOME_

basedir="$_HOME_""/"
cd "$basedir"
pwd

## get current version ------------------------
f1="$basedir"/../"example_android/androidjdbc/build.gradle"
cur_num_version=$(cat "$f1" | grep 'versionCode ' | head -1 | \
	sed -e 's#^.*versionCode ##' )
cur_str_version=$(cat "$f1" | grep 'versionName "' | head -1 | \
	sed -e 's#^.*versionName "##' | \
	sed -e 's#".*$##')
echo "$cur_num_version"
echo "$cur_str_version"
## get current version ------------------------

cd "$basedir"

rm -Rf _jar/
mkdir _jar/
cd _jar/

cp -a ../_android/android .
## not needed for desktop java ## cp -av ../../example_android/androidjdbc/src/main/java/java .
cp -a ../../example_android/androidjdbc/src/main/java/org .

find . -name '*.java' | xargs -L10000 javac -nowarn || exit 1
find . -name '*.java' | xargs -L10000 rm

mkdir -p META-INF
echo 'Manifest-Version: 1.0
Bundle-Description: SQLite JDBC library (jdbcjni)
Bundle-Name: SQLite JDBC (jdbcjni)
Built-By: Zoff' > META-INF/MANIFEST.MF

mkdir -p META-INF/services/
echo 'org.sqlite.JDBC' > META-INF/services/java.sql.Driver

mkdir -p org/sqlite/native/Linux/x86_64
cp -av ../../src/main/resources/org/sqlite/native/Linux/x86_64/libsqlitejdbc.so org/sqlite/native/Linux/x86_64/libsqlitejdbc.so

jar cmvf META-INF/MANIFEST.MF ../sqlite-jdbc-sqlcipher-"$cur_str_version".jar .

cd ../
ls -al sqlite-jdbc-sqlcipher-"$cur_str_version".jar
ls -hal sqlite-jdbc-sqlcipher-"$cur_str_version".jar
