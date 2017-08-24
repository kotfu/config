#
# if virtualenvwrapper is installed, activate it
PYENV=$(which pyenv)
if [ $? == 0 ]; then
    eval "$(pyenv init -)"
fi
