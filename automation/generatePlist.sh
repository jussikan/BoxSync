#!/bin/bash

PROJDIR="$( cwd=`dirname $0` && cd "$cwd/.." && pwd -P )"

cd $PROJDIR
. src/globals.sh
PLIST_TPL="src/$PLIST.tpl"
WORK="$PWD/work.plist"

SCRIPT=$1
SCRIPT=${SCRIPT//\//\\/}

SRC=$2
SRC=${SRC//\//\\/}
SRC="$SRC\\/" # slash at end due to rsync peculiarity

DEST=$3
DEST=${DEST//\//\\/}

INTERVAL=$4

LOGPATH=$5
if [ "x" != "x$LOGPATH" ]; then
    LOGPATH=${LOGPATH//\//\\/}
fi

cp "$PROJDIR/$PLIST_TPL" $WORK

sed -i .bak "s/%SCRIPT%/$SCRIPT/g" $WORK
if [ $? -ne 0 ]; then
    echo fail at placeholder SCRIPT
    rm $WORK
    exit 1
fi

sed -i .bak "s/%WATCHPATH%/$SRC/g" $WORK
if [ $? -ne 0 ]; then
    echo fail at placeholder WATCHPATH
    rm $WORK
    exit 1
fi

sed -i .bak "s/%DESTINATION%/$DEST/g" $WORK
if [ $? -ne 0 ]; then
    echo fail at placeholder DESTINATION
    rm $WORK
    exit 1
fi

sed -i .bak "s/%INTERVAL%/$INTERVAL/g" $WORK
if [ $? -ne 0 ]; then
    echo fail at placeholder INTERVAL
    rm $WORK
    exit 1
fi

mv $WORK "$PWD/$PLIST"
rm $WORK.bak
