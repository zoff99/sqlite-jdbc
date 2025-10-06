#! /bin/bash

_HOME2_=$(dirname $0)
export _HOME2_
_HOME_=$(cd $_HOME2_;pwd)
export _HOME_

basedir="$_HOME_""/"
cd "$basedir"
pwd

rm -f *.db
java -classpath ".:sqlite-jdbc-sqlicpher-1.0.12.jar" Sample || exit 1

