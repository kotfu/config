#
# standard bashrc to load all my things

if [ -z ${CONFIG_DIR+x} ]; then
    CONFIG_DIR=~/config
fi
export CONFIG_DIR

BASH_DIR=$CONFIG_DIR/bash.d

# a function to check if files exist in BASH_DIR and source them
function bd_source {
    if [ -r $BASH_DIR/$1 ]; then
        source $BASH_DIR/$1
    fi

}

# source our various config files
bd_source shellopts.sh
bd_source alias.sh
bd_source less.sh
bd_source ls.sh
bd_source editor.sh
bd_source iterm2.sh
bd_source rvm.sh

# give a chance for a per-host-not-part-of-config to override anything
if [ -r ~/.localprofile ]; then
    source ~/.localprofile
fi
