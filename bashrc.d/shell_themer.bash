#
# set up shell-themer


# this should be set when we initialize themekit
if [ -z ${THEME_DIR+x} ]; then
    THEME_DIR=$CONFIG_DIR/themes
fi
if [ ! -d $THEME_DIR ]; then
    echo "Please set THEME_DIR in ~/.profile to point to the directory containing your theme files"
    return
fi
export THEME_DIR

# these have to be functions instead of scripts so they can add environment
# variables to the "parent" shell

# activate a theme
# theme-activate [FILE | theme_name]
function theme-activate() {

    if [[ -z "$1" ]]; then
        printf "no theme to activate\n"
        return 1
    elif [[ -d "$1" ]]; then
        # a directory given on the command line
        export THEME_FILE=$1
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
    eval $(shell-themer)
}

theme-activate dracula