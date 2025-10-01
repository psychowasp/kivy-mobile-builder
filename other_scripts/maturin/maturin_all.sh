rm -rf target
ROOT=~
PYTHON_XC="$ROOT/sh_scripts/Python.xcframework"
cd $2
~/sh_scripts/ios_maturin.sh "$1-$2" $PYTHON_XC
~/sh_scripts/sim_arm_maturin.sh "$1-$2" $PYTHON_XC
~/sh_scripts/sim_maturin.sh "$1-$2" $PYTHON_XC
