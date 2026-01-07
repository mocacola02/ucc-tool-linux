#!/bin/bash

DIR="./UCC-Tool"
CONFIG="$DIR/config.ini"
UCCLOG="$DIR/UCC.log"
LOG="$DIR/UCC-Tool.log"

function go_home () {
    CHOICE=$(zenity --list \
    --title="Moca's UCC Tool" \
    --text="Choose a command:" \
    --radiolist \
    --column="Select" \
    --column="Command Name" \
    True "Make" \
    FALSE "Set Make .ini" \
    FALSE "Full Batch Export")

    if [ "$?" = 0 ]; then
        if [ "$CHOICE" == "Make" ]; then
            make
        elif [ "$CHOICE" == "Set Make .ini" ]; then
            set_make_ini
        elif [ "$CHOICE" == "Full Batch Export" ]; then
            full_batch_export
        else
            zenity --warning --text="Could not determine option, exiting."
        fi
    else
        exit 0
    fi
}

function make () {
    if [ ! -s "$CONFIG" ]; then
        zenity --error --text="Make ini has not been set. Please go to Set Make .ini before trying to build."
        go_home
        return
    fi

    INIVALUE=$(cat $CONFIG)
    echo "Running: UCC.exe make ini=${INIVALUE}"
    wine UCC.exe make "ini=${INIVALUE}" > $UCCLOG
    RESULT=$(tail -n 1 $UCCLOG)
    echo "Result is ${RESULT}"
    zenity --info --title="Make Finished" --text="${RESULT} \n See ./UCC-Tool/UCC.log for full log."
}

function set_make_ini () {
    touch $CONFIG
    USER_INPUT=$(zenity --entry --title="Set Make .ini" --text="Enter your ini name (ex: Moca.ini):")
    echo ${USER_INPUT} > $CONFIG
    go_home
}

function full_batch_export () {
    print_placeholder
}

function print_placeholder () {
    zenity --warning --text="Not yet implemented"
}

mkdir -p "$DIR"
go_home

<<'COMMENT'
MIT License

Copyright (c) 2026 LunaMoca

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
COMMENT
