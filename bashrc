#
# standard bashrc
#

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
_bd_source commacd.bash
_bd_source bashmarks.bash
_bd_source bd.bash
_bd_source iterm2_shell_integration.bash
_bd_source pyenv.bash
_bd_source ls.bash
_bd_source bash_completion.bash
