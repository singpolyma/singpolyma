#!/bin/sh
#TODO: strip 'http://' part
file=${XDG_DATA_HOME:-$HOME/.local/share}/uzbl/history
[ -d `dirname $file` ] || exit 1
URL="`echo "$6" | sed -e's/ /%20/g'`"
echo "$8 $URL $7" >> $file
