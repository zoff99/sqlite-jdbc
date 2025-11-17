#! /bin/bash

_HOME2_=$(dirname $0)
export _HOME2_
_HOME_=$(cd $_HOME2_;pwd)
export _HOME_

basedir="$_HOME_""/../"

f1="example_android/androidjdbc/build.gradle"
f2="example_android/androidjdbc/src/main/java/com/zoffcc/applications/androidjdbc/BuildConfig.java"
f3='example_gradle_linux/app/build.gradle'

cd "$basedir"

if [[ $(git status --porcelain --untracked-files=no) ]]; then
	echo "ERROR: git repo has changes."
	echo "please commit or cleanup the git repo."
	exit 1
else
	echo "git repo clean."
fi

cur_p_version=$(cat "$f1" | grep 'versionCode ' | head -1 | \
	sed -e 's#^.*versionCode ##' )
cur_m_version=$(cat "$f1" | grep 'versionName "' | head -1 | \
	sed -e 's#^.*versionName "##' | \
	sed -e 's#".*$##')

next_p_version=$[ $cur_p_version + 1 ]
# thanks to: https://stackoverflow.com/a/8653732
next_m_version=$(echo "$cur_m_version"|awk -F. -v OFS=. 'NF==1{print ++$NF}; NF>1{if(length($NF+1)>length($NF))$(NF-1)++; $NF=sprintf("%0*d", length($NF), ($NF+1)%(10^length($NF))); print}')

echo $cur_p_version
echo $next_p_version

echo $cur_m_version
echo $next_m_version

sed -i -e 's#versionCode .*#versionCode '"$next_p_version"'#g' "$f1"
sed -i -e 's#versionName ".*#versionName "'"$next_m_version"'"#g' "$f1"

sed -i -e 's#public static final int VERSION_CODE = .*$#public static final int VERSION_CODE = '"$next_p_version"';#g' "$f2"
sed -i -e 's#public static final String VERSION_NAME = ".*$#public static final String VERSION_NAME = "'"$next_m_version"'";#g' "$f2"

sed -i -e 's#pkgs_zoffcc_sqlite-jdbc-sqlcipher:.*#pkgs_zoffcc_sqlite-jdbc-sqlcipher:'"$next_m_version""'"'#g' "$f3"

commit_message="jni ""$next_m_version"
tag_name="jdbcjni""$next_m_version"

git commit -m "$commit_message" "$f1" "$f2" "$f3"
## do not tag yet ## git tag -a "$tag_name" -m "$tag_name"
