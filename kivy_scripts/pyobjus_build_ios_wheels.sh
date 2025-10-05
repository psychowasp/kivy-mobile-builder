

SCRIPT="$(realpath $0)"
SCRIPT_DIR="$(dirname $SCRIPT)"
TOOLS=$SCRIPT_DIR/tools

SDK_ROOT="$(xcrun --show-sdk-path --sdk iphoneos)"

git clone https://github.com/kivy/pyobjus

patch -t -d pyobjus -p1 -i $TOOLS/pyobjus.patch
cp -f  $TOOLS/pyobjus.__init__.py pyobjus/pyobjus/__init__.py

export CFLAGS="-I$SDK_ROOT/usr/include -I$PWD/opt/include"
export LDFLAGS="-arch arm64 -L$PWD/opt/lib"

cibuildwheel pyobjus --platform ios --archs arm64_iphoneos --output-dir $1