#!/bin/sh
# just an example of how you could handle your downloads
# try some pattern matching on the uri to determine what we should do

DIR="`dirname $0`"
rxvt -e "$DIR/download2.sh" "$8"
