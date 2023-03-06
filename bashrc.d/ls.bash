#
# nice functions for listing files

function l () {
    if [ $# -eq 0 ]; then
        local LSCMD="ls -lh"
    else
        if [[ "$@" =~ ^- ]]; then
            local LSCMD="ls -lh $@"
        else
            local LSCMD="ls -lhd $@"
        fi
    fi

	local LESSCMD="less --quit-at-eof --quit-if-one-screen"
    eval "$LSCMD --color=always | grep -v '^total' | $LESSCMD"
}

function la() {
    if [ $# -eq 0 ]; then
        local LSCMD="ls -alh --color=always"
    else
        if [[ "$@" =~ ^- ]]; then
			# command line options include more options for ls
            local LSCMD="ls -Alh --color=always $@"
        else
			# command line options name a file or directory, don't show the contents
            local LSCMD="ls -Alhd --color=always $@"
        fi
    fi

	local LESSCMD="less --quit-at-eof --quit-if-one-screen"
    eval "$LSCMD | grep -v '^total' | $LESSCMD"
}
