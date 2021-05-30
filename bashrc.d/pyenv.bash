#
# if pyenv is installed, activate it and pyenv-virtualenv

PYENV=$(which pyenv 2>/dev/null)
if [ $? == 0 ]; then
    eval "$(pyenv init -)"
    VENV=$(pyenv virtualenv-init - 2>/dev/null)
    if [ $? == 0 ]; then
        eval "$(pyenv virtualenv-init -)"
        export VIRTUAL_ENV_DISABLE_PROMPT=yes
    fi
fi
