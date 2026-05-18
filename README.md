SQLite JDBC Driver with SQLCipher (for Android and Desktop JVM)
---------------------------------------------------------------

This is a fork of https://github.com/xerial/sqlite-jdbc with [`sqlcipher`](https://github.com/sqlcipher/sqlcipher) included.<br>
You can use it as a drop-in replacement in your JVM Desktop or Android project, that gives you an encrypted database.<br>
Best used with [Sorma2](https://github.com/zoff99/sorma2)<br>
<br>

[![Build Native](https://github.com/zoff99/sqlite-jdbc/actions/workflows/build-native.yml/badge.svg)](https://github.com/zoff99/sqlite-jdbc/actions/workflows/build-native.yml)
[![Android Example App](https://github.com/zoff99/sqlite-jdbc/actions/workflows/android_app.yml/badge.svg?branch=android_test)](https://github.com/zoff99/sqlite-jdbc/actions/workflows/android_app.yml)
[![Release](https://jitpack.io/v/zoff99/pkgs_zoffccAndroidJDBC.svg)](https://jitpack.io/#zoff99/pkgs_zoffccAndroidJDBC)
[![Liberapay](https://img.shields.io/liberapay/goal/zoff.svg?logo=liberapay)](https://liberapay.com/zoff/donate)
[![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/zoff99/sqlite-jdbc)

the Android lib is published on jitpack.io:<br>
https://jitpack.io/#zoff99/pkgs_zoffccAndroidJDBC

currently it works on Android API 21 and above, and on Desktop Java applications.<br>
completely removed useless dependency on slf4j [de65785](https://github.com/zoff99/sqlite-jdbc/commit/7e1b07fcab418423c698b3814b9977901e2e441e)

<img src="https://raw.githubusercontent.com/zoff99/sqlite-jdbc/refs/heads/android_test/sqlite-jdbc_coms.png" width="300">

### Automated Screenshots taken from CI

<img src="https://github.com/zoff99/sqlite-jdbc/releases/download/nightly/android_screen01_21.png" height="400"></a>
<img src="https://github.com/zoff99/sqlite-jdbc/releases/download/nightly/android_screen01_29.png" height="400"></a>
<img src="https://github.com/zoff99/sqlite-jdbc/releases/download/nightly/android_screen01_33.png" height="400"></a>
<img src="https://github.com/zoff99/sqlite-jdbc/releases/download/nightly/android_screen01_35.png" height="400"></a>
<br>

### openSSL libs and includes

the libs in<br>
https://github.com/zoff99/sqlite-jdbc/tree/android_test/openssl_libs<br>
and includes in<br>
https://github.com/zoff99/sqlite-jdbc/tree/android_test/openssl_includes/openssl<br>
are updated from<br>
https://github.com/zoff99/iocipher_pack/tree/master/003_src_iocipher/libiocipher2-c/src/main/jniLibs<br>
and<br>
https://github.com/zoff99/iocipher_pack/tree/master/002_src_libsqlfs/openssl_includes/openssl<br>



### Android Example Project
see: https://github.com/zoff99/sqlite-jdbc/tree/android_test/example_android
<br>


### Desktop (Linux / Windows / macOS) Gradle Example Project
see: https://github.com/zoff99/sqlite-jdbc/tree/android_test/example_gradle_linux

add the jitpack.io repository to your build.gradle

```
repositories {
    mavenCentral()
    maven {
        url "https://jitpack.io"
    }
}
```

and add the this library to your dependencies in build.gradle

```
dependencies {
    implementation 'com.github.zoff99:pkgs_zoffcc_sqlite-jdbc-sqlcipher:1.0.26'
}
```

### Linux Desktop Example Project
see: https://github.com/zoff99/sqlite-jdbc/tree/android_test/example_linux

download `sqlite-jdbc-sqlcipher-*.jar` from the github [releases](https://github.com/zoff99/sqlite-jdbc/releases) in this repository<br>
and put it into the `example_linux directory` then run:
```bash
javac Sample.java
jar_file=$(find . -name 'sqlite-jdbc-sqlcipher-*.jar' 2>/dev/null)
java -classpath ".:$jar_file" Sample
```
<br>

<br>
Any use of this project's code by GitHub Copilot, past or present, is done
without our permission.  We do not consent to GitHub's use of this project's
code in Copilot.
<br>
No part of this work may be used or reproduced in any manner for the purpose of training artificial intelligence technologies or systems.
