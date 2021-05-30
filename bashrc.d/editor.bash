#
# set EDITOR, preferred choices are later in the list

EDITORS=(zile emacs)

for ED in "${EDITORS[@]}"
do
    FULLPATH=$(which $ED)
    if [ $? -eq 0 ]; then
        alias ue=$FULLPATH
        export EDITOR=$FULLPATH
    fi
done
