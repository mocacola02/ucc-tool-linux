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
UCC Tool for Linux
Copyright (C) 2026 LunaMoca

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
COMMENT