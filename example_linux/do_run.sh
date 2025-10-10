#! /bin/bash

_HOME2_=$(dirname $0)
export _HOME2_
_HOME_=$(cd $_HOME2_;pwd)
export _HOME_

basedir="$_HOME_""/"
cd "$basedir"
pwd

rm -f *.db
javac Sample.java || exit 1
jar_file=$(find . -name 'sqlite-jdbc-sqlcipher-*.jar' 2>/dev/null|grep -v '.m2' 2>/dev/null)
echo "found jar: ""$jar_file"
java -classpath ".:$jar_file" Sample || exit 1

