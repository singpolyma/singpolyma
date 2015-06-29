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
		process_rule "match" 1
		process_rule "include" 1
		process_rule "exclude" 0

		# Find run-at code
		THIS_RUNS_AT="document-end" # by default, scripts run after page load
		for RUN_AT in `echo "$META" | grep "^\s*\/\/\s*@run-at"`; do
			THIS_RUNS_AT="`echo "$RUN_AT" | sed -e 's/^\s*\/\/\s*@run-at\s*//' -e 's/\./\\\\./g' -e 's/\*/.*/g' -e 's/[\r\n]//g'`"
		done
		if [ "$current_context" != "document-any" -a "$THIS_RUNS_AT" != "$current_context" ]; then
			SHOULD_RUN=0
		fi

		# Run the script
		if [ $SHOULD_RUN = 1 ]; then
			echo "script '$SCRIPT'" >> "$UZBL_FIFO"
		fi
	done
}

# TODO search XDG_DATA_DIRS
current_context="${1-document-any}"
do_scripts "`dirname $0`/../userscripts"
