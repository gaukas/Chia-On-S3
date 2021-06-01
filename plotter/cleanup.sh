#!/bin/bash

PLOT_DIR=/data/plots
#PLOT_DIR=/home/ubuntu/test

cd ~/chia-blockchain
. ./activate
PLOTMAN_STATUS=$(plotman status)

FILE_LIST=$(ls ${PLOT_DIR} | grep -E ".tmp$")

num=0
while IFS= read -r line; do
    if [ $num -eq 0 ]; then
        echo "Auto-cleanup started..."
        ((num++))
    else
        COLS=()
        IFS=' ' read -ra COLS <<< $line
        FILE_LIST=$(echo "$FILE_LIST" | grep -v "${COLS[0]}")
    fi
done <<< "$PLOTMAN_STATUS"

# echo "$FILE_LIST"
sleep 2

if [ -n "$FILE_LIST" ]; then
    while IFS= read -r line; do
        rm -rf $PLOT_DIR/$line
    done <<< "$FILE_LIST"
fi
