#
# shell options and settings

set -o emacs
export IGNOREEOF=1
# make echo do the escape sequences by default
shopt -s xpg_echo
shopt -s extglob cdspell checkwinsize no_empty_cmd_completion
# update $LINES and $COLUMNS
shopt -s checkwinsize

# set up shell history
shopt -s histappend
HISTSIZE=1000
HISTFILESIZE=2000
HISTCONTROL=ignoredups:ignorespace

if [ $(whoami) == 'root' ]; then
    PS1="\h:\w# "
else
    PS1="\h:\w>"
fi
