

FWS_DIR="$PWD/dist/Frameworks"
pip install -i https://pypi.anaconda.org/kivyschool/simple kivy-sdl3-angle -t $FWS_DIR

for PLATFORM in ios-arm64 ios-arm64_x86_64-simulator
do
    SDL_FW="$FWS_DIR/SDL3.xcframework/$PLATFORM/SDL3.framework"
    SDL_IMAGE_FW="$FWS_DIR/SDL3_image.xcframework/$PLATFORM/SDL3_image.framework"
    SDL_MIXER_FW="$FWS_DIR/SDL3_mixer.xcframework/$PLATFORM/SDL3_mixer.framework"
    SDL_TTF_FW="$FWS_DIR/SDL3_ttf.xcframework/$PLATFORM/SDL3_ttf.framework"

    ln -s $SDL_FW/SDL3                  $SDL_FW/libSDL3.dylib
    ln -s $SDL_IMAGE_FW/SDL3_image      $SDL_IMAGE_FW/libSDL3_image.dylib
    ln -s $SDL_MIXER_FW/SDL3_mixer      $SDL_MIXER_FW/libSDL3_mixer.dylib
    ln -s $SDL_TTF_FW/SDL3_ttf          $SDL_TTF_FW/libSDL3_ttf.dylib

    cp -rf $SDL_FW/Headers $SDL_FW/Headers/SDL3
done


ANGLE_VERSION="chromium-7151_rev1"
ANGLE_FW="$PWD/dist/Frameworks"

#wget -O angle-iphoneall-universal.tar.gz "https://github.com/kivy/angle-builder/releases/download/$ANGLE_VERSION/angle-iphoneall-universal.tar.gz"
curl -LO "https://github.com/kivy/angle-builder/releases/download/$ANGLE_VERSION/angle-iphoneall-universal.tar.gz"
tar -xzvf angle-iphoneall-universal.tar.gz -C $ANGLE_FW

for PLATFORM in ios-arm64 ios-arm64_x86_64-simulator
do
    EGL_FW="$ANGLE_FW/libEGL.xcframework/$PLATFORM/libEGL.framework"
    GLES_FW="$ANGLE_FW/libGLESv2.xcframework/$PLATFORM/libGLESv2.framework"

    ln -s $EGL_FW/libEGL          $EGL_FW/libEGL.dylib
    ln -s $GLES_FW/libGLESv2      $GLES_FW/libGLESv2.dylib
done