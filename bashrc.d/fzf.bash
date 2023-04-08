#
# setup fzf

#if [[ ! "$PATH" == */opt/homebrew/opt/fzf/bin* ]]; then
#  PATH="${PATH:+${PATH}:}/opt/homebrew/opt/fzf/bin"
#fi

# auto-completion
[[ $- == *i* ]] && source "$CONFIG_DIR/submodules/fzf/shell/completion.bash" 2> /dev/null

# key bindings
# source "$CONFIG_DIR/submodules/fzf/shell/key-bindings.bash"


#     ____      ____
#    / __/___  / __/
#   / /_/_  / / /_
#  / __/ / /_/ __/
# /_/   /___/_/ key-bindings.bash
#

# same as function included with FZF, just renamed command and opts environment variables
__fzf_select_current__() {
  local cmd opts
  cmd="${FZF_SELECT_CURRENT_COMMAND:-"command find -L . -mindepth 1 \\( -path '*/\\.*' -o -fstype 'sysfs' -o -fstype 'devfs' -o -fstype 'devtmpfs' -o -fstype 'proc' \\) -prune \
    -o -type f -print \
    -o -type d -print \
    -o -type l -print 2> /dev/null | cut -b3-"}"
  opts="--height ${FZF_TMUX_HEIGHT:-40%} --bind=ctrl-z:ignore --reverse ${FZF_DEFAULT_OPTS-} ${FZF_SELECT_OPTS-} -m"
  eval "$cmd" |
    FZF_DEFAULT_OPTS="$opts" $(__fzfcmd) "$@" |
    while read -r item; do
      # printf '%q ' "$item"  # escape special chars
      printf '%s ' "$item"
    done
}

__fzf_select_home__() {
  local cmd opts
  cmd="${FZF_SELECT_HOME_COMMAND:-"command find -L ~ -mindepth 1 \\( -path '*/\\.*' -o -fstype 'sysfs' -o -fstype 'devfs' -o -fstype 'devtmpfs' -o -fstype 'proc' \\) -prune \
    -o -type f -print \
    -o -type d -print \
    -o -type l -print 2> /dev/null | cut -b3-"}"
  opts="--height ${FZF_TMUX_HEIGHT:-40%} --bind=ctrl-z:ignore --reverse ${FZF_DEFAULT_OPTS-} ${FZF_SELECT_OPTS-} -m"
  eval "$cmd" |
    FZF_DEFAULT_OPTS="$opts" $(__fzfcmd) "$@" |
    while read -r item; do
      # printf '%q ' "$item"  # escape special chars
      printf '%s ' "$item"
    done
}

if [[ $- =~ i ]]; then

__fzfcmd() {
  [[ -n "${TMUX_PANE-}" ]] && { [[ "${FZF_TMUX:-0}" != 0 ]] || [[ -n "${FZF_TMUX_OPTS-}" ]]; } &&
    echo "fzf-tmux ${FZF_TMUX_OPTS:--d${FZF_TMUX_HEIGHT:-40%}} -- " || echo "fzf"
}

fzf-select-current() {
  local selected="$(__fzf_select_current__ "$@")"
  READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}$selected${READLINE_LINE:$READLINE_POINT}"
  READLINE_POINT=$(( READLINE_POINT + ${#selected} ))
}

fzf-select-home() {
  local selected="$(__fzf_select_home__ "$@")"
  READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}$selected${READLINE_LINE:$READLINE_POINT}"
  READLINE_POINT=$(( READLINE_POINT + ${#selected} ))
}

# same as function included with fzf, just renamed command and opts environment variables
__fzf_cd__() {
  local cmd opts dir
  cmd="${FZF_CD_COMMAND:-"command find -L . -mindepth 1 \\( -path '*/\\.*' -o -fstype 'sysfs' -o -fstype 'devfs' -o -fstype 'devtmpfs' -o -fstype 'proc' \\) -prune \
    -o -type d -print 2> /dev/null | cut -b3-"}"
  opts="--height ${FZF_TMUX_HEIGHT:-40%} --bind=ctrl-z:ignore --reverse ${FZF_DEFAULT_OPTS-} ${FZF_CD_OPTS-} +m"
  if [[ -n "$1" ]]; then
    # prime the pump with the argument(s), and tell fzf to select it if there
    # is exactly one match
    opts+=" --query='$@'"
  fi
  dir=$(eval "$cmd" | FZF_DEFAULT_OPTS="$opts" $(__fzfcmd)) && printf 'builtin cd -- %q' "$dir"
}

__fzf_history__() {
  local output opts script
  opts="--height ${FZF_TMUX_HEIGHT:-40%} --bind=ctrl-z:ignore ${FZF_DEFAULT_OPTS-} -n2..,.. --scheme=history --bind=ctrl-r:toggle-sort ${FZF_CTRL_R_OPTS-} +m --read0"
  script='BEGIN { getc; $/ = "\n\t"; $HISTCOUNT = $ENV{last_hist} + 1 } s/^[ *]//; print $HISTCOUNT - $. . "\t$_" if !$seen{$_}++'
  output=$(
    builtin fc -lnr -2147483648 |
      last_hist=$(HISTTIMEFORMAT='' builtin history 1) perl -n -l0 -e "$script" |
      FZF_DEFAULT_OPTS="$opts" $(__fzfcmd) --query "$READLINE_LINE"
  ) || return
  READLINE_LINE=${output#*$'\t'}
  if [[ -z "$READLINE_POINT" ]]; then
    echo "$READLINE_LINE"
  else
    READLINE_POINT=0x7fffffff
  fi
}

c() {
    eval $(__fzf_cd__ $@)
}

# Required to refresh the prompt after fzf
bind -m emacs-standard '"\er": redraw-current-line'

#bind -m vi-command '"\C-z": emacs-editing-mode'
#bind -m vi-insert '"\C-z": emacs-editing-mode'
#bind -m emacs-standard '"\C-z": vi-editing-mode'

# CTRL-R - Paste the selected command from history into the command line
bind -m emacs-standard -x '"\C-r": __fzf_history__'
bind -m vi-command -x '"\C-r": __fzf_history__'
bind -m vi-insert -x '"\C-r": __fzf_history__'

# fzf defaults this to CTRL-T, I have changed it to CTRL-O
bind -m emacs-standard -x '"\C-o": fzf-select-current'
bind -m vi-command -x '"\C-o": fzf-select-current'
bind -m vi-insert -x '"\C-o": fzf-select-current'

# ALT-O or ESC-O to select from home dir instead of current dir
bind -m emacs-standard -x '"\eo": fzf-select-home'
bind -m vi-command -x '"\eo": fzf-select-home'
bind -m vi-insert -x '"\eo": fzf-select-home'



# ALT-C - cd into the selected directory
#bind -m emacs-standard '"\ec": " \C-b\C-k \C-u`__fzf_cd__`\e\C-e\er\C-m\C-y\C-h\e \C-y\ey\C-x\C-x\C-d"'
#bind -m vi-command '"\ec": "\C-z\ec\C-z"'
#bind -m vi-insert '"\ec": "\C-z\ec\C-z"'

fi
