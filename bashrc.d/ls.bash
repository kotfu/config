#
# nice functions for listing files

if which eza >/dev/null 2>&1; then
    # eza is installed, use it
    function l () {
        local LS="eza -l --group --color=always"
        if [ $# -eq 0 ]; then
            local LSCMD="$LS"
        else
            if [[ "$@" =~ ^- ]]; then
                # looks like there could be options
                local LSCMD="$LS $@"
            else
                # no options, probably a filename, I don't like to list the contents
                # of a directory, so give the -d option
                local LSCMD="$LS -d $@"
            fi
        fi
        $LSCMD | qless -r
    }
    function lt() {
        # list a tree
        eza -l --group --tree --color=always "$@" | qless -r
    }
    function la () {
        # for ls
        local LS="eza -al --group --color=always"
        if [ $# -eq 0 ]; then
            local LSCMD="$LS"
        else
            if [[ "$@" =~ ^- ]]; then
                # command line options include more options for ls
                local LSCMD="$LS $@"
            else
                # command line options name a file or directory, don't show the contents
                local LSCMD="$LS -d $@"
            fi
        fi
        $LSCMD | qless -r
    }
    function lat () {
        # list a tree showing dotfiles
        eza -al --group --tree --color=always "$@" | qless -r
    }
else
    # for ls
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

        $LSCMD --color=always | grep -v '^total' | qless -r
    }
    function la() {
        # for ls
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

        $LSCMD | grep -v '^total' | qless -r
    }
fi
