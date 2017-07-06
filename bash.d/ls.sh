#
# nice functions for listing files

function l () {
    if [ $# -eq 0 ]; then
        local LSCMD="ls -lh"
        local LSCNT=$(( $( $LSCMD 2>/dev/null | wc -l) + 0 ))
    else
        if [[ "$@" =~ ^- ]]; then
            local LSCMD="ls -lh $@"
        else
            local LSCMD="ls -lhd $@"
        fi
        local LSCNT=$(( $( $LSCMD 2>/dev/null | wc -l) + 0 ))
    fi

    if [ $LSCNT -ge $LINES ]; then
        #eval "$LSCMD | grep -v '^total' | less -e"
        eval "$LSCMD | less -e"
    else
        #eval "$LSCMD | grep -v '^total'"
        eval "$LSCMD"
    fi
}

function la() {
    if [ $# -eq 0 ]; then
        local LSCMD="ls -Alh"
        local LSCNT=$(( $( $LSCMD 2>/dev/null | wc -l) + 0 ))
    else
        if [[ "$@" =~ ^- ]]; then
            local LSCMD="ls -Alh $@"
        else
            local LSCMD="ls -Alhd $@"
        fi
        #local LSCMD="ls -Al $@"
        local LSCNT=$(( $( $LSCMD 2>/dev/null | wc -l) + 0 ))
    fi

    if [ $LSCNT -ge $LINES ]; then
        #eval "$LSCMD | grep -v '^total' | less -e"
        eval "$LSCMD | less -e"
    else
        #eval "$LSCMD | grep -v '^total'"
        eval "$LSCMD"
    fi
}
