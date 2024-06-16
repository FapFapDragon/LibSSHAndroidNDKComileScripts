SCRIPTPATH=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
export ANDROID_NDK_HOME=$SCRIPTPATH/android-ndk-r26d
export ANDROID_NDK_ROOT=$SCRIPTPATH/android-ndk-r26d
OPENSSL_DIR=$SCRIPTPATH/openssl-master
toolchains_path=$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64

export PATH="$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64/bin:$PATH"

CC=clang

# Add toolchains bin directory to PATH
PATH=$toolchains_path/bin:$PATH

# Set the Android API levels
ANDROID_API=27

# Set the target architecture
# Can be android-arm, android-arm64, android-x86, android-x86 etc
architecture=android-arm
ANDROID_ABI=armeabi-v7a

git clone https://github.com/openssl/openssl.git $OPENSSL_DIR
 
cd $OPENSSL_DIR

./Configure $architecture -D__ANDROID_MIN_SDK_VERSION__=$ANDROID_API -fPIC --prefix=$SCRIPTPATH/openssl_$ANDROID_ABI --openssldir=$SCRIPTPATH/openssl_$ANDROID_ABI/openssl_dir 

make clean 

sed -e '/[.]hidden.*OPENSSL_armcap_P/d; /[.]extern.*OPENSSL_armcap_P/ {p; s/extern/hidden/ }' -i -- $OPENSSL_DIR/crypto/*arm*pl $OPENSSL_DIR/crypto/*/asm/*arm*pl

make 

make install

ANDROID_ABI=arm64-v8a
architecture=android-arm64
./Configure $architecture -D__ANDROID_MIN_SDK_VERSION__=$ANDROID_API --prefix=$SCRIPTPATH/openssl_$ANDROID_ABI --openssldir=$SCRIPTPATH/openssl_$ANDROID_ABI/openssl_dir

make clean 

make 

make install

echo $PATH

