#! /bin/bash

upstream_url="https://github.com/xerial/sqlite-jdbc"


_HOME2_=$(dirname $0)
export _HOME2_
_HOME_=$(cd $_HOME2_;pwd)
export _HOME_

basedir="$_HOME_""/../"
cd "$basedir"


git remote add upstream "$upstream_url" >/dev/null 2> /dev/null
git fetch upstream >/dev/null 2> /dev/null
git log --pretty=oneline --abbrev-commit android_test..upstream/master

changes=$(git log --pretty=oneline --abbrev-commit android_test..upstream/master 2>/dev/null | wc -l 2>/dev/null)
if [ "$changes""x" != "0x" ]; then
    echo "Number of new commits in upstream: $changes"
    exit 1
fi

