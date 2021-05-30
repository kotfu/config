#

PYENV=$(which pyenv 2>/dev/null)
if [ $? == 0 ]; then
    export PYENV_ROOT="$HOME/.pyenv"
    _assure_in_path "$PYENV_ROOT/bin"
    eval "$(pyenv init --path)"
fi
