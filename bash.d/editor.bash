#
# set EDITOR

ZILE=$(which zile)
if [ $? -eq 0 ]; then
    alias ue=$ZILE
fi
export EDITOR=$ZILE
