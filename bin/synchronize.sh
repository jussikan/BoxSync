#/bin/bash

procs=(`ps aux | grep synchronize | grep -v grep | awk '{print $2}' | tr '\n' ' '`)
PC=${#procs[@]}
PID=$$

SRC=$1
DEST=$2
PRINT=$3


if [ $PC -ge 3 ]; then
    echo "Quitting because a previous instance was already running."
    exit 2
fi

if [ ! $SRC ]; then
    echo Source directory missing.
    exit 1
fi
if [ ! $DEST ]; then
    echo Destination directory missing.
    exit 1
fi

echo "Calling rsync"
echo "SRC: $SRC"
echo "DEST: $DEST"

LC=(`rsync \
    -v -a \
    --exclude='.dropbox.cache' \
    --exclude='.tmp.drivedownload' \
    -r \
    $SRC $DEST | wc -l`)

let FC="$LC-4"
echo "Synced $FC files"
echo "rsync finished"

exit 0
