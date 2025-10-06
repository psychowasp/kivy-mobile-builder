
SDL_VER="3.2.22"
SDL_IMAGE_VER="3.2.4"
SDL_MIXER_VER="78a2035cf4cf95066d7d9e6208e99507376409a7"
SDL_TTF_VER="3.2.2"

XC_BUILD=""

build_framework() {

    LIB=$1
    PROJECT=$2
    ARCHIVE_PATH=$3
    cd $4
    OUTPUT=$5

    xcodebuild archive \
        -scheme $LIB \
        -project $PROJECT \
        -archivePath $ARCHIVE_PATH/Release-iphoneos \
        -destination 'generic/platform=iOS' \
        -configuration Release BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
        SKIP_INSTALL=NO

    xcodebuild archive \
        -scheme $LIB \
        -project $PROJECT \
        -archivePath $ARCHIVE_PATH/Release-iphonesimulator \
        -destination 'generic/platform=iOS Simulator' \
        -configuration Release BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
        SKIP_INSTALL=NO

    xcodebuild -create-xcframework \
        -framework $ARCHIVE_PATH/Release-iphoneos.xcarchive/Products/Library/Frameworks/$LIB.framework\
        -framework $ARCHIVE_PATH/Release-iphonesimulator.xcarchive/Products/Library/Frameworks/$LIB.framework\
        -output $OUTPUT/$LIB.xcframework

    cd ..
}


sdl_ttf_extra() {
    cd $1
    external/download.sh
}


download_fws() {
    SDL_FILE="SDL3-$SDL_VER.tar.gz"
    wget -O $SDL_FILE https://github.com/libsdl-org/SDL/releases/download/release-$SDL_VER/$SDL_FILE
    tar -xzvf $SDL_FILE
    patch -t -d SDL3-$SDL_VER -p1 -i $PWD/../patches/uikit-transparent.patch
    patch -t -d SDL3-$SDL_VER -p1 -i $PWD/../patches/disable-opengl.patch

    FILE="SDL3_image-$SDL_IMAGE_VER.tar.gz"
    wget -O $FILE https://github.com/libsdl-org/SDL_image/releases/download/release-$SDL_IMAGE_VER/$FILE
    tar -xzvf $FILE

    FILE="SDL3_mixer-$SDL_MIXER_VER.tar.gz"
    wget -O $FILE https://github.com/libsdl-org/SDL_mixer/archive/$SDL_MIXER_VER/$FILE
    tar -xzvf $FILE

    FILE="SDL3_ttf-$SDL_TTF_VER.tar.gz"
    wget -O $FILE https://github.com/libsdl-org/SDL_ttf/releases/download/release-$SDL_TTF_VER/$FILE
    #https://github.com/libsdl-org/SDL_ttf/releases/download/release-{version}/SDL3_ttf-{version}.tar.gz
    tar -xzvf $FILE
}


download_fws

build_framework SDL3 Xcode/SDL/SDL.xcodeproj Xcode/SDL/build SDL3-$SDL_VER $1

build_framework SDL3_image Xcode/SDL_image.xcodeproj Xcode/build SDL3_image-$SDL_IMAGE_VER $1

build_framework SDL3_mixer Xcode/SDL_mixer.xcodeproj Xcode/build SDL_mixer-$SDL_MIXER_VER $1

sdl_ttf_extra SDL3_ttf-$SDL_TTF_VER
build_framework SDL3_ttf Xcode/SDL_ttf.xcodeproj Xcode/build SDL3_ttf-$SDL_TTF_VER $1
