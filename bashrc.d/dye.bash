#
# set up dye https://dye-your-shell.net


# this should be set when we initialize dye
if [ -z ${DYE_DIR+x} ]; then
    DYE_DIR=$CONFIG_DIR/dye
fi
if [ ! -d $DYE_DIR ]; then
    echo "Please set DYE_DIR in ~/.profile to point to the directory containing your theme files"
    return 1
fi
export DYE_DIR

# these have to be functions instead of scripts so they can add environment
# variables to the "parent" shell

# we don't want to do any of this theming stuff if it isn't an interactive shell
if [[ ! $- == *i* ]]; then
    return
fi

# dye a pattern
# dye-pattern [FILE | theme_name]
function dye-pattern() {

    if [[ -z "$1" ]]; then
        # collect default options
        local FZFOPTS="${FZF_DEFAULT_OPTS:-} ${THEME_FZF_OPTS:-}"
        # fzf parses command line options a bit wierd, hard to make the quoting
        # work right, so we use the trick of temporarily overriding FZF_DEFAULT_OPTS
        local NEWPAT=$(shell-themer list | FZF_DEFAULT_OPTS="$FZFOPTS" fzf)
        if [[ -n $NEWPAT ]]; then
            export DYE_PATTERN_FILE="$DYE_DIR/$NEWPAT.toml"
        else
            return 1
        fi
    elif [[ -f "$DYE_DIR/$1" ]]; then
        # a pattern name with toml, go find it in the dye directory
        export DYE_PATTERN_FILE="$DYE_DIR/$1"
    elif [[ -f "$DYE_DIR/$1.toml" ]]; then
        # a bare theme name
        export DYE_PATTERN_FILE="$DYE_DIR/$1.toml"
    else
        printf "%s: pattern not found\n" "$1"
        return 1
    fi
    dye-apply
}

# (re)apply the theme using dye
function dye-apply() {
    source <(dye apply)
}

dye-pattern noctis-obscuro
