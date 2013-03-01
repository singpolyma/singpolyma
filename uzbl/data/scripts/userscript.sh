#!/bin/sh

process_rule() {
	RULE_NAME=$1
	SHOULD_RUN_IF_MATCHES=$2

	# Loop over all rules
	for RULE in `echo "$META" | grep "^\s*\/\/\s*@$RULE_NAME"`; do
		# Munge into grep pattern
		RULE="`echo "$RULE" | sed -e 's/^\s*\/\/\s*@'$RULE_NAME'\s*//' -e 's/\./\\\\./g' -e 's/\*/.*/g' -e 's/[\r\n]//g'`"
		if echo "$UZBL_URI" | grep -x "$RULE"; then
			SHOULD_RUN=$SHOULD_RUN_IF_MATCHES
		fi
	done
}

do_scripts() {
	scripts_dir="$1"
	IFS="
	"
	# Loop over all userscripts in the directory
	for SCRIPT in `grep -lx "\s*//\s*==UserScript==\s*" "$scripts_dir"/*.user.js`; do
		SCRIPT="`readlink -en "$SCRIPT"`"
		# Extract metadata chunk
		META="`sed -ne '/^\s*\/\/\s*==UserScript==\s*$/,/^\s*\/\/\s*==\/UserScript==\s*$/p' "$SCRIPT"`"

		SHOULD_RUN=0 # Assume this script will not be included
		process_rule "include" 1
		process_rule "exclude" 0

		# Run the script
		if [ $SHOULD_RUN = 1 ]; then
			echo "script '$SCRIPT'" >> "$UZBL_FIFO"
		fi
	done
}

# TODO search XDG_DATA_DIRS
do_scripts "`dirname $0`/../userscripts"
