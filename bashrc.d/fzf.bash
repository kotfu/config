#
# setup fzf

#if [[ ! "$PATH" == */opt/homebrew/opt/fzf/bin* ]]; then
#  PATH="${PATH:+${PATH}:}/opt/homebrew/opt/fzf/bin"
#fi

# auto-completion
[[ $- == *i* ]] && source "$CONFIG_DIR/submodules/fzf/shell/completion.bash" 2> /dev/null

# key bindings
# source "$CONFIG_DIR/submodules/fzf/shell/key-bindings.bash"

function __control_r_fzf_opts() {
    local FZFOPTS=("--pointer=•" "--info=hidden" "-i" "--no-sort")
    # "--height=~40%"
#    FZFOPTS+=("--layout=reverse")
    FZFOPTS+=("--border" "--border-label='command history'" "--border-label-pos=3")
    # set colors
    FZFOPTS+=("--color=fg:regular:$THEME_FDIRS_TEXT,label:$THEME_FDIRS_LABEL")
    # the border
    FZFOPTS+=("--color=border:$THEME_FDIRS_BORDER")
    # fg+ and bg+ are colors for the currently selected line
    FZFOPTS+=("--color=fg+:regular,bg+:regular:$THEME_FDIRS_SELECTED,gutter:-1")
    # the indicator pointing to the selected item, and the prompt in front of the
    # characters yous type
    FZFOPTS+=("--color=pointer:$THEME_FDIRS_INDICATOR,prompt:$THEME_FDIRS_PROMPT")
    # these are the characters you type
    FZFOPTS+=("--color=query:regular:$THEME_FDIRS_MATCH")
    # hl is the highlighted characters that match the search
    FZFOPTS+=("--color=hl:regular:$THEME_FDIRS_MATCH,hl+:regular:$THEME_FDIRS_MATCH")
    echo ${FZFOPTS[@]}
}
export FZF_CTRL_R_OPTS="$(__control_r_fzf_opts)"

#     ____      ____
#    / __/___  / __/
#   / /_/_  / / /_
#  / __/ / /_/ __/
# /_/   /___/_/ key-bindings.bash
#
# - $FZF_TMUX_OPTS
# - $FZF_CTRL_T_COMMAND
# - $FZF_CTRL_T_OPTS
# - $FZF_CTRL_R_OPTS
# - $FZF_ALT_C_COMMAND
# - $FZF_ALT_C_OPTS

# Key bindings
# ------------
__fzf_select__() {
  local cmd opts
  cmd="${FZF_CTRL_T_COMMAND:-"command find -L . -mindepth 1 \\( -path '*/\\.*' -o -fstype 'sysfs' -o -fstype 'devfs' -o -fstype 'devtmpfs' -o -fstype 'proc' \\) -prune \
    -o -type f -print \
    -o -type d -print \
    -o -type l -print 2> /dev/null | cut -b3-"}"
  opts="--height ${FZF_TMUX_HEIGHT:-40%} --bind=ctrl-z:ignore --reverse ${FZF_DEFAULT_OPTS-} ${FZF_CTRL_T_OPTS-} -m"
  eval "$cmd" |
    FZF_DEFAULT_OPTS="$opts" $(__fzfcmd) "$@" |
    while read -r item; do
      printf '%q ' "$item"  # escape special chars
    done
}

if [[ $- =~ i ]]; then

__fzfcmd() {
  [[ -n "${TMUX_PANE-}" ]] && { [[ "${FZF_TMUX:-0}" != 0 ]] || [[ -n "${FZF_TMUX_OPTS-}" ]]; } &&
    echo "fzf-tmux ${FZF_TMUX_OPTS:--d${FZF_TMUX_HEIGHT:-40%}} -- " || echo "fzf"
}

fzf-file-widget() {
  local selected="$(__fzf_select__ "$@")"
  READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}$selected${READLINE_LINE:$READLINE_POINT}"
  READLINE_POINT=$(( READLINE_POINT + ${#selected} ))
}

__fzf_cd__() {
  local cmd opts dir
  cmd="${FZF_ALT_C_COMMAND:-"command find -L . -mindepth 1 \\( -path '*/\\.*' -o -fstype 'sysfs' -o -fstype 'devfs' -o -fstype 'devtmpfs' -o -fstype 'proc' \\) -prune \
    -o -type d -print 2> /dev/null | cut -b3-"}"
  opts="--height ${FZF_TMUX_HEIGHT:-40%} --bind=ctrl-z:ignore --reverse ${FZF_DEFAULT_OPTS-} ${FZF_ALT_C_OPTS-} +m"
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

# Required to refresh the prompt after fzf
bind -m emacs-standard '"\er": redraw-current-line'

bind -m vi-command '"\C-z": emacs-editing-mode'
bind -m vi-insert '"\C-z": emacs-editing-mode'
bind -m emacs-standard '"\C-z": vi-editing-mode'

# CTRL-R - Paste the selected command from history into the command line
bind -m emacs-standard -x '"\C-r": __fzf_history__'
bind -m vi-command -x '"\C-r": __fzf_history__'
bind -m vi-insert -x '"\C-r": __fzf_history__'


# CTRL-T - Paste the selected file path into the command line
bind -m emacs-standard -x '"\C-t": fzf-file-widget'
bind -m vi-command -x '"\C-t": fzf-file-widget'
bind -m vi-insert -x '"\C-t": fzf-file-widget'


# ALT-C - cd into the selected directory
bind -m emacs-standard '"\ec": " \C-b\C-k \C-u`__fzf_cd__`\e\C-e\er\C-m\C-y\C-h\e \C-y\ey\C-x\C-x\C-d"'
bind -m vi-command '"\ec": "\C-z\ec\C-z"'
bind -m vi-insert '"\ec": "\C-z\ec\C-z"'

fi



# this is mostly the same as __fzf_cd__
function c ()
{
    local cmd opts dir;
    cmd="${FZF_ALT_C_COMMAND:-"command find -L . -mindepth 1 \\( -path '*/\\.*' -o -fstype 'sysfs' -o -fstype 'devfs' -o -fstype 'devtmpfs' -o -fstype 'proc' \\) -prune     -o -type d -print 2> /dev/null | cut -b3-"}";
    opts="--height ${FZF_TMUX_HEIGHT:-40%} --bind=ctrl-z:ignore --reverse ${FZF_DEFAULT_OPTS-} ${FZF_ALT_C_OPTS-} +m";
    dir=$(eval "$cmd" | FZF_DEFAULT_OPTS="$opts" $(__fzfcmd)) && builtin cd -- "$dir"
}
