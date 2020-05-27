#!/bin/bash

SRCDIR=data
DROPDIR_BASE=~/my file hosting service dir
DROPDIR="$DROPDIR_BASE/boxsynctesting"
DESTDIR_BASE=~/from my file hosting service dir
DESTDIR="$DESTDIR_BASE/boxsynctesting"

SCRIPT=synchronize.sh

RANDOM_DATA_FILE_COUNT=100

. functions.sh

sync() {
    ./$SCRIPT "$DROPDIR_BASE/" $DESTDIR_BASE &
}

syncScreen() {
    screen -dmS synk ./$SCRIPT "$DROPDIR_BASE/" $DESTDIR_BASE &
}

copiedFileCount=0
waitCopiedFileCount() {
    dir=$1
    n=$2
    copiedFileCount=$(ls -l1 $dir | wc -l | sed 's/\ //g')

    while [ $copiedFileCount -lt $n ]; do
        sleep 1
        copiedFileCount=$(ls -l1 $dir | wc -l | sed 's/\ //g')
    done
}

cleanDropdir() {
    rm $DROPDIR/*
}

cleanDestdir() {
    rm $DESTDIR/*
}

testBefore() {
    mkdir -p $DROPDIR
}

testAfter() {
    cleanDropdir
    cleanDestdir
}

testerRandom() {
    i=0
    n=$1
    doSync=$2

    if [ $n -lt 1 ]; then
        n=1
    elif [ $n -gt $RANDOM_DATA_FILE_COUNT ]; then
        n=$RANDOM_DATA_FILE_COUNT
    fi

    let max="$RANDOM_DATA_FILE_COUNT-1"
    rseq=(`seq 0 $max | awk 'BEGIN { srand() } { print rand() "\t" $0 }' | sort -n | cut -f2- | tr '\n' ' '`)

    if [ $n -eq 1 ]; then
        NSEQ=(${rseq[0]})
    else
        NSEQ=(${rseq[@]:0:$n})
    fi

    echo Copying files to dropdir
    copyFiles $SRCDIR $DROPDIR 1

    copiedFileCount=`ls -l1 $DESTDIR | wc -l | sed 's/\ //g'`
    [ $copiedFileCount -gt 0 ] && return 2

    if [ $doSync -eq 1 ]; then
        echo Calling syncScreen
        syncScreen

        waitCopiedFileCount $DESTDIR $n

        echo "copiedFileCount $copiedFileCount"
        echo "dropped file count $n"
    fi

    return 0
}

testerPartitioned() {
    i=0
    start=$1
    n=$2
    random=$3
    doSync=$4

    if [ $n -lt 1 ]; then
        n=1
    elif [ $n -gt $RANDOM_DATA_FILE_COUNT ]; then
        n=$RANDOM_DATA_FILE_COUNT
    fi

    max=$n
    if [ $random -eq 1 ]; then
        rseq=(`seq $start $max | awk 'BEGIN { srand() } { print rand() "\t" $0 }' | sort -n | cut -f2- | tr '\n' ' '`)
    else
        rseq=(`seq $start $max | sort -n | cut -f2- | tr '\n' ' '`)
    fi

    if [ $n -eq 1 ]; then
        NSEQ=(${rseq[0]})
    else
        NSEQ=(${rseq[@]:0:$n})
    fi

    echo Copying files to dropdir
    copyFiles $SRCDIR $DROPDIR 0

    if [ $doSync -eq 1 ]; then
        echo Calling syncScreen
        syncScreen

        waitCopiedFileCount $DESTDIR $n

        echo "copiedFileCount $copiedFileCount"
        echo "dropped file count $n"
    fi

    return 0
}

dataFileCount=$(ls -l1 $SRCDIR | wc -l | sed 's/\ //g')
if [ $dataFileCount -lt $RANDOM_DATA_FILE_COUNT ]; then
    ./generate-random-data.sh $RANDOM_DATA_FILE_COUNT $SRCDIR
fi

echo Testing with 1 file
testBefore
testerRandom 1 1
rc=$?
if [ $rc -eq 2 ]; then
    echo Files were copied too soon\!
fi

testAfter
if [ $rc -ne 0 ]; then
    exit 1
fi

echo Testing with 10 files
testBefore
testerRandom 10 1
rc=$?
testAfter
if [ $rc -eq 2 ]; then
    echo Files were copied too soon\!
fi
if [ $rc -ne 0 ]; then
    exit 1
fi

echo Testing with 100 files
testBefore
testerRandom 100 1
rc=$?
testAfter
if [ $rc -eq 2 ]; then
    echo Files were copied too soon\!
fi
if [ $rc -ne 0 ]; then
    exit 1
fi

echo Testing with 30+20+40+10 files
# point here is to see if new batch tries to sync files of previous batch
testBefore
testerPartitioned 0 29 0 1
testerPartitioned 30 49 0 1
testerPartitioned 50 89 0 1
testerPartitioned 90 99 0 0
rc=$?
sync
testAfter
if [ $rc -ne 0 ]; then
    testAfter
    exit 1
fi
testAfter

exit 0
