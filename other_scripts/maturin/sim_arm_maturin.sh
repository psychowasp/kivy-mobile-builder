PYTHON_XC=$2

export OSX_SDKROOT=$(xcrun --sdk macosx --show-sdk-path)
export IOS_SDKROOT=$(xcrun --sdk iphonesimulator --show-sdk-path)
#export IOS_SDKROOT=$(xcrun --sdk iphoneos --show-sdk-path)
export PYTHONDIR="$PYTHON_XC/ios-arm64-simulator"
#export PYTHONDIR="/Library/Frameworks/Python.framework/Versions/3.11"
export PYO3_CROSS_PYTHON_VERSION=3.13
#export _PYTHON_SYSCONFIGDATA_NAME="_sysconfigdata__ios_arm64-iphonesimulator"
env SDKROOT="$IOS_SDKROOT" \
PYO3_CROSS_LIB_DIR="$PYTHONDIR" \
OPENSSL_DIR="/usr/local/Cellar/openssl@3/3.5.2" \
CARGO_TARGET_AARCH64_APPLE_IOS_SIM_RUSTFLAGS="\
	-C link-arg=-isysroot -C link-arg=$IOS_SDKROOT \
	-C link-arg=-arch -C link-arg=arm64 \
	-C link-arg=-miphoneos-version-min=13.0 \
	-C link-arg=-L \
	-C link-arg=$PYTHONDIR \
	-C link-arg=-undefined -C link-arg=dynamic_lookup
	" \
maturin build --release --target aarch64-apple-ios-sim -v

find . -type f -name "$1*x86_64.whl" -exec mv {} ../$1-cp313-cp313-ios_13_0_arm64_iphonesimulator.whl \;

# cd $1
# mv $2-cp313-cp313-ios_24_1_0_x86_64.whl $2-cp313-cp313-ios_13_0_arm64_iphonesimulator.whl
# mv $2-cp313-abi3-ios_24_1_0_x86_64.whl $2-cp313-cp313-ios_13_0_arm64_iphonesimulator.whl
# mv $2-cp37-abi3-ios_24_1_0_x86_64.whl $2-cp313-cp313-ios_13_0_arm64_iphonesimulator.whl

# mv $2-cp313-cp313-ios_24_6_0_x86_64.whl $2-cp313-cp313-ios_13_0_arm64_iphonesimulator.whl
