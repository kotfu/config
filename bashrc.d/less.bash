#
# set up less

export PAGER=less
export LESS='--hilite-search --ignore-case --jump-target=4 -Pless\: %f ?m(file %i of %m) .(-line %lb--?pb%pb\%:---.-?eeof:---.-)'

[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
