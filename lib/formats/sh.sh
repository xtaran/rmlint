#!/bin/sh
# This file was autowritten by rmlint
# rmlint was executed from: %s
# Your command line was: %s

USER='%s'
GROUP='%s'

# Set to true on -n
DO_DRY_RUN=

##################################
# GENERAL LINT HANDLER FUNCTIONS #
##################################

handle_emptyfile() {
    echo 'Deleting empty file:' "$1"
    if [ -z "$DO_DRY_RUN" ]; then
        rm -f "$1"
    fi
}

handle_emptydir() {
    echo 'Deleting empty directory:' "$1"
    if [ -z "$DO_DRY_RUN" ]; then
        rmdir "$1"
    fi
}

handle_bad_symlink() {
    echo 'Deleting symlink pointing nowhere:' "$1"
    if [ -z "$DO_DRY_RUN" ]; then
        rm -f "$1"
    fi
}

handle_unstripped_binary() {
    echo 'Stripping debug symbols of:' "$1"
    if [ -z "$DO_DRY_RUN" ]; then
        strip -s "$1"
    fi
}

handle_bad_user_id() {
    echo 'chown' "$USER" "$1"
    if [ -z "$DO_DRY_RUN" ]; then
        chown "$USER" "$1"
    fi
}

handle_bad_group_id() {
    echo 'chgrp' "$GROUP" "$1"
    if [ -z "$DO_DRY_RUN" ]; then
        chgrp "$GROUP" "$1"
    fi
}

handle_bad_user_and_group_id() {
    echo 'chown' "$USER:$GROUP" "$1"
    if [ -z "$DO_DRY_RUN" ]; then
        chown "$USER:$GROUP" "$1"
    fi
}

###############################
# DUPLICATE HANDLER FUNCTIONS #
###############################

cp_hardlink() {
    echo 'Hardlinking to original:' "$1"
    if [ -z "$DO_DRY_RUN" ]; then
        cp --remove-destination --archive --link "$2" "$1"
    fi
}

cp_symlink() {
    echo 'Symlinking to original:' "$1"
    if [ -z "$DO_DRY_RUN" ]; then
        touch -mr "$1" "$0"
        cp --remove-destination --archive --symbolic-link "$2" "$1"
        touch -mr "$0" "$1"
    fi
}

cp_reflink() {
    # reflink $1 to $2's data, preserving $1's  mtime
    echo 'Reflinking to original:' "$1"
    if [ -z "$DO_DRY_RUN" ]; then
        touch -mr "$1" "$0"
        cp --reflink=always "$2" "$1"
        touch -mr "$0" "$1"
    fi
}

skip_hardlink() {
    echo 'Leaving as-is (already hardlinked to original):' "$1"
}

skip_reflink() {
    echo 'Leaving as-is (already reflinked to original):' "$1"
}

user_command() {
    # You can define this function to do what you want:
    %s
}

remove_cmd() {
    echo 'Deleting:' "$1"
    if [ -z "$DO_DRY_RUN" ]; then
        rm -rf "$1"
    fi
}

##################
# OPTION PARSING #
##################

ask() {
    cat << EOF

This script will delete certain files rmlint found.
It is highly advisable to view the script first!

Rmlint was executed in the following way:

   $ %s

Execute this script with -d to disable this informational message.
Type any string to continue; CTRL-C, Enter or CTRL-D to abort immediately
EOF
    read eof_check
    if [ -z "$eof_check" ]
    then
        # Count Ctrl-D and Enter as aborted too.
        echo "Aborted on behalf of the user."
        exit 1;
    fi
}

usage() {
    cat << EOF
usage: $0 OPTIONS

OPTIONS:

  -h   Show this message.
  -d   Do not ask before running.
  -x   Keep rmlint.sh; do not autodelete it.
  -n   Do not perform any modifications, just print what would be done.
EOF
}

DO_REMOVE=
DO_ASK=

while getopts "dhxn" OPTION
do
  case $OPTION in
     h)
       usage
       exit 1
       ;;
     d)
       DO_ASK=false
       ;;
     x)
       DO_REMOVE=false
       ;;
     n)
       DO_DRY_RUN=true
  esac
done

if [ -z $DO_ASK ]
then
  usage
  ask
fi

######### START OF AUTOGENERATED OUTPUT #########


