#/bin/bash

SRC=$1
DEST=$2
INTERVAL=$3

if [ $# -lt 3 ]; then
    echo "Usage: $0 <source directory> <destination directory> <run interval in seconds>"
    exit 1
fi

SCRIPTPATH="$( cwd=`dirname $0` && cd "$cwd/.." && pwd -P )"
cd $SCRIPTPATH

. src/globals.sh

$SCRIPTPATH/automation/generatePlist.sh "$SCRIPTPATH/bin/synchronize.sh" $SRC $DEST $INTERVAL

cp "$PWD/$PLIST" ~/Library/LaunchAgents/$PLIST
launchctl load ~/Library/LaunchAgents/$PLIST
rm "$PWD/$PLIST"
