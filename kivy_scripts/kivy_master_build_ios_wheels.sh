
ROOT="${PWD}"
OUTPUT_DIR="$ROOT/wheels"

ANGLE_FWS="$ROOT/angle_frameworks"

build_ios_wheel() {

      ARCH=$1
      SDK=$2
      PLATFORM=$3


      ANGLE_HEADERS="$ANGLE_FWS/include"



      SDK_ROOT="$(xcrun --show-sdk-path --sdk $SDK)"
      ARCHS="$ARCH"_"$SDK"

      EGL_FW="$ANGLE_FWS/libEGL.xcframework/$PLATFORM/libEGL.framework"
      GLES_FW="$ANGLE_FWS/libGLESv2.xcframework/$PLATFORM/libGLESv2.framework"

      SDL3_HEADERS=$ROOT/SDL3_Headers
      SDL_FW="$ROOT/SDL3.xcframework/$PLATFORM/SDL3.framework"
      SDL_IMAGE_FW="$ROOT/SDL3_image.xcframework/$PLATFORM/SDL3_image.framework"
      SDL_MIXER_FW="$ROOT/SDL3_mixer.xcframework/$PLATFORM/SDL3_mixer.framework"
      SDL_TTF_FW="$ROOT/SDL3_ttf.xcframework/$PLATFORM/SDL3_ttf.framework"


      export KIVY_SDL3_FRAMEWORKS_SEARCH_PATH=$SDL_FW
      export "CFLAGS=-I$SDK_ROOT/usr/include"

      export KIVYIOSROOT=$ROOT
      export CUSTOMIZED_OSX_COMPILER=True
      export KIVY_SPLIT_EXAMPLES=1
      export KIVY_ANGLE_INCLUDE_DIR=$ANGLE_HEADERS
      export KIVY_ANGLE_LIB_DIR=$ANGLE_FWS
      export IOSSDKROOT=$SDK_ROOT


      KIVY_SDL3_PATH="$ANGLE_HEADERS:$SDL3_HEADERS:$SDL_IMAGE_FW/Headers:$SDL_MIXER_FW/Headers:$SDL_TTF_FW/Headers"

      export "KIVY_SDL3_PATH=$KIVY_SDL3_PATH"


      LINKED_FWS="\
            -framework Accelerate \
            -framework UIKit \
            -framework Foundation \
            -framework CoreFoundation \
            -framework CoreGraphics \
            -framework CoreMedia \
            -framework AVFoundation \
            -framework CoreVideo \
            -framework ImageIO \
            -framework MobileCoreServices \
            -framework CoreServices \
            -framework UniformTypeIdentifiers \
            -framework Metal \
            -framework libEGL \
            -framework libGLESv2 \
            "

      LDFLAGS="-arch $ARCH \
            -L$EGL_FW \
            -L$GLES_FW \
            -L$SDL_FW \
            -L$SDL_IMAGE_FW \
            -L$SDL_MIXER_FW \
            -L$SDL_TTF_FW \
            $LINKED_FWS \
            -F$ANGLE_FWS/libEGL.xcframework/$PLATFORM/ \
            -F$ANGLE_FWS/libGLESv2.xcframework/$PLATFORM/
            "

      export "LDFLAGS=$LDFLAGS"
      
      cibuildwheel --platform ios --archs $ARCHS --output-dir $OUTPUT_DIR

}

handle_angle() {
      ANGLE_VERSION="chromium-7151_rev1"

      mkdir $ANGLE_FWS
      wget -O angle-iphoneall-universal.tar.gz "https://github.com/kivy/angle-builder/releases/download/$ANGLE_VERSION/angle-iphoneall-universal.tar.gz"
      tar -xzvf angle-iphoneall-universal.tar.gz -C $ANGLE_FWS

      for PLATFORM in ios-arm64 ios-arm64_x86_64-simulator
      do
            ln -s $EGL_FW/libEGL          $EGL_FW/libEGL.dylib
            ln -s $GLES_FW/libGLESv2      $GLES_FW/libGLESv2.dylib
      done
}

handle_sdl() {
      pip3.13 install -i https://pypi.anaconda.org/pyswift/simple kivy-sdl3-angle -t ./

      SDL_FW="$ROOT/SDL3.xcframework/ios-arm64/SDL3.framework"
      cp -rf $SDL_FW/Headers SDL3_Headers
      cp -rf $SDL_FW/Headers SDL3_Headers/SDL3

      for PLATFORM in ios-arm64 ios-arm64_x86_64-simulator
      do
            SDL_FW="$ROOT/SDL3.xcframework/$PLATFORM/SDL3.framework"
            SDL_IMAGE_FW="$ROOT/SDL3_image.xcframework/$PLATFORM/SDL3_image.framework"
            SDL_MIXER_FW="$ROOT/SDL3_mixer.xcframework/$PLATFORM/SDL3_mixer.framework"
            SDL_TTF_FW="$ROOT/SDL3_ttf.xcframework/$PLATFORM/SDL3_ttf.framework"

            ln -s $SDL_FW/SDL3                  $SDL_FW/libSDL3.dylib
            ln -s $SDL_IMAGE_FW/SDL3_image      $SDL_IMAGE_FW/libSDL3_image.dylib
            ln -s $SDL_MIXER_FW/SDL3_mixer      $SDL_MIXER_FW/libSDL3_mixer.dylib
            ln -s $SDL_TTF_FW/SDL3_ttf          $SDL_TTF_FW/libSDL3_ttf.dylib
      done
}

handle_kivy_master() {
      wget -O master.zip https://github.com/kivy/kivy/archive/master.zip
      unzip -o -qq master.zip
      patch -t -d $ROOT/kivy-master -p1 -i $1
}

create_commit_sha_wheels() {
      cd $1
      for PLATFORM in arm64_iphoneos arm64_iphonesimulator x86_64_iphonesimulator
      do
            cp -rf kivy-$2-cp313-cp313-ios_13_0_$PLATFORM.whl kivy-$3-cp313-cp313-ios_13_0_$PLATFORM.whl
      done 
}

# execute
COMMIT_SHA="f6299897"

handle_angle
handle_sdl
handle_kivy_master $ROOT/../patches/kivy3.patch

cd ./kivy-master

build_ios_wheel arm64 iphoneos ios-arm64
build_ios_wheel arm64 iphonesimulator ios-arm64_x86_64-simulator
build_ios_wheel x86_64 iphonesimulator ios-arm64_x86_64-simulator

create_commit_sha_wheels $ROOT/wheels 3.0.0.dev0 3.0.0.$COMMIT_SHA
