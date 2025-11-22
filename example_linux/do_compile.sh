#! /bin/bash

_HOME2_=$(dirname $0)
export _HOME2_
_HOME_=$(cd $_HOME2_;pwd)
export _HOME_

basedir="$_HOME_""/"
cd "$basedir" || exit 1
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

cd "$basedir" || exit 1

rm -Rf _jar/
mkdir _jar/ || exit 1
cd _jar/ || exit 1


echo "create jar artefact"

cp -a ../_android/android . || exit 1
## not needed for desktop java ## cp -av ../../example_android/androidjdbc/src/main/java/java .
cp -a ../../example_android/androidjdbc/src/main/java/org . || exit 1

find . -name '*.java' | xargs -L10000 javac -nowarn || exit 1
find . -name '*.java' | xargs -L10000 rm

mkdir -p META-INF
echo 'Manifest-Version: 1.0
Bundle-Description: SQLite JDBC library (jdbcjni)
Bundle-Name: SQLite JDBC (jdbcjni)
Built-By: Zoff' > META-INF/MANIFEST.MF || exit 1

mkdir -p META-INF/services/
echo 'org.sqlite.JDBC' > META-INF/services/java.sql.Driver || exit 1



mkdir -p org/sqlite/native/Linux/x86_64
cp -av ../../src/main/resources/org/sqlite/native/Linux/x86_64/libsqlitejdbc.so org/sqlite/native/Linux/x86_64/libsqlitejdbc.so || exit 1

mkdir -p org/sqlite/native/Linux/aarch64
cp -av ../../src/main/resources/org/sqlite/native/Linux/aarch64/libsqlitejdbc.so org/sqlite/native/Linux/aarch64/libsqlitejdbc.so || exit 1

mkdir -p org/sqlite/native/Windows/x86_64
cp -av ../../src/main/resources/org/sqlite/native/Windows/x86_64/sqlitejdbc.dll org/sqlite/native/Windows/x86_64/sqlitejdbc.dll || exit 1

mkdir -p org/sqlite/native/Mac/aarch64
cp -av ../../src/main/resources/org/sqlite/native/Mac/aarch64/libsqlitejdbc.dylib org/sqlite/native/Mac/aarch64/libsqlitejdbc.dylib || exit 1

mkdir -p org/sqlite/native/Mac/x86_64
cp -av ../../src/main/resources/org/sqlite/native/Mac/x86_64/libsqlitejdbc.dylib org/sqlite/native/Mac/x86_64/libsqlitejdbc.dylib || exit 1


jar cmvf META-INF/MANIFEST.MF ../sqlite-jdbc-sqlcipher-"$cur_str_version".jar . || exit 1

cd ../
ls -al sqlite-jdbc-sqlcipher-"$cur_str_version".jar || exit 1
ls -hal sqlite-jdbc-sqlcipher-"$cur_str_version".jar || exit 1

echo "create maven artefact"

rm -Rf /.m2/

mvn install:install-file \
  -Dfile=sqlite-jdbc-sqlcipher-"$cur_str_version".jar \
  -DgroupId=com.zoffcc.applications.sqlitejdbc \
  -DartifactId=sqlite-jdbc-sqlcipher \
  -Dversion="$cur_str_version" \
  -Dpackaging=jar \
  -DlocalRepositoryPath="$basedir"/../example_linux/.m2/repository/ \
  -DgeneratePom=true

rm -f local_maven_sqlitejdbc_*.zip
zip -r local_maven_sqlitejdbc_"$cur_str_version".zip ./.m2 || exit 1

ls -al local_maven_sqlitejdbc_"$cur_str_version".zip || exit 1
ls -hal local_maven_sqlitejdbc_"$cur_str_version".zip || exit 1
