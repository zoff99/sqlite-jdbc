#! /bin/bash


_HOME2_=$(dirname $0)
export _HOME2_
_HOME_=$(cd $_HOME2_;pwd)
export _HOME_

basedir="$_HOME_""/../"
cd "$basedir"

cd example_android/
./gradlew assembleRelease || exit 1

cd "$basedir"
ls -al ./example_android/androidjdbc/build/outputs/aar/androidjdbc-release.aar || exit 1



cd "$basedir"
f1="example_android/androidjdbc/build.gradle"

cur_num_version=$(cat "$f1" | grep 'versionCode ' | head -1 | \
	sed -e 's#^.*versionCode ##' )
cur_str_version=$(cat "$f1" | grep 'versionName "' | head -1 | \
	sed -e 's#^.*versionName "##' | \
	sed -e 's#".*$##')

echo "$cur_num_version"
echo "$cur_str_version"



cd "$basedir"/example_android/ || exit 1

rm -Rf ./stub_work/
cp -a ./stub/ ./stub_work/ || exit 1
cd ./stub_work/root/.m2/repository/com/zoffcc/applications/androidjdbc/AndroidJDBC/ || exit 1
sed -i -e 's#1.0.0#'"$cur_str_version"'#' maven-metadata-local.xml || exit 1
mv -v 1.0.0 "$cur_str_version" || exit 1
cd ./"$cur_str_version"/ || exit 1
mv -v AndroidJDBC-1.0.0.pom AndroidJDBC-"$cur_str_version".pom || exit 1
sed -i -e 's#1.0.0#'"$cur_str_version"'#' AndroidJDBC-"$cur_str_version".pom || exit 1

echo "copy aar file into maven repository"
cp -av "$basedir"/example_android/androidjdbc/build/outputs/aar/androidjdbc-release.aar ./AndroidJDBC-"$cur_str_version".aar || exit 1

cd "$basedir"/example_android/ || exit 1
cd ./stub_work/root/ || exit 1
zip -r ../local_maven.zip ./.m2 || exit 1
zip -r ../local_maven_androidjdbc_"$cur_str_version".zip ./.m2 || exit 1

# ls -1 ./003_src_iocipher/stub_work/local_maven_androidjdbc_"$cur_str_version".zip

echo "====== maven repository: OK ======"



