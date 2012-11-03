#!/bin/sh

do_scripts() {
	scripts_dir="$1"
	if [ -z $2 ]; then
		current_context="all"
	else
		current_context="$2" # should be document-end or document-start or all
	fi
	IFS="
	"
	# Loop over all userscripts in the directory
	for SCRIPT in `grep -lx "\s*//\s*==UserScript==\s*" "$scripts_dir"/*`; do
		SCRIPT="`readlink -en "$SCRIPT"`"
		# Extract metadata chunk
		META="`sed -ne '/^\s*\/\/\s*==UserScript==\s*$/,/^\s*\/\/\s*==\/UserScript==\s*$/p' "$SCRIPT"`"
		RUNS_AT=document-end # By default, run only on document end
		SHOULD_RUN=false # Assume this script will not be included
		# Loop over all include rules
		for INCLUDE in `echo "$META" | grep "^\s*\/\/\s*@include"`; do
			# Munge into grep pattern
			INCLUDE="`echo "$INCLUDE" | sed -e 's/^\s*\/\/\s*@include\s*//' -e 's/\./\\\\./g' -e 's/\*/.*/g' -e 's/[\r\n]//g'`"
			if echo "$UZBL_URI" | grep -x "$INCLUDE"; then
				SHOULD_RUN=true
				break
			fi
		done
		# Loop over all exclude rules
		for EXCLUDE in `echo "$META" | grep "^\s*\/\/\s*@exclude"`; do
			# Munge into grep pattern
			EXCLUDE="`echo "$EXCLUDE" | sed -e 's/^\s*\/\/\s*@exclude\s*//' -e 's/\./\\\\./g' -e 's/\*/.*/g' -e 's/[\r\n]//g'`"
			if echo "$url" | grep -x "$EXCLUDE"; then
				SHOULD_RUN=false
				break
			fi
		done
		# Find run-at code
		THIS_RUNS_AT="document-end" # by default, scripts run after page load
		for RUN_AT in `echo "$META" | grep "^\s*\/\/\s*@run-at"`; do
			THIS_RUNS_AT="`echo "$RUN_AT" | sed -e 's/^\s*\/\/\s*@run-at\s*//' -e 's/\./\\\\./g' -e 's/\*/.*/g' -e 's/[\r\n]//g'`"
		done
		if [ "$current_context" != "all" -a "$THIS_RUNS_AT" != "$current_context" ]; then
			SHOULD_RUN=false
		fi

		# Run the script
		if [ $SHOULD_RUN = true ]; then
			echo "script '$SCRIPT'" >> "$UZBL_FIFO"
		fi
	done
}

# TODO search XDG_DATA_DIRS
do_scripts "`dirname $0`/../userscripts" "$1"
