install_ffi() {
    mkdir libffi
    for PLATFORM in iphoneos_arm64 iphonesimulator_arm64 iphonesimulator_x86_64
    do
        mkdir libffi/$PLATFORM
        pip3.13 install -i https://pypi.anaconda.org/beeware/simple libffi --platform ios_12_0_$PLATFORM --only-binary=:all: -t libffi/$PLATFORM
        cp -rf libffi/$PLATFORM/opt/include/include libffi/$PLATFORM/opt/include/ffi
    done
}




SCRIPT="$(realpath $0)"
SCRIPT_DIR="$(dirname $SCRIPT)"
TOOLS=$SCRIPT_DIR/tools
FRAMEWORKS="-framework MessageUI -framework CoreMotion -framework UIKit -framework WebKit -framework Photos -framework Foundation"


install_ffi

cp -rf $TOOLS/kivy_ios .

# iphone

SDK_ROOT="$(xcrun --show-sdk-path --sdk iphoneos)"
export CFLAGS="-I$SDK_ROOT/usr/include -I$PWD/libffi/iphoneos_arm64/opt/include"

export LDFLAGS="-arch arm64 -L$PWD/libffi/iphoneos_arm64/opt/lib $FRAMEWORKS"
cibuildwheel kivy_ios --platform ios --archs arm64_iphoneos --output-dir $1


# simulator
SDK_ROOT="$(xcrun --show-sdk-path --sdk iphonesimulator)"
export CFLAGS="-I$SDK_ROOT/usr/include -I$PWD/libffi/iphonesimulator_arm64/opt/include"

export LDFLAGS="-arch arm64 -L$PWD/libffi/iphonesimulator_arm64/opt/lib $FRAMEWORKS"
cibuildwheel kivy_ios --platform ios --archs arm64_iphonesimulator --output-dir $1

export LDFLAGS="-arch x86_64 -L$PWD/libffi/iphonesimulator_x86_64/opt/lib $FRAMEWORKS"
cibuildwheel kivy_ios --platform ios --archs x86_64_iphonesimulator --output-dir $1