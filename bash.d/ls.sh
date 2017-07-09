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
    local LSCNT=$( $LSCMD 2>/dev/null | wc -l )
    #LSCNT=$(( $LSCNT + 0 ))

    if [ $LSCNT -ge $LINES ]; then
        eval "$LSCMD | grep -v '^total' | less -e"
    else
        eval "$LSCMD | grep -v '^total'"
    fi
}

function la() {
    if [ $# -eq 0 ]; then
        # see if we have an empty directory
        local LSCNT=$( ls -lhd * 2>/dev/null | wc -l )
        if [ $LSCNT -eq 0 ]; then
            # only show the two dotfiles, avoiding an error for ls *
            local LSCMD="ls -lhd .*"
        else
            # show everything
            local LSCMD="( ls -lhd .* && ls -lhd * )"
        fi
    else
        if [[ "$@" =~ ^- ]]; then
            local LSCMD="ls -Alh $@"
        else
            local LSCMD="ls -Alhd $@"
        fi
    fi
    local LSCNT=$(eval $LSCMD 2>/dev/null | wc -l)
    #LSCNT=$(( $LSCNT + 0 ))

    if [ $LSCNT -ge $LINES ]; then
        eval "$LSCMD | grep -v '^total' | less -e"
    else
        eval "$LSCMD | grep -v '^total'"
    fi
}
