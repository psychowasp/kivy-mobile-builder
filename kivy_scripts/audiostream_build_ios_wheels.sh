
SCRIPT_DIR="$(dirname $0)"
TOOLS=$SCRIPT_DIR/tools

#git clone https://github.com/kivy/audiostream

cp -f $TOOLS/audiostream/pyproject.toml audiostream/



SDL_ROOT=$PWD/kivy-sdl3-angle/src

SDK_ROOT="$(xcrun --show-sdk-path --sdk $SDK)"
ARCHS="$ARCH"_"$SDK"

EGL_FW="$ANGLE_FWS/libEGL.xcframework/$PLATFORM/libEGL.framework"
GLES_FW="$ANGLE_FWS/libGLESv2.xcframework/$PLATFORM/libGLESv2.framework"

PLATFORM=ios-arm64

SDL3_HEADERS=$SDL_ROOT/SDL3_Headers
SDL_FW="$SDL_ROOT/SDL3.xcframework/$PLATFORM/SDL3.framework"
SDL_IMAGE_FW="$SDL_ROOT/SDL3_image.xcframework/$PLATFORM/SDL3_image.framework"
SDL_MIXER_FW="$SDL_ROOT/SDL3_mixer.xcframework/$PLATFORM/SDL3_mixer.framework"
SDL_TTF_FW="$SDL_ROOT/SDL3_ttf.xcframework/$PLATFORM/SDL3_ttf.framework"


ln -s $SDL_FW/SDL3                  $SDL_FW/libSDL3.dylib
ln -s $SDL_MIXER_FW/SDL3_mixer      $SDL_MIXER_FW/libSDL3_mixer.dylib

export SDL2_INCLUDE_DIR=$SDL_FW/ios-arm64/SDL3.framework/Headers
export USE_SDL2=1
export KIVY_SDL3_FRAMEWORKS_SEARCH_PATH=$SDL_FW
export "CFLAGS=-I$SDL_FW/ios-arm64/SDL3.framework/Headers"

export KIVYIOSROOT=$ROOT
export IOSSDKROOT=$SDK_ROOT

ARCH=arm64

LDFLAGS="-arch $ARCH \
    -L$SDL_FW \
    -L$SDL_MIXER_FW \
    "
export "LDFLAGS=$LDFLAGS"

cibuildwheel audiostream --platform ios --archs arm64_iphoneos 