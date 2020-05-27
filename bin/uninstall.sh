#!/bin/bash

SCRIPTPATH="$( cwd=`dirname $0` && cd "$cwd/.." && pwd -P )"
cd $SCRIPTPATH

. src/globals.sh

launchctl unload $HOME/Library/LaunchAgents/$PLIST
rm $HOME/Library/LaunchAgents/$PLIST
