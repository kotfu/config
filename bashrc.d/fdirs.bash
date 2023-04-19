#
# aliases for managing favorite directories
#
# These aliases use fzf for the user interface. They all honor
# the FZF_DEFAULT_OPTIONS environment variable for command line
# options. They also look at the FDIRS_FZF_OPTS environment
# variable for more fzf command line options.
#
# if you want to override the file where your favorite directories
# are stored, just set $FDIRS_FILE before your source this file
# the default is ~/.fdirs
#

if [[ -z $FDIRS_FILE ]]; then
    export FDIRS_FILE=~/.fdirs
fi

#
# ensure the file exists and remove empty lines from it
function _fdirs_removeblanks() {
    if [[ ! -f "$FDIRS_FILE" ]]; then
        touch "$FDIRS_FILE"
    fi
	local FDIRS=$(cat $FDIRS_FILE)
	echo "$FDIRS" | grep . > "$FDIRS_FILE"
}

#
# cd to a favorite directory, fuzzy searching your list of favorites
function f() {
    # collect default options
    local FZFOPTS="${FZF_DEFAULT_OPTS:-} ${FDIRS_FZF_OPTS:-}"
    # here on down overrides anything from the environment variables
    FZFOPTS+=" --border-label='change directory to:' --border-label-pos=3"
    if [[ -n "$1" ]]; then
        # prime the pump with the argument, and tell fzf to select it if there
        # is exactly one match
        FZFOPTS+=" --query=$1 --select-1"
    fi
    if [[ ! -r "$FDIRS_FILE" ]]; then
        echo f: "$FDIRS_FILE": file not found
    fi
    # fzf parses command line options a bit wierd, hard to make the quoting
    # work right, so we use the trick of temporarily overriding FZF_DEFAULT_OPTS
    local NEWDIR=$(cat "$FDIRS_FILE" | FZF_DEFAULT_OPTS="$FZFOPTS" fzf)

    if [[ -n $NEWDIR ]]; then
        # expand tilde's in the directory
        case "$NEWDIR" in "~"*)
            NEWDIR=${NEWDIR/#'~'/$HOME}
        esac
        # change there
        builtin cd "$NEWDIR"
    else
        return 1
    fi
}

#
# save a given directory, or the current directory, as a favorite
function fa() {
	_fdirs_removeblanks
    local FAIL=0
    if [ $# -eq 0 ]; then
		# add the current directory as a favorite
		# now replace $HOME with ~
		local NEWFAV=${PWD/#$HOME/'~'}
		# save it as a favorite if it doesn't exist already
		grep -qxF "$NEWFAV" "$FDIRS_FILE" || echo "$NEWFAV" >> "$FDIRS_FILE"
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
                    grep -qxF "$NEWFAV" "$FDIRS_FILE" || echo "$NEWFAV" >> "$FDIRS_FILE"
                fi
            else
                printf "fa: %s: no such file or directory\n" "$DIR"
                return 1
            fi
		done
    fi
	fls
}

#
# remove a favorite
function frm() {
    _fdirs_removeblanks
    # collect default options
    local FZFOPTS="${FZF_DEFAULT_OPTS:-} ${FDIRS_FZF_OPTS:-}"
    # here on down overrides anything from the environment variables
    FZFOPTS+=" --border-label='remove favorite:' --border-label-pos=3"
    if [[ -n "$1" ]]; then
        # prime the pump with the argument
        FZFOPTS+=" --query=$1"
    fi
    local RMDIR=$(cat "$FDIRS_FILE" | FZF_DEFAULT_OPTS="$FZFOPTS" fzf)

    if [[ -n $RMDIR ]]; then
        # slurp the favorites file into a variable, so we don't read and write
        # to the file at the same time, and remove the matching directory before
        # writing the file back out
        local SLURP=$(cat $FDIRS_FILE)
        echo "$SLURP" | grep -xF -v "$RMDIR" > "$FDIRS_FILE"
    else
        return 1
    fi
}

#
# edit the file
function fe() {
	$EDITOR $FDIRS_FILE
}

#
# cat the file
function fls() {
	cat $FDIRS_FILE | less --quit-at-eof --quit-if-one-screen
}
