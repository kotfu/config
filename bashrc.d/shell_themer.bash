#
# set up shell-themer


# this should be set when we initialize themekit
if [ -z ${THEME_DIR+x} ]; then
    THEME_DIR=$CONFIG_DIR/themes
fi
if [ ! -d $THEME_DIR ]; then
    echo "Please set THEME_DIR in ~/.profile to point to the directory containing your theme files"
    return 1
fi
export THEME_DIR

# these have to be functions instead of scripts so they can add environment
# variables to the "parent" shell

# we don't want to do any of this theming stuff if it isn't an interactive shell
if [[ ! $- == *i* ]]; then
    return
fi

# activate a theme
# theme-activate [FILE | theme_name]
function theme-activate() {

    if [[ -z "$1" ]]; then
        # collect default options
        local FZFOPTS="${FZF_DEFAULT_OPTS:-} ${THEME_FZF_OPTS:-}"
        # fzf parses command line options a bit wierd, hard to make the quoting
        # work right, so we use the trick of temporarily overriding FZF_DEFAULT_OPTS
        local NEWTHEME=$(shell-themer list | FZF_DEFAULT_OPTS="$FZFOPTS" fzf)
        if [[ -n $NEWTHEME ]]; then
            export THEME_FILE="$THEME_DIR/$NEWTHEME.toml"
        else
            return 1
        fi
    elif [[ -f "$THEME_DIR/$1" ]]; then
        # a theme name with toml, go find it in the themes directory
        export THEME_FILE="$THEME_DIR/$1"
    elif [[ -f "$THEME_DIR/$1.toml" ]]; then
        # a bare theme name
        export THEME_FILE="$THEME_DIR/$1.toml"
    else
        printf "%s: theme not found\n" "$1"
        return 1
    fi
    theme-reload
}

# (re)load the theme using shell-themer
function theme-reload() {
    # this process substitution outputs a blank line to stdout
    # which bothers me, so I redirect it to devnull
    source <(shell-themer activate)
}

theme-activate noctis-obscuro
