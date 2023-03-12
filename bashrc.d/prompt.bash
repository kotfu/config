#
# set the prompt

if [ $(whoami) == 'root' ]; then
    PS1="\h:\w# "
else
    PS1="\h:\w>"
fi
