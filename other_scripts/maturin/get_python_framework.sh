PY_VERSION=$1
BEEWARE_BUILD=$2
PY_TAR="Python-$PY_VERSION-iOS-support.$BEEWARE_BUILD.tar.gz"
URL=https://github.com/beeware/Python-Apple-support/releases/download/$PY_VERSION-$BEEWARE_BUILD/$PY_TAR

wget $URL
tar -xzvf $PY_TAR

rm -rf $PY_TAR

cp -rf Python.xcframework/ios-arm64_x86_64-simulator Python.xcframework/ios-arm64-simulator
rm -rf Python.xcframework/ios-arm64-simulator/lib/python$PY_VERSION/_sysconfigdata__ios_x86_64-iphonesimulator.py

cp -rf Python.xcframework/ios-arm64_x86_64-simulator Python.xcframework/ios-x86_64-simulator
rm -rf Python.xcframework/ios-x86_64-simulator/lib/python$PY_VERSION/_sysconfigdata__ios_arm64-iphonesimulator.py

mv -f Python.xcframework Python$PY_VERSION.xcframework