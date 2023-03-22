#
# aliases for managing favorite directories

# if you want to override the file to use to save your
# favorite directories, just set $FDIR_FILE
# before you source this
if [[ -z $FDIR_FILE ]]; then
    export FDIR_FILE=~/.fdirs
fi

#
# ensure the file exists and remove empty lines from it
function _fdirs_removeblanks() {
    if [[ ! -f "$FDIR_FILE" ]]; then
        touch "$FDIR_FILE"
    fi
	local FDIRS=$(cat $FDIR_FILE)
	echo "$FDIRS" | grep . > "$FDIR_FILE"
}

#
# cd to a favorite directory, fuzzy searching your list of favorites
function f() {
    local FZFOPTS=("--scheme=path" "--pointer=•" "--info=hidden" "-i" "--no-sort")
    FZFOPTS+=("--color=fg:regular:$THEME_FDIRS_TEXT")
    # fg+ and bg+ are colors for the currently selected line
    FZFOPTS+=("--color=fg+:regular,bg+:regular:$THEME_FDIRS_SELECTED,gutter:-1")
    FZFOPTS+=("--color=pointer:$THEME_FDIRS_INDICATOR")
    FZFOPTS+=("--color=query:regular:$THEME_FDIRS_MATCH")
    FZFOPTS+=("--color=hl:regular:$THEME_FDIRS_MATCH,hl+:regular:$THEME_FDIRS_MATCH")
    FZFOPTS+=("--color=prompt:$THEME_FDIRS_PROMPT")
    if [[ -n "$1" ]]; then
        # prime the pump with the argument, and tell fzf to select it if there
        # is exactly one match
        FZFOPTS+=("--query=$1" "--select-1")
    fi
    local NEWDIR=$(cat "$FDIR_FILE" | fzf "${FZFOPTS[@]}")

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

#
# remove a favorite
function frm() {
    _fdirs_removeblanks
    local FZFOPTS=("--scheme=path" "--pointer=•" "--info=hidden" "-i" "--no-sort")
    FZFOPTS+=("--color=fg:regular:$THEME_FDIRS_TEXT")
    # fg+ and bg+ are colors for the currently selected line
    FZFOPTS+=("--color=fg+:regular,bg+:regular:$THEME_FDIRS_SELECTED,gutter:-1")
    FZFOPTS+=("--color=pointer:$THEME_FDIRS_INDICATOR")
    FZFOPTS+=("--color=query:regular:$THEME_FDIRS_MATCH")
    FZFOPTS+=("--color=hl:regular:$THEME_FDIRS_MATCH,hl+:regular:$THEME_FDIRS_MATCH")
    FZFOPTS+=("--color=prompt:$THEME_FDIRS_PROMPT")
    if [[ -n "$1" ]]; then
        # prime the pump with the argument, and tell fzf to select it if there
        # is exactly one match
        FZFOPTS+=("--query=$1" "--select-1")
    fi
    local RMDIR=$(cat "$FDIR_FILE" | fzf "${FZFOPTS[@]}")

    if [[ -n $RMDIR ]]; then
        # slurp the favorites file into a variable, so we don't read and write
        # to the file at the same time, and remove the matching directory before
        # writing the file back out
        local SLURP=$(cat $FDIR_FILE)
        echo "$SLURP" | grep -xF -v "$RMDIR" > "$FDIR_FILE"
        fls
    else
        return 1
    fi
}

#
# edit the file
function fe() {
	$EDITOR $FDIR_FILE
}

#
# cat the file
function fls() {
	cat $FDIR_FILE | less --quit-at-eof --quit-if-one-screen
}
