#
# useful aliases

alias ..='builtin cd ..'
alias clean='rm -f *~ .*~ core 2>/dev/null'
alias du='du -h'
alias ssh='ssh -A'
alias bc='bc -lq'

alias y='open -a Yoink'

DUFPATH=$(which duf 2>/dev/null)
if [ $? -eq 0 ]; then
    alias df='duf'
else
    alias df='df -h'
fi
