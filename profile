#
# modular .profile
#
# add the following to ~/.profile
#
# source config/profile
#

if [ -z ${CONFIG_DIR+x} ]; then
    CONFIG_DIR=~/config
fi
if [ ! -d $CONFIG_DIR ]; then
    echo "Please set CONFIG_DIR in ~/.profile to point to the directory of the config repo"
    return
fi
export CONFIG_DIR

# configure logging
source $CONFIG_DIR/profile.d/logging.bash

# set a base path
PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin
logr PATH=$PATH

# prepend an entry to our path
# if the directory exists
# making sure not to add duplicates
function _assure_in_path {
    # we use 0 for true, or success, like most other shell commands
    local TESTPATH=$1
    if [ -d "$TESTPATH" ]; then
        if [[ ":$PATH:" != *":$TESTPATH:"* ]]; then
            PATH="$TESTPATH:$PATH"
            logr adding $TESTPATH to PATH
        else
            logr $TESTPATH already in PATH
        fi
    fi
}

_assure_in_path "$CONFIG_DIR/bin"

# a function to check if files exist in PROFILE_DIR and source them
function _pd_source {
    local PROFILE_DIR=$CONFIG_DIR/profile.d
    if [ -r $PROFILE_DIR/$1 ]; then
        logr source $PROFILE_DIR/$1
        source $PROFILE_DIR/$1
    else
        logr warn $PROFILE_DIR/$1 not found
    fi
}

# source our various config files
_pd_source brew.bash
_pd_source homebin.bash
_pd_source pyenv.bash
_pd_source rvm.bash
_pd_source visualstudiocode.bash
