SQLite JDBC Driver for Android with SQLCipher included
======================================================

<h3>also works on Linux x86_86 Desktop java now!</h3>

[![Build Native](https://github.com/zoff99/sqlite-jdbc/actions/workflows/build-native.yml/badge.svg)](https://github.com/zoff99/sqlite-jdbc/actions/workflows/build-native.yml)
[![Android Example App](https://github.com/zoff99/sqlite-jdbc/actions/workflows/android_app.yml/badge.svg?branch=android_test)](https://github.com/zoff99/sqlite-jdbc/actions/workflows/android_app.yml)
[![Release](https://jitpack.io/v/zoff99/pkgs_zoffccAndroidJDBC.svg)](https://jitpack.io/#zoff99/pkgs_zoffccAndroidJDBC)
[![Liberapay](https://img.shields.io/liberapay/goal/zoff.svg?logo=liberapay)](https://liberapay.com/zoff/donate)

the Android lib is published on jitpack.io:<br>
https://jitpack.io/#zoff99/pkgs_zoffccAndroidJDBC

currently it works on Android API 21 and above, and on Linux Desktop Java applications.<br>
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

<br>
Any use of this project's code by GitHub Copilot, past or present, is done
without our permission.  We do not consent to GitHub's use of this project's
code in Copilot.
<br>
No part of this work may be used or reproduced in any manner for the purpose of training artificial intelligence technologies or systems.
