if [ $# -ne 1 ]
then
    echo "Error in $0 - Invalid Argument Count"
    echo "Syntax: $0 input_file"
    exit
fi

FILE=$1
BUILD_DIR="build_${FILE}"

# Clean up directories
rm -rf ./distro
mkdir distro

# Send stuff to build directory
mkdir $BUILD_DIR
cp ${FILE} $BUILD_DIR
cp ./Samples/* $BUILD_DIR

# TODO Detect if we've analyzed the file, since this takes a while
cp ./python/pingprocessor.py $BUILD_DIR
cd $BUILD_DIR
python ./pingprocessor.py ${FILE}
mv ./*.ping.lua ./brickgen.lua

# Get rid of any running love instances
killall love

cd ..

# Zip all files to a distro output
zip -j ./distro/ping.love ./conf.lua ./main.lua ./collider.lua ./brick_core.lua ./menu_core.lua ./Font/PressStart2P.ttf $BUILD_DIR/*

# Remove temp
# TODO may want to keep around and not re-run build scripts if we don't need to?
rm -rf $BUILD_DIR # Disable if we want to inspect output
open ./distro/ping.love
