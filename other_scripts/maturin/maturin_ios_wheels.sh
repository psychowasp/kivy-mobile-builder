
build_iphoneos() {

    PYTHON_DIR=$1
    OPENSSL_DIR=$2
    PY_VERSION=$3

    export OSX_SDKROOT=$(xcrun --sdk macosx --show-sdk-path)
    export IOS_SDKROOT=$(xcrun --sdk iphoneos --show-sdk-path)
    export PYTHONDIR="$1/ios-arm64"
    export PYO3_CROSS_PYTHON_VERSION=$PY_VERSION

    env SDKROOT="$IOS_SDKROOT" \
    PYO3_CROSS_LIB_DIR="$PYTHONDIR" \
    OPENSSL_DIR=$OPENSSL_DIR \
    CARGO_TARGET_AARCH64_APPLE_IOS_RUSTFLAGS="\
        -C link-arg=-isysroot -C link-arg=$IOS_SDKROOT \
        -C link-arg=-arch -C link-arg=arm64 \
        -C link-arg=-miphoneos-version-min=13.0 \
        -C link-arg=-L \
        -C link-arg=$PYTHONDIR \
        -C link-arg=-undefined \
        -C link-arg=dynamic_lookup \
        " \
    maturin build --release --target aarch64-apple-ios -v

}

build_iphonesimulator_arm64() {

    PYTHON_DIR=$1
    OPENSSL_DIR=$2
    PY_VERSION=$3

    export OSX_SDKROOT=$(xcrun --sdk macosx --show-sdk-path)
    export IOS_SDKROOT=$(xcrun --sdk iphonesimulator --show-sdk-path)
    export PYTHONDIR="$PYTHON_XC/ios-arm64-simulator"
    export PYO3_CROSS_PYTHON_VERSION=$PY_VERSION

    env SDKROOT="$IOS_SDKROOT" \
    PYO3_CROSS_LIB_DIR="$PYTHONDIR" \
    OPENSSL_DIR=$OPENSSL_DIR \
    CARGO_TARGET_AARCH64_APPLE_IOS_SIM_RUSTFLAGS="\
        -C link-arg=-isysroot -C link-arg=$IOS_SDKROOT \
        -C link-arg=-arch -C link-arg=arm64 \
        -C link-arg=-miphoneos-version-min=13.0 \
        -C link-arg=-L \
        -C link-arg=$PYTHONDIR \
        -C link-arg=-undefined -C link-arg=dynamic_lookup" \
    maturin build --release --target aarch64-apple-ios-sim -v

}

build_iphonesimulator_x86_64() {

    PYTHON_DIR=$1
    OPENSSL_DIR=$2
    PY_VERSION=$3

    export OSX_SDKROOT=$(xcrun --sdk macosx --show-sdk-path)
    export IOS_SDKROOT=$(xcrun --sdk iphonesimulator --show-sdk-path)
    export PYTHONDIR="$PYTHON_XC/ios-x86_64-simulator"
    export PYO3_CROSS_PYTHON_VERSION=$PY_VERSION

    env SDKROOT="$IOS_SDKROOT" \
    PYO3_CROSS_LIB_DIR="$PYTHONDIR" \
    OPENSSL_DIR=$OPENSSL_DIR \
    CARGO_TARGET_X86_64_APPLE_IOS_RUSTFLAGS="\
        -C link-arg=-isysroot -C link-arg=$IOS_SDKROOT \
        -C link-arg=-arch -C link-arg=x86_64 \
        -C link-arg=-miphoneos-version-min=13.0 \
        -C link-arg=-L \
        -C link-arg=$PYTHONDIR \
        -C link-arg=-undefined -C link-arg=dynamic_lookup" \
    maturin build --release --target x86_64-apple-ios -v

}



ROOT=$PWD
PYTHON_XC=$1
OPENSSL_DIR="/usr/local/Cellar/openssl@3/3.5.2"
OUTPUT=$3
cd $2

build_iphoneos $PYTHON_XC $OPENSSL_DIR 3.13
find . -type f -name "$2*x86_64.whl" -exec mv {} $OUTPUT/$2-cp313-cp313-ios_13_0_arm64_iphoneos.whl \;

build_iphonesimulator_arm64 $PYTHON_XC $OPENSSL_DIR 3.13
find . -type f -name "$2*x86_64.whl" -exec mv {} $OUTPUT/$2-cp313-cp313-ios_13_0_arm64_iphonesimulator.whl \;

build_iphonesimulator_x86_64 $PYTHON_XC $OPENSSL_DIR 3.13
find . -type f -name "$2*x86_64.whl" -exec mv {} $OUTPUT/$2-cp313-cp313-ios_13_0_x86_64_iphonesimulator.whl \;

