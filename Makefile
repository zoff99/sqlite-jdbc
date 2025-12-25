
include Makefile.common

RESOURCE_DIR = src/main/resources

.phony: all package native native-all deploy

all: jni-header package

deploy:
	echo dummy
	# mvn package deploy -DperformRelease=true

DOCKER_RUN_OPTS=--rm
MVN:=mvn
CODESIGN:=docker run $(DOCKER_RUN_OPTS) -v $$PWD:/workdir gotson/rcodesign sign
SRC:=src/main/java
SQLITE_OUT:=$(TARGET)/$(sqlite)-$(OS_NAME)-$(OS_ARCH)
SQLITE_OBJ?=$(SQLITE_OUT)/sqlite3.o
SQLITE_SOURCE?=sqlcipher
SQLITE_HEADER?=$(SQLITE_SOURCE)/sqlite3.h

SQLITE_INCLUDE := $(shell dirname "$(SQLITE_HEADER)")

ismingw = 0
ccmachine = $(shell $(CC) -dumpmachine)
$(info ccmachine: $(ccmachine))
ifeq ($(findstring mingw, $(ccmachine)), mingw)
$(info ########### mingw CCFLAGS ###########)
	ismingw = 1
	CCFLAGS:= -I$(SQLITE_OUT) -I$(SQLITE_INCLUDE) $(CCFLAGS) -lwsock32 -Wl,-kill-at
	CCFLAGS += -l:libiphlpapi.a -Wl,-Bstatic -lcrypt32 -Wl,-Bstatic -lws2_32
	LINKFLAGS:= -lwsock32 -l:libiphlpapi.a -Wl,-Bstatic -lcrypt32 -Wl,-Bstatic -lws2_32 $(LINKFLAGS)
	CC="x86_64-w64-mingw32-gcc"
	AR="x86_64-w64-mingw32-ar"
else ifeq ($(findstring apple, $(ccmachine)), apple)
$(info ########### APPLE CCFLAGS ###########)
    CCFLAGS:= -I$(SQLITE_OUT) -I$(SQLITE_INCLUDE) $(CCFLAGS)
else
$(info ########### default CCFLAGS ###########)
	CCFLAGS:= -I$(SQLITE_OUT) -I$(SQLITE_INCLUDE) $(CCFLAGS)
endif


$(TARGET)/common-lib/org/sqlite/%.class: src/main/java/org/sqlite/%.java
	@mkdir -p $(@D)
	echo "java classes are now in example_android directory"
	echo __DUMMY__ $(JAVAC) -source 1.6 -target 1.6 -sourcepath $(SRC) -d $(TARGET)/common-lib $<

jni-header: $(TARGET)/common-lib/NativeDB.h

$(TARGET)/common-lib/NativeDB.h: src/main/java/org/sqlite/core/NativeDB.java
	@mkdir -p $(TARGET)/common-lib
	$(JAVAC) -d $(TARGET)/common-lib -sourcepath $(SRC) -h $(TARGET)/common-lib src/main/java/org/sqlite/core/NativeDB.java
	mv target/common-lib/org_sqlite_core_NativeDB.h target/common-lib/NativeDB.h

test:
	mvn test

clean: clean-native clean-java clean-tests


$(SQLITE_OUT)/sqlite3.o : $(SQLITE_UNPACKED)
	@mkdir -p $(@D)
	ls -al openssl_libs/$(OS_NAME)-$(OS_ARCH)/libssl.a openssl_libs/$(OS_NAME)-$(OS_ARCH)/libcrypto.a
	perl -p -e "s/sqlite3_api;/sqlite3_api = 0;/g" \
	    $(SQLITE_SOURCE)/sqlite3ext.h > $(SQLITE_OUT)/sqlite3ext.h
# insert a code for loading extension functions
	perl -p -e "s/^opendb_out:/  if(!db->mallocFailed && rc==SQLITE_OK){ rc = RegisterExtensionFunctions(db); }\nopendb_out:/;" \
	    $(SQLITE_SOURCE)/sqlite3.c > $(SQLITE_OUT)/sqlite3.c.tmp
# register compile option 'JDBC_EXTENSIONS'
# limits defined here: https://www.sqlite.org/limits.html
	perl -p -e "s/^(static const char \* const sqlite3azCompileOpt.+)$$/\1\n\n\/* This has been automatically added by sqlite-jdbc *\/\n  \"JDBC_EXTENSIONS\",/;" \
	    $(SQLITE_OUT)/sqlite3.c.tmp > $(SQLITE_OUT)/sqlite3.c
	cat src/main/ext/*.c >> $(SQLITE_OUT)/sqlite3.c
	$(CC) -o $@ -c $(CCFLAGS) \
	    -DHAVE_STDINT_H -DSQLITE_HAS_CODEC -DHAVE_LIBSQLCIPHER -DSQLCIPHER_CRYPTO_OPENSSL -DSQLITE_TEMP_STORE=2 -I./openssl_includes \
	    -DSQLITE_EXTRA_INIT=sqlcipher_extra_init -DSQLITE_EXTRA_SHUTDOWN=sqlcipher_extra_shutdown \
	    -DSQLITE_DEFAULT_WAL_SYNCHRONOUS=1 -DSQLITE_DEFAULT_JOURNAL_SIZE_LIMIT=1048576 -DSQLITE_ENABLE_STAT3 \
	    -DSQLITE_ENABLE_PREUPDATE_HOOK \
	    -DSQLITE_ENABLE_LOAD_EXTENSION=1 \
	    -DSQLITE_HAVE_ISNAN \
	    -DHAVE_USLEEP=1 \
	    -DSQLITE_ENABLE_COLUMN_METADATA \
	    -DSQLITE_CORE \
	    -DSQLITE_ENABLE_FTS3 \
	    -DSQLITE_ENABLE_FTS3_PARENTHESIS \
	    -DSQLITE_ENABLE_FTS5 \
	    -DSQLITE_ENABLE_RTREE \
	    -DSQLITE_ENABLE_PERCENTILE \
	    -DSQLITE_ENABLE_STAT4 \
	    -DSQLITE_ENABLE_DBSTAT_VTAB \
	    -DSQLITE_ENABLE_MATH_FUNCTIONS \
	    -DSQLITE_THREADSAFE=1 \
	    -DSQLITE_DEFAULT_MEMSTATUS=0 \
	    -DSQLITE_DEFAULT_FILE_PERMISSIONS=0666 \
	    -DSQLITE_MAX_VARIABLE_NUMBER=250000 \
	    -DSQLITE_MAX_MMAP_SIZE=1099511627776 \
	    -DSQLITE_MAX_LENGTH=2147483647 \
	    -DSQLITE_MAX_COLUMN=32767 \
	    -DSQLITE_MAX_SQL_LENGTH=1073741824 \
	    -DSQLITE_MAX_FUNCTION_ARG=127 \
	    -DSQLITE_MAX_ATTACHED=125 \
	    -DSQLITE_MAX_PAGE_COUNT=4294967294 \
	    -DSQLITE_DISABLE_PAGECACHE_OVERFLOW_STATS \
	    $(SQLITE_FLAGS) \
	    $(SQLITE_OUT)/sqlite3.c

$(SQLITE_SOURCE)/sqlite3.h: $(SQLITE_UNPACKED)

$(SQLITE_OUT)/$(LIBNAME): $(SQLITE_HEADER) $(SQLITE_OBJ) $(SRC)/org/sqlite/core/NativeDB.c $(TARGET)/common-lib/NativeDB.h
	@mkdir -p $(@D)
	$(CC) $(CCFLAGS) -I $(TARGET)/common-lib -c -o $(SQLITE_OUT)/NativeDB.o $(SRC)/org/sqlite/core/NativeDB.c
	$(CC) $(CCFLAGS) -o $@ $(SQLITE_OUT)/NativeDB.o $(SQLITE_OBJ) openssl_libs/$(OS_NAME)-$(OS_ARCH)/libssl.a openssl_libs/$(OS_NAME)-$(OS_ARCH)/libcrypto.a -lm  $(LINKFLAGS)
# Workaround for strip Protocol error when using VirtualBox on Mac
	cp $@ /tmp/$(@F)
	# DO NOT STRIP # $(STRIP) /tmp/$(@F)
	cp /tmp/$(@F) $@

NATIVE_DIR=src/main/resources/org/sqlite/native/$(OS_NAME)/$(OS_ARCH)
NATIVE_TARGET_DIR:=$(TARGET)/classes/org/sqlite/native/$(OS_NAME)/$(OS_ARCH)
NATIVE_DLL:=$(NATIVE_DIR)/$(LIBNAME)

# For cross-compilation, install docker. See also https://github.com/dockcross/dockcross
native-all: linux-android-arm linux-android-arm64 linux-android-x86 linux-android-x64 linux64 linux-arm64 win64 mac64 mac-arm64
			# win-arm64

native: $(NATIVE_DLL)

$(NATIVE_DLL): $(SQLITE_OUT)/$(LIBNAME)
	@mkdir -p $(@D)
	cp $< $@
	@mkdir -p $(NATIVE_TARGET_DIR)
	cp $< $(NATIVE_TARGET_DIR)/$(LIBNAME)


## ------ Android ------
linux-android-arm: $(SQLITE_UNPACKED) jni-header
	./custom_docker/android-arm/do.sh
	pwd
	./custom_docker/android-arm/dockcross-android-arm -i sqlite-jdbc_and_arm -a $(DOCKER_RUN_OPTS) bash -c 'make clean-native native CROSS_PREFIX=/usr/arm-linux-androideabi/bin/arm-linux-androideabi- OS_NAME=Linux-Android OS_ARCH=arm'

linux-android-arm64: $(SQLITE_UNPACKED) jni-header
	./custom_docker/android-arm64/do.sh
	pwd
	./custom_docker/android-arm64/dockcross-android-arm64 -i sqlite-jdbc_and_arm64 -a $(DOCKER_RUN_OPTS) bash -c 'make clean-native native CROSS_PREFIX=/usr/aarch64-linux-android/bin/aarch64-linux-android- OS_NAME=Linux-Android OS_ARCH=aarch64'

linux-android-x86: $(SQLITE_UNPACKED) jni-header
	./custom_docker/android-x86/do.sh
	pwd
	./custom_docker/android-x86/dockcross-android-x86 -i sqlite-jdbc_and_x86 -a $(DOCKER_RUN_OPTS) bash -c 'make clean-native native CROSS_PREFIX=/usr/i686-linux-android/bin/i686-linux-android- OS_NAME=Linux-Android OS_ARCH=x86'

linux-android-x64: $(SQLITE_UNPACKED) jni-header
	./custom_docker/android-x86_64/do.sh
	pwd
	./custom_docker/android-x86_64/dockcross-android-x86_64 -i sqlite-jdbc_and_x86_64 -a $(DOCKER_RUN_OPTS) bash -c 'make clean-native native CROSS_PREFIX=/usr/x86_64-linux-android/bin/x86_64-linux-android- OS_NAME=Linux-Android OS_ARCH=x86_64'
## ------ Android ------


## ------ Linux ------
linux64: $(SQLITE_UNPACKED) jni-header
	./custom_docker/linux64/do.sh
	pwd
	docker run $(DOCKER_RUN_OPTS) -v $$PWD:/work -i sqlite-jdbc_lin_x86_64 bash -c 'make clean-native native OS_NAME=Linux OS_ARCH=x86_64 && chmod -R a+w ./target/*-Linux-x86_64 ./target/classes/org/sqlite/native/'

linux-arm64: $(SQLITE_UNPACKED) jni-header
	./custom_docker/linux64-arm64/do.sh
	pwd
	./custom_docker/linux64-arm64/dockcross-linux-arm64 -i sqlite-jdbc_linux_arm64 -a $(DOCKER_RUN_OPTS) bash -c 'pwd; make clean-native native CROSS_PREFIX=aarch64-unknown-linux-gnu- OS_NAME=Linux OS_ARCH=aarch64'
## ------ Linux ------

## ------ macOS ------
mac64: $(SQLITE_UNPACKED) jni-header
	./custom_docker/macos64/do.sh
	pwd
	docker run $(DOCKER_RUN_OPTS) -v $$PWD:/work -i sqlite-jdbc_macos64 \
	bash -c 'make clean-native native OS_NAME=Mac OS_ARCH=x86_64 CC="/usr/osxcross/bin/x86_64-apple-darwin14-cc" CROSS_PREFIX="/usr/osxcross/bin/x86_64-apple-darwin14-" && chmod -R a+w ./target/*-Mac-x86_64 ./target/classes/org/sqlite/native/'

mac-arm64: $(SQLITE_UNPACKED) jni-header
	./custom_docker/macos-arm64/do.sh
	pwd
	docker run $(DOCKER_RUN_OPTS) -v $$PWD:/work -i sqlite-jdbc_macos_arm64 \
	bash -c 'make clean-native native OS_NAME=Mac OS_ARCH=aarch64 CC="/usr/osxcross/bin/aarch64-apple-darwin20.4-cc" CROSS_PREFIX="/usr/osxcross/bin/aarch64-apple-darwin20.4-" && chmod -R a+w ./target/*-Mac-aarch64 ./target/classes/org/sqlite/native/'
## ------ macOS ------


## ------ Windows ------
win64: $(SQLITE_UNPACKED) jni-header
	./custom_docker/windows-x64/do.sh
	pwd
	docker run $(DOCKER_RUN_OPTS) -v $$PWD:/work -i sqlite-jdbc_windows-static-x64-posix bash -c 'pwd; env|grep CC ; make clean-native native CROSS_PREFIX=x86_64-w64-mingw32- OS_NAME=Windows OS_ARCH=x86_64'

#win-arm64: $(SQLITE_UNPACKED) jni-header
#	./docker/dockcross-windows-arm64 -a $(DOCKER_RUN_OPTS) bash -c 'make clean-native native CROSS_PREFIX=aarch64-w64-mingw32- OS_NAME=Windows OS_ARCH=aarch64'
## ------ Windows ------


package: native-all
	echo "dummy"
	rm -rf target/dependency-maven-plugin-markers
	$(MVN) package -Dmaven.test.skip

clean-native:
	rm -rf $(SQLITE_OUT)

clean-java:
	rm -rf $(TARGET)/*classes
	rm -rf $(TARGET)/common-lib/*
	rm -rf $(TARGET)/sqlite-*

clean-tests:
	rm -rf $(TARGET)/{surefire*,testdb.jar*}

