#
# modular .bashrc
#
# add the following to ~/.bashrc
#
# source config/bashrc
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


# a function to check if files exist in BASHRC_DIR and source them
function _bd_source {
    local BASHRC_DIR=$CONFIG_DIR/bashrc.d
    if [ -r $BASHRC_DIR/$1 ]; then
        logr source $BASHRC_DIR/$1
        source $BASHRC_DIR/$1
    else
        logr warn $BASHRC_DIR/$1 not found
    fi
}

# source our various config files
_bd_source shellopts.bash
_bd_source alias.bash
_bd_source less.bash
_bd_source man_colorizer.bash
_bd_source clipboard.bash
_bd_source editor.bash
_bd_source commacd.sh
_bd_source bashmarks.bash
_bd_source bd.bash
_bd_source iterm2_shell_integration.bash
_bd_source pyenv.bash
_bd_source ls.bash
_bd_source bash_completion.bash
