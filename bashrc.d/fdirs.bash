#
# aliases for managing favorite directories

export FDIR_FILE=~/.fdirs

function _fdirs_removeblanks() {
	# remove empty lines from $FDIR_FILE
	local FDIRS=$(cat $FDIR_FILE)
	echo "$FDIRS" | grep . > "$FDIR_FILE"
}

# go to a favorite directory
function f() {
	# TODO add --value= parameter with arguments
	local GUMOPTS=("filter" "--no-fuzzy" "--placeholder=cd to ...")
	if [[ -n "$THEME_FDIRS_TEXT" ]]; then
		GUMOPTS+=("--text.foreground=$THEME_FDIRS_TEXT")
	fi
	if [[ -n "$THEME_FDIRS_PROMPT" ]]; then
		GUMOPTS+=("--prompt.foreground=$THEME_FDIRS_PROMPT")
	fi
	if [[ -n "$THEME_FDIRS_INDICATOR" ]]; then
		GUMOPTS+=("--indicator.foreground=$THEME_FDIRS_INDICATOR")
	fi
	if [[ -n "$THEME_FDIRS_MATCH" ]]; then
		GUMOPTS+=("--match.foreground=$THEME_FDIRS_MATCH")
	fi	
	local NEWDIR=$(cat "$FDIR_FILE" | gum "${GUMOPTS[@]}")
	# expand tilde's in the directory
	case "$NEWDIR" in "~"*)
		NEWDIR=${NEWDIR/#'~'/$HOME}
	esac
	# change there
	local CDOPTS=("$NEWDIR")
	cd "${CDOPTS[@]}"
}

# save a given directory, or the current directory as a favorite
function fa() {
	_fdirs_removeblanks
    if [ $# -eq 0 ]; then
		# add the current directory as a favorite
		# now replace $HOME with ~
		local NEWFAV=${PWD/#$HOME/'~'}
		# save it as a favorite if it doesn't exist already
		grep -qxF "$NEWFAV" "$FDIR_FILE" || echo "$NEWFAV" >> "$FDIR_FILE"
    else
		# save the diven directories as favorites
		local DIR
		for DIR in "$@"; do
			# replace $HOME with ~
			local NEWFAV=${DIR/#$HOME/'~'}
			# check if it's in the file, if not, then add it
			grep -qxF "$NEWFAV" "$FDIR_FILE" || echo "$NEWFAV" >> "$FDIR_FILE"
		done
    fi
	fls
}

# remove a directory as a favorite
function frm() {
	_fdirs_removeblanks
	if [ $# -eq 0 ]; then
		local GUMOPTS=("filter" "--no-fuzzy" "--placeholder=cd to ...")
		if [[ -n "$THEME_FDIRS_TEXT" ]]; then
			GUMOPTS+=("--text.foreground=$THEME_FDIRS_TEXT")
		fi
		if [[ -n "$THEME_FDIRS_PROMPT" ]]; then
			GUMOPTS+=("--prompt.foreground=$THEME_FDIRS_PROMPT")
		fi
		if [[ -n "$THEME_FDIRS_INDICATOR" ]]; then
			GUMOPTS+=("--indicator.foreground=$THEME_FDIRS_INDICATOR")
		fi
		if [[ -n "$THEME_FDIRS_MATCH" ]]; then
			GUMOPTS+=("--match.foreground=$THEME_FDIRS_MATCH")
		fi	
		local RMFAV=$(cat $FDIR_FILE | gum "${GUMOPTS[@]}")
		# slurp the file into a variable, so we don't read and write to the file at the same time
		# and remove the matching directory before writing the file back out
		local SLURP=$(cat $FDIR_FILE)
		echo "$SLURP" | grep -xF -v "$RMFAV" > "$FDIR_FILE"
	else
		# remove all given directories from favorites
		local DIR
		for DIR in "$@"; do
			# replace $HOME with ~
			local RMFAV=${DIR/#$HOME/'~'}
			# slurp the file into a variable, so we don't read and write to the file at the same time
			# and remove the matching directory before writing the file back out
			local SLURP=$(cat $FDIR_FILE)
			echo "$SLURP" | grep -xF -v "$RMFAV" > "$FDIR_FILE"
		done
		
	fi
	fls
}

# edit the file
function fe() {
	$EDITOR $FDIR_FILE
}

# cat the file
function fls() {
	cat $FDIR_FILE | less --quit-at-eof --quit-if-one-screen
}
