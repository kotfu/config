#
# if virtualenvwrapper is installed, activate it

PYENV=$(which pyenv 2>/dev/null)
if [ $? == 0 ]; then
    eval "$(pyenv init -)"
    VENV=$(pyenv virtualenv-init -)
    if [ $? == 0 ]; then
        eval "$(pyenv virtualenv-init -)"
        export VIRTUAL_ENV_DISABLE_PROMPT=yes
    fi
fi
