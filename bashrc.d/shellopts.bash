#
# shell options and settings

set -o emacs
export IGNOREEOF=1
# make echo do the escape sequences by default
shopt -s xpg_echo
shopt -s extglob cdspell checkwinsize no_empty_cmd_completion
# update $LINES and $COLUMNS
shopt -s checkwinsize

if [ $(whoami) == 'root' ]; then
    PS1="\h:\w# "
else
    PS1="\h:\w>"
fi
