#
# standard bashrc to load all my things

if [ -z ${CONFIG_DIR+x} ]; then
    CONFIG_DIR=~/config
fi
if [ ! -d $CONFIG_DIR ]; then
    echo "Please set CONFIG_DIR to point to the directory of the config repo"
    return
fi
export CONFIG_DIR

# a function to check if files exist in BASH_DIR and source them
function _bd_source {
    local BASH_DIR=$CONFIG_DIR/bash.d
    if [ -r $BASH_DIR/$1 ]; then
        source $BASH_DIR/$1
    fi

}

# prepend an entry to our path, makeing sure not to add duplicates
function _assure_in_path {
    # we use 0 for true, or success, like most other shell commands
    local TESTPATH=$1
    if [[ ":$PATH:" != *":$TESTPATH:"* ]]; then
        PATH="$TESTPATH:$PATH"
    fi
}

# source our various config files
_bd_source shellopts.bash
_bd_source alias.bash
_bd_source less.bash
_bd_source ls.bash
_bd_source editor.bash
_bd_source commacd.bash
_bd_source bd.bash
_bd_source iterm2_shell_integration.bash
_bd_source rvm.bash
_bd_source bash_completion.bash

_assure_in_path "$CONFIG_DIR/bin"

# give a chance for a per-host-not-part-of-config to override anything
if [ -r ~/.localprofile ]; then
    source ~/.localprofile
fi
