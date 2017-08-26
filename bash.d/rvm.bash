#
# if rvm is installed, hook it up

if [[ -s "$HOME/.rvm/scripts/rvm" ]]; then
    export PATH="$PATH:$HOME/.rvm/bin"
    source "$HOME/.rvm/scripts/rvm"
fi
