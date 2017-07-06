#
# nice functions for listing files

function l () {
    if [ $# -eq 0 ]; then
        local LSCMD="ls -ld *"
        local LSCNT=$(( $( $LSCMD | wc -l) + 0 ))
    else
        local LSCMD="ls -ld $@"
        local LSCNT=$(( $( $LSCMD | wc -l) + 0 ))
    fi

    if [ $LSCNT -ge $LINES ]; then
        eval "$LSCMD | grep -v '^total' | less -e"
    else
        eval "$LSCMD | grep -v '^total'"
    fi
}

function la() {
    if [ $# -eq 0 ]; then
        local LSCMD="ls -ald .* *"
        local LSCNT=$(( $( $LSCMD | wc -l) + 0 ))
    else
        local LSCMD="ls -ald $@"
        local LSCNT=$(( $( $LSCMD | wc -l) + 0 ))
    fi

    if [ $LSCNT -ge $LINES ]; then
        eval "$LSCMD | grep -v '^total' | less -e"
    else
        eval "$LSCMD | grep -v '^total'"
    fi
}
