
ROOT="${PWD}"
OUTPUT_DIR="$ROOT/wheels"

build_ios_wheel() {

      ARCH=$1
      SDK=$2
      PLATFORM=$3

      SDK_ROOT="$(xcrun --show-sdk-path --sdk $SDK)"
      ARCHS="$ARCH"_"$SDK"

      SDL2_HEADERS=$ROOT/SDL2_Headers
      SDL_FW="$ROOT/SDL2.xcframework/$PLATFORM/SDL2.framework"
      SDL_IMAGE_FW="$ROOT/SDL2_image.xcframework/$PLATFORM/SDL2_image.framework"
      SDL_MIXER_FW="$ROOT/SDL2_mixer.xcframework/$PLATFORM/SDL2_mixer.framework"
      SDL_TTF_FW="$ROOT/SDL2_ttf.xcframework/$PLATFORM/SDL2_ttf.framework"

      export KIVYIOSROOT=$ROOT
      export CUSTOMIZED_OSX_COMPILER=True
      export KIVY_SPLIT_EXAMPLES=1
      export IOSSDKROOT=$SDK_ROOT
      export KIVY_SDL2_FRAMEWORKS_SEARCH_PATH=$SDL_FW
      export "CFLAGS=-I$SDK_ROOT/usr/include"
      export "LDFLAGS=-arch $ARCH \
            -L$SDL_FW\
            -L$SDL_IMAGE_FW\
            -L$SDL_MIXER_FW\
            -L$SDL_TTF_FW\
            "

      KIVY_SDL2_PATH="$SDL2_HEADERS:$SDL_IMAGE_FW/Headers:$SDL_MIXER_FW/Headers:$SDL_TTF_FW/Headers"
      export "KIVY_SDL2_PATH=$KIVY_SDL2_PATH"
      
      cibuildwheel --platform ios --archs $ARCHS --output-dir $OUTPUT_DIR

}

# handle SDL frameworks
pip3.13 install -i https://pypi.anaconda.org/pyswift/simple kivy-sdl2 -t ./

SDL_FW="$ROOT/SDL2.xcframework/ios-arm64/SDL2.framework"
cp -rf $SDL_FW/Headers SDL2_Headers
cp -rf $SDL_FW/Headers SDL2_Headers/SDL2

for PLATFORM in ios-arm64 ios-arm64_x86_64-simulator
do
      SDL_FW="$ROOT/SDL2.xcframework/$PLATFORM/SDL2.framework"
      SDL_IMAGE_FW="$ROOT/SDL2_image.xcframework/$PLATFORM/SDL2_image.framework"
      SDL_MIXER_FW="$ROOT/SDL2_mixer.xcframework/$PLATFORM/SDL2_mixer.framework"
      SDL_TTF_FW="$ROOT/SDL2_ttf.xcframework/$PLATFORM/SDL2_ttf.framework"

      ln -s $SDL_FW/SDL2                  $SDL_FW/libSDL2.dylib
      ln -s $SDL_IMAGE_FW/SDL2_image      $SDL_IMAGE_FW/libSDL2_image.dylib
      ln -s $SDL_MIXER_FW/SDL2_mixer      $SDL_MIXER_FW/libSDL22_mixer.dylib
      ln -s $SDL_TTF_FW/SDL2_ttf          $SDL_TTF_FW/libSDL2_ttf.dylib
done

# handle Kivy

wget https://github.com/kivy/kivy/archive/2.3.1.zip

unzip -o -qq 2.3.1.zip


OUTPUT_DIR="$ROOT/wheels"

wget https://gist.githubusercontent.com/Py-Swift/4c0834f0c5c0a89364af88ff9ec94e86/raw/ebc027230d13b47fa947efbb3fcad579b3c3e3e7/kivy.patch
patch -t -d $ROOT/kivy-2.3.1 -p1 -i $ROOT/kivy.patch

# build wheels

cd ./kivy-2.3.1
build_ios_wheel arm64 iphoneos ios-arm64
build_ios_wheel arm64 iphonesimulator ios-arm64_x86_64-simulator
build_ios_wheel x86_64 iphonesimulator ios-arm64_x86_64-simulator

