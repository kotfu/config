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
        local LSCMD="( ls -lhd .* && ls -lhd * )"
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
