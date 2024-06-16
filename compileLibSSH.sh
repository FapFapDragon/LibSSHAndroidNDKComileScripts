ANDROID_API="arm64-v8a"
API_LEVEL=27
BUILD_SHARED_LIB=0
SCRIPTPATH=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
export ANDROID_NDK_ROOT=$SCRIPTPATH/android-ndk-r26d
NDK_TOOLCHAIN_PATH=$ANDROID_NDK_ROOT/build/cmake/android.toolchain.cmake
architecture=android-arm64
OUTPUT_LIBS_DIR="libs/${ANDROID_API}"
build_static_libssh=ON

rm -rf libssh_source
git clone https://git.libssh.org/projects/libssh.git libssh_source

#PATCH to fix Compilation with Android NDK
sed -i 's/_S_IWRITE/S_IWUSR/g' libssh_source/src/misc.c
sed -i 's/S_IWRITE/S_IWUSR/g' libssh_source/src/misc.c

rm -rf libssh_$ANDROID_API
cp -R libssh_source libssh_$ANDROID_API
cd libssh_$ANDROID_API
mkdir build
cd build

make clean
rm -rf 

cmake \
	-DCMAKE_INSTALL_PREFIX=$SCRIPTPATH/libssh_$ANDROID_API \
	-DWITH_INTERNAL_DOC=OFF \
	-DWITH_GSSAPI=OFF \
	-DWITH_NACL=OFF \
	-DWITH_EXAMPLES=OFF \
	-DCMAKE_BUILD_TYPE=Release \
	-DOPENSSL_INCLUDE_DIR=$SCRIPTPATH/openssl_$ANDROID_API/include \
	-DOPENSSL_CRYPTO_LIBRARY=$SCRIPTPATH/openssl_$ANDROID_API/lib/libcrypto.a \
	-DCMAKE_TOOLCHAIN_FILE=${NDK_TOOLCHAIN_PATH} \
	-DANDROID_NDK=${ANDROID_NDK_ROOT} \
	-DANDROID_NATIVE_API_LEVEL=android-${API_LEVEL} \
	-DANDROID_ABI=${ANDROID_API} \
	-DBUILD_STATIC_LIB=${build_static_libssh} \
	-DBUILT_LIBS_DIR=${OUTPUT_LIBS_DIR} \
	-DWITH_SFTP=1 \
	-DCLIENT_TESTING=1\
	..
cmake --build 
make install
cp src/libssh.a $SCRIPTPATH/libssh_$ANDROID_API/lib/
cd $SCRIPTPATH
rm -rf libssh_$ANDROID_API
	
ANDROID_API="armeabi-v7a"
API_LEVEL=27
BUILD_SHARED_LIB=0
export ANDROID_NDK_ROOT=$SCRIPTPATH/android-ndk-r26d
NDK_TOOLCHAIN_PATH=$ANDROID_NDK_ROOT/build/cmake/android.toolchain.cmake
architecture=android-arm
OUTPUT_LIBS_DIR="libs/${ANDROID_API}"
cd $SCRIPTPATH
rm -rf libssh_$ANDROID_API
cp -R libssh_source libssh_$ANDROID_API
cd libssh_$ANDROID_API
mkdir build
cd build

cmake \
	-DCMAKE_INSTALL_PREFIX=$SCRIPTPATH/libssh_$ANDROID_API \
	-DWITH_INTERNAL_DOC=OFF \
	-DWITH_GSSAPI=OFF \
	-DWITH_NACL=OFF \
	-DWITH_EXAMPLES=OFF \
	-DCMAKE_BUILD_TYPE=Release \
	-DOPENSSL_INCLUDE_DIR=$SCRIPTPATH/openssl_$ANDROID_API/include \
	-DOPENSSL_CRYPTO_LIBRARY=$SCRIPTPATH/openssl_$ANDROID_API/lib/libcrypto.a \
	-DCMAKE_TOOLCHAIN_FILE=${NDK_TOOLCHAIN_PATH} \
	-DANDROID_NDK=${ANDROID_NDK_ROOT} \
	-DANDROID_NATIVE_API_LEVEL=android-${API_LEVEL} \
	-DANDROID_ABI=${ANDROID_API} \
	-DBUILD_STATIC_LIB=${build_static_libssh} \
	-DBUILT_LIBS_DIR=${OUTPUT_LIBS_DIR} \
	-DWITH_SFTP=1 \
	-DCLIENT_TESTING=1\
	..
	
cmake --build 
make install
cp src/libssh.a $SCRIPTPATH/libssh_$ANDROID_API/lib/
cd $SCRIPTPATH
rm -rf libssh_$ANDROID_API

