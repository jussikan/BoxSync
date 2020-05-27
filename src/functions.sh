copyFiles() {
    SRC=$1
    DEST=$2
    SLEEP=$3

    for i in ${NSEQ[@]}; do
        filename="*_$i.*"
        srcfile="$SRC/$filename"
        cp $srcfile $DEST

        sleep $SLEEP
    done
}
