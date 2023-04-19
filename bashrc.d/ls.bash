#
# nice functions for listing files

function l () {
    local LS="ls"
    if [[ $OSTYPE =~ darwin* ]]; then
        # have to `brew install coreutils` to get this
        # we use gls because it's dircolors are more flexible than the
        # ls that comes with macos
        LS="gls"
    fi
    if [[ $OSTYPE =~ openbsd* ]]; then
        # have to 'pkg_add coreutils' to get this
        # openbsd ls doesn't have color support
        LS="gls"
    fi
    if [ $# -eq 0 ]; then
        local LSCMD="$LS -lh"
    else
        if [[ "$@" =~ ^- ]]; then
            local LSCMD="$LS -lh $@"
        else
            local LSCMD="$LS -lhd $@"
        fi
    fi

    local LESSCMD="less --quit-at-eof --quit-if-one-screen --tilde --no-init --chop-long-lines"
    # openbsd less draws horribly if --quit-if-one-screen and if the
    # output is less than one screen long
    # adding --clear-screen fixes it, but it breaks output on other
    # operating systems, so we only add it if it's openbsd
    if [[ $OSTYPE =~ openbsd* ]]; then
        LESSCMD+=" --clear-screen"
    fi
    $LSCMD --color=always | grep -v '^total' | $LESSCMD
}

function la() {
    local LS="ls"
    if [[ $OSTYPE =~ darwin* ]]; then
        # have to `brew install coreutils` to get this
        # we use gls because it's dircolors are more flexible than the
        # ls that comes with macos
        LS="gls"
    fi
    if [[ $OSTYPE =~ openbsd* ]]; then
        # have to 'pkg_add coreutils' to get this
        # openbsd ls doesn't have color support
        LS="gls"
    fi
    if [ $# -eq 0 ]; then
        # on macos dotfiles are always shown first when you do:
        # local LSCMD="ls -alh --color=always"
        # but on linux, they are not
        # this incantation always shows dotfiles first
        #local LSCMD="($LS -lhd --color=always .* 2>/dev/null ; ls -lh --color=always)"
        local LSCMD="$LS -Alh --color=always"
    else
        if [[ "$@" =~ ^- ]]; then
            # command line options include more options for ls
            local LSCMD="$LS -Alh --color=always $@"
        else
            # command line options name a file or directory, don't show the contents
            local LSCMD="$LS -Alhd --color=always $@"
        fi
    fi

    local LESSCMD="less --quit-at-eof --quit-if-one-screen --tilde --no-init --chop-long-lines"
    # openbsd less draws horribly if --quit-if-one-screen and if the
    # output is less than one screen long
    # adding --clear-screen fixes it, but it breaks output on other
    # operating systems, so we only add it if it's openbsd
    if [[ $OSTYPE =~ openbsd* ]]; then
        LESSCMD+=" --clear-screen"
    fi
    $LSCMD | grep -v '^total' | $LESSCMD
}
