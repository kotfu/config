#
# nice functions for listing files

function l () {
    local LSCNT=$(( $(ls $@ | wc -l) + 0 ))
    if [ $LSCNT -ge $LINES ]; then
        ls -ld "$@" | grep -v '^total' | less -e
    else
        ls -ld "$@" | grep -v '^total'
    fi
}

function la() {
    if [ $# -eq 0 ]; then
        LSCMD="ls -ald .* *"
        LSCNT=$(( $( $LSCMD | wc -l) + 0 ))
    else
        LSCMD="ls -ald $@"
        LSCNT=$(( $( $LSCMD | wc -l) + 0 ))
    fi

    if [ $LSCNT -ge $LINES ]; then
        eval "$LSCMD | grep -v '^total' | less -e"
    else
        eval "$LSCMD | grep -v '^total'"
    fi
}
