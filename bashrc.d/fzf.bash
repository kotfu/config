#
# setup fzf

#if [[ ! "$PATH" == */opt/homebrew/opt/fzf/bin* ]]; then
#  PATH="${PATH:+${PATH}:}/opt/homebrew/opt/fzf/bin"
#fi

# auto-completion
[[ $- == *i* ]] && source "$CONFIG_DIR/submodules/fzf/shell/completion.bash" 2> /dev/null

# key bindings
source "$CONFIG_DIR/submodules/fzf/shell/key-bindings.bash"

# this is mostly the same as __fzf_cd__
function c ()
{
    local cmd opts dir;
    cmd="${FZF_ALT_C_COMMAND:-"command find -L . -mindepth 1 \\( -path '*/\\.*' -o -fstype 'sysfs' -o -fstype 'devfs' -o -fstype 'devtmpfs' -o -fstype 'proc' \\) -prune     -o -type d -print 2> /dev/null | cut -b3-"}";
    opts="--height ${FZF_TMUX_HEIGHT:-40%} --bind=ctrl-z:ignore --reverse ${FZF_DEFAULT_OPTS-} ${FZF_ALT_C_OPTS-} +m";
    dir=$(eval "$cmd" | FZF_DEFAULT_OPTS="$opts" $(__fzfcmd)) && builtin cd -- "$dir"
}
