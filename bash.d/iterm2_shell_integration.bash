#
# load iterm2 integration if that's our terminal program

IT2SCRIPT=$CONFIG_DIR/lib/iterm2_shell_integration.bash

if [[ $TERM_PROGRAM == iTerm.app ]]; then
   if [ -r $IT2SCRIPT ]; then
      echo "iTerm2 detected, loading shell integration"
      source $IT2SCRIPT
   fi
fi
