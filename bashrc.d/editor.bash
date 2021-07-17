#
# set EDITOR, first one found in the list is the winner

EDITORS=(emacs zile vi)

for ED in "${EDITORS[@]}"
do
    FULLPATH=$(which $ED 2>/dev/null)
    if [ $? -eq 0 ]; then
        alias ue=$FULLPATH
        export EDITOR=$FULLPATH
        break
    fi
done
