#
#

if [[ $OSTYPE =~ linux* ]]; then
    # only do the system ones if it's an interactive shell
    if [ -n "$PS1" ]; then
        USBC=/usr/share/bash-completion/bash_completion
        EBC=/etc/bash_completion
        if [ -f $USBC ]; then
            . $USBC
        elif [ -f $EBC ]; then
            . $EBC
        else
            logr verbose
            logr notice no system bash completions found
            logr quiet
        fi
        # this picks up all the completions in /etc/bash_completion.d
    fi
fi


if [[ $OSTYPE =~ darwin* ]]; then
    BREW_PREFIX=$( brew --prefix )
    if [ $? -eq 0 ]; then
        if [ -n "$PS1" ]; then
            BC=$BREW_PREFIX/share/bash-completion/bash_completion
            if [ -f $BC ]; then
                . $BC
            else
                logr verbose
                logr notice no system bash completions found
                logr quiet
            fi
            # this picks up all the completions in /usr/local/etc/bash_completion.d
        fi
    fi
fi

# TODO figure out where/how to get bash-completion for OpenBSD

# finally, do our own bash_completions
for bc in "$CONFIG_DIR/bash_completion.d/*"; do
    source $bc
done
