#!/bin/sh
# just an example of how you could handle your downloads
# try some pattern matching on the uri to determine what we should do

cd /tmp
# Some sites block the default wget --user-agent...
wget --user-agent="Uzbl WGet Mozilla/5.0" -c "$1"

bash
