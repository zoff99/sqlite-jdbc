
include Makefile.common

RESOURCE_DIR = src/main/resources

.phony: all package native native-all deploy

all: jni-header package

deploy: 
	mvn package deploy -DperformRelease=true

DOCKER_RUN_OPTS=--rm
MVN:=mvn
CODESIGN:=docker run $(DOCKER_RUN_OPTS) -v $$PWD:/workdir gotson/rcodesign sign
SRC:=src/main/java
SQLITE_OUT:=$(TARGET)/$(sqlite)-$(OS_NAME)-$(OS_ARCH)
SQLITE_OBJ?=$(SQLITE_OUT)/sqlite3.o
SQLITE_ARCHIVE:=$(TARGET)/$(sqlite)-amal.zip
SQLITE_UNPACKED:=$(TARGET)/sqlite-unpack.log
SQLITE_SOURCE?=$(TARGET)/$(SQLITE_AMAL_PREFIX)
SQLITE_HEADER?=$(SQLITE_SOURCE)/sqlite3.h
ifneq ($(SQLITE_SOURCE),$(TARGET)/$(SQLITE_AMAL_PREFIX))
	created := $(shell touch $(SQLITE_UNPACKED))
endif

SQLITE_INCLUDE := $(shell dirname "$(SQLITE_HEADER)")

CCFLAGS:= -I$(SQLITE_OUT) -I$(SQLITE_INCLUDE) $(CCFLAGS)

$(SQLITE_ARCHIVE):
	@mkdir -p $(@D)
	mkdir -p $(SQLITE_SOURCE)/
	curl -L https://github.com/zoff99/gen_sqlcipher_amalgamation/releases/download/nightly/sqlite3.c --output $(SQLITE_SOURCE)/sqlite3.c
	curl -L https://github.com/zoff99/gen_sqlcipher_amalgamation/releases/download/nightly/sqlite3.h --output $(SQLITE_SOURCE)/sqlite3.h
	curl -L https://github.com/zoff99/gen_sqlcipher_amalgamation/releases/download/nightly/sqlite3ext.h --output $(SQLITE_SOURCE)/sqlite3ext.h

$(SQLITE_UNPACKED): $(SQLITE_ARCHIVE)
	pwd
	echo $@
	touch $@

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
	    -DSQLITE_HAS_CODEC -DHAVE_LIBSQLCIPHER -DSQLCIPHER_CRYPTO_OPENSSL -DSQLITE_TEMP_STORE=2 -I./openssl_includes \
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
native-all: linux-android-arm linux-android-arm64 linux-android-x86 linux-android-x64

native: $(NATIVE_DLL)

$(NATIVE_DLL): $(SQLITE_OUT)/$(LIBNAME)
	@mkdir -p $(@D)
	cp $< $@
	@mkdir -p $(NATIVE_TARGET_DIR)
	cp $< $(NATIVE_TARGET_DIR)/$(LIBNAME)

linux-android-arm: $(SQLITE_UNPACKED) jni-header
	./custom_docker/android-arm/do.sh
	./custom_docker/dockcross-android-arm -i sqlite-jdbc_and_arm -a $(DOCKER_RUN_OPTS) bash -c 'make clean-native native CROSS_PREFIX=/usr/arm-linux-androideabi/bin/arm-linux-androideabi- OS_NAME=Linux-Android OS_ARCH=arm'

linux-android-arm64: $(SQLITE_UNPACKED) jni-header
	./custom_docker/android-arm64/do.sh
	./custom_docker/dockcross-android-arm64 -i sqlite-jdbc_and_arm64 -a $(DOCKER_RUN_OPTS) bash -c 'make clean-native native CROSS_PREFIX=/usr/aarch64-linux-android/bin/aarch64-linux-android- OS_NAME=Linux-Android OS_ARCH=aarch64'

linux-android-x86: $(SQLITE_UNPACKED) jni-header
	./custom_docker/android-x86/do.sh
	./custom_docker/dockcross-android-x86 -i sqlite-jdbc_and_x86 -a $(DOCKER_RUN_OPTS) bash -c 'make clean-native native CROSS_PREFIX=/usr/i686-linux-android/bin/i686-linux-android- OS_NAME=Linux-Android OS_ARCH=x86'

linux-android-x64: $(SQLITE_UNPACKED) jni-header
	./custom_docker/android-x86_64/do.sh
	./custom_docker/dockcross-android-x86_64 -i sqlite-jdbc_and_x86_64 -a $(DOCKER_RUN_OPTS) bash -c 'make clean-native native CROSS_PREFIX=/usr/x86_64-linux-android/bin/x86_64-linux-android- OS_NAME=Linux-Android OS_ARCH=x86_64'


package: native-all
	rm -rf target/dependency-maven-plugin-markers
	$(MVN) package

clean-native:
	rm -rf $(SQLITE_OUT)

clean-java:
	rm -rf $(TARGET)/*classes
	rm -rf $(TARGET)/common-lib/*
	rm -rf $(TARGET)/sqlite-jdbc-*jar

clean-tests:
	rm -rf $(TARGET)/{surefire*,testdb.jar*}

