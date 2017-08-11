#
# if virtualenvwrapper is installed, activate it
WRAPPER=$(which virtualenvwrapper.sh)
if [ $? == 0 ]; then
    VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python3
    VIRTUAL_ENV_DISABLE_PROMPT=yes
    WORKON_HOME=$HOME/.virtualenvs
    PROJECT_HOME=$HOME/src
    source $WRAPPER
fi
