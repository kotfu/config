#
# setup fzf

#if [[ ! "$PATH" == */opt/homebrew/opt/fzf/bin* ]]; then
#  PATH="${PATH:+${PATH}:}/opt/homebrew/opt/fzf/bin"
#fi

# auto-completion
[[ $- == *i* ]] && source "$CONFIG_DIR/submodules/fzf/shell/completion.bash" 2> /dev/null

# key bindings
source "$CONFIG_DIR/submodules/fzf/shell/key-bindings.bash"
