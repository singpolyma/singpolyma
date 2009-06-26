#!/bin/sh
# just an example of how you could handle your downloads
# try some pattern matching on the uri to determine what we should do

# Some sites block the default wget --user-agent...
WGET="wget --user-agent=Mozilla/4.0"

cd /tmp
$WGET $1

echo
echo "Press any key to close..."
read NOTHING
