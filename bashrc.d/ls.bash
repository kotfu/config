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
		# on macos dotfiles are always shown first when you do:
        # local LSCMD="ls -alh --color=always"
		# but on linux, they are not
		# this incantation always shows dotfiles first
		local LSCMD="(ls -lhd --color=always .* 2>/dev/null ; ls -l --color=always)"
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
