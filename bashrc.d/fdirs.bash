#
# aliases for managing favorite directories

export FDIR_FILE=~/.fdirs

function _fdirs_removeblanks() {
    # ensure the file exists and remove empty lines from it
    if [[ ! -f "$FDIR_FILE" ]]; then
        touch "$FDIR_FILE"
    fi
	local FDIRS=$(cat $FDIR_FILE)
	echo "$FDIRS" | grep . > "$FDIR_FILE"
}

# go to a favorite directory
function f() {
    _fdirs_removeblanks
    local NEWDIR=""
    # they typed something on the command line
    local REQUESTED="$1"
    if [[ $# -gt 0 ]]; then
        # if gum filter would autoselect if there was only a single
        # option that matched what you passed in --value, then we
        # wouldn't need the code in here. I've made a feature
        # request, maybe someday in the future...

        # replace $HOME with ~
        REQUESTED=${REQUESTED/#$HOME/'~'}
        # see if there is a single full-line match in the file
        MATCHES=$(grep -cF "$REQUESTED" "$FDIR_FILE" )
        if [[ $MATCHES -eq 1 ]]; then
            # we got exactly one match, go get the new dir
            NEWDIR=$(grep -F "$REQUESTED" "$FDIR_FILE" | head -1)
        fi
    fi

    if [[ -z "$NEWDIR" ]]; then
        # we are going to have to prompt for it using `gum filter`
        local VALUE=""
        if [ -n "$REQUESTED" ]; then
            VALUE="--value=$REQUESTED"
        fi

        local GUMOPTS=("filter" "--reverse" "--no-fuzzy" "--placeholder=cd to ..." $VALUE)
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
        #echo cat "$FDIR_FILE" pipe gum "${GUMOPTS[@]}"
        NEWDIR=$(cat "$FDIR_FILE" | gum "${GUMOPTS[@]}")
    fi

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
    local FAIL=0
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
            # get the full path of the diretory
            if [ -d "$DIR" ]; then
                local NEWFAV=$(realpath "$DIR" 2>/dev/null)
                # realpath removes trailing slashes, so no need
                # to remove them here
                if [ -n "$NEWFAV" ]; then
                    # replace $HOME with ~
                    NEWFAV=${NEWFAV/#$HOME/'~'}
                    # check if it's in the file, if not, then add it
                    grep -qxF "$NEWFAV" "$FDIR_FILE" || echo "$NEWFAV" >> "$FDIR_FILE"
                fi
            else
                printf "fa: %s: no such file or directory\n" "$DIR"
                return 1
            fi
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
            local RMFAV
            if [ -d "$DIR" ]; then
                RMFAV=$(realpath "$DIR" 2>/dev/null)
            else
                # the directory does't exist, we can't resolve it
                # but we can still try and remove it from the favorites
                RMFAV=$DIR
            fi
            if [ -n "$RMFAV" ]; then
                # replace $HOME with ~
                RMFAV=${RMFAV/#$HOME/'~'}
                # remove trailing slashes
                shopt -s extglob
                RMFAV=${RMFAV%%+(/)}
                # slurp the favorites file into a variable, so we don't read and write
                # to the file at the same time, and remove the matching directory before
                # writing the file back out
    	    	local SLURP=$(cat $FDIR_FILE)
	    	    echo "$SLURP" | grep -xF -v "$RMFAV" > "$FDIR_FILE"
            fi
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
