


handle_angle() {
    ANGLE_VERSION="chromium-7151_rev1"

    
    wget -O angle-iphoneall-universal.tar.gz "https://github.com/kivy/angle-builder/releases/download/$ANGLE_VERSION/angle-iphoneall-universal.tar.gz"
    tar -xzvf angle-iphoneall-universal.tar.gz -C $1
}

make_wheel() {
    python3.13 -m pip wheel kivy-sdl3-angle -w $1
    python3.14 -m pip wheel kivy-sdl3-angle -w $1
}

SCRIPT_DIR="$(dirname $0)"

KIVY_SDL_ANGLE="$PWD/kivy-sdl3-angle"
KSA_SRC=$KIVY_SDL_ANGLE/src

cp -rf $SCRIPT_DIR/kivy-sdl3-angle $PWD
mkdir -p $KSA_SRC

$SCRIPT_DIR/build_frameworks.sh $KSA_SRC


handle_angle $KSA_SRC

make_wheel build/wheels
