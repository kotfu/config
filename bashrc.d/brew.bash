#
# set the brew environment variables and bash completion
# brew should already be in our path

# skip the part of brew shellenv which adds to the path, because it's
#   a) already done by profile.d/brew.bash
#   b) dumb because it adds duplicates


if type brew &>/dev/null; then
    # make sure brew is installed
    eval "$( brew shellenv | grep -v 'export PATH')"

    if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]; then
        source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
    else
        for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*; do
            [[ -r "$COMPLETION" ]] && source "$COMPLETION"
        done
    fi
fi
