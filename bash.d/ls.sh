#
# nice functions for listing files

function l () {
    if [ $# -eq 0 ]; then
        local LSCMD="ls -l"
        local LSCNT=$(( $( $LSCMD 2>/dev/null | wc -l) + 0 ))
    else
        if [[ "$@" =~ ^- ]]; then
            local LSCMD="ls -l $@"
        else
            local LSCMD="ls -ld $@"
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
        local LSCMD="ls -Al"
        local LSCNT=$(( $( $LSCMD 2>/dev/null | wc -l) + 0 ))
    else
        if [[ "$@" =~ ^- ]]; then
            local LSCMD="ls -Al $@"
        else
            local LSCMD="ls -Ald $@"
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
