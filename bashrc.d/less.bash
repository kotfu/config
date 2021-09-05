#
# set up less

export PAGER=less
export LESS='--raw-control-chars --hilite-search --ignore-case --jump-target=4 -Pless\: %f ?m(file %i of %m) .(-line %lb--?pb%pb\%:---.-?eeof:---.-)'

# potential names for lesspipe, later ones in the list will override
LPIPES=(lesspipe.sh lesspipe)
LESSPIPE=0
for LPIPE in "${LPIPES[@]}"
do
    FULLPATH=$(which $LPIPE 2>/dev/null)
    if [ $? -eq 0 ]; then
        LESSPIPE=1
        eval "$(SHELL=/bin/sh $LPIPE)"
        # less has to be build with support for this, but it doesn't
        # hurt anything to set it
        export LESS_ADVANCED_PREPROCESSOR=1
    fi
done
