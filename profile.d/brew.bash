#
# configure homebrew
#

# brew shellenv is recursively dumb because brew has to be in your
# path in order to run, then it adds the brew prefix directory
# to your path again.

# so we find brew on our own, if it's installed

BREWS=( /opt/homebrew /usr/local )
BREW=""

for BREW_PREFIX in "${BREWS[@]}"
do
    if [ -d "$BREW_PREFIX/bin/brew" ]; then
        BREW="$BREW_PREFIX/bin/brew"
        break
    fi
done

if [ ! -z "$BREW" ]; then
    # we have brew, BREW_PREFIX should point to the prefix
    _assure_in_path $BREW_PREFIX/bin
    _assure_in_path $BREW_PREFIX/sbin
fi
