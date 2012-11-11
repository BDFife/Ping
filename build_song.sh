if [ $# -ne 1 ]
then
    echo "Error in $0 - Invalid Argument Count"
    echo "Syntax: $0 input_file"
    exit
fi

FILE=$1
TRIMMED=`echo "${FILE}" | tr -d ' '`
#FILE=`echo "${FILE}" | sed 's/ /\ /g'`

BUILD_DIR="build_${TRIMMED}"

rm -rf $BUILD_DIR

# Send stuff to build directory
mkdir $BUILD_DIR
cp ${FILE} $BUILD_DIR/${TRIMMED}

# TODO Detect if we've analyzed the file, since this takes a while
cp ./python/pingprocessor.py $BUILD_DIR
cd $BUILD_DIR
python ./pingprocessor.py ${TRIMMED}
cp ./* ../Music
cd ../Music
rm pingprocessor.py
