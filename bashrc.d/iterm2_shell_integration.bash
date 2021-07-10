#
# load iterm2 integration if that's our terminal program

IT2SCRIPT=$CONFIG_DIR/lib/iterm2_shell_integration.bash

if isiterm2; then
    if [ -r $IT2SCRIPT ]; then
        logr verbose
        logr "iTerm2 detected, loading shell integration"
        logr quiet
        source $IT2SCRIPT
    fi
fi
