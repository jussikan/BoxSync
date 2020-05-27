#!/bin/bash

N=$1
DIR=$2
NAME=$3

SIZE=5000000
SUFFIX=data

if [ $# -lt 1 ]; then
    echo "Usage: $0 <count> <directory> [name]"
    exit 1
fi

if [ "x" == "x$NAME" ]; then
    NAME=random
fi

mkdir -p $DIR

i=0
while [ $i -lt $N ]; do
    filename="$NAME"_"$i.$SUFFIX"
    path="$DIR/$filename"
    base64 /dev/urandom | head -c $SIZE > $path
    echo Created file $filename
    let i="$i+1"
done

exit 0
