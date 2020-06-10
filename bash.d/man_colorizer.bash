#
# add color highlighting to man pages
#
# via https://boredzo.org/blog/archives/2016-08-15/colorized-man-pages-understood-and-customized
#
# mb = start blinking
# md = start bold
# me = end all
# so = start standout (i.e. inverse)
# se = end standout
# us = start underline
# ue = end underline
#
function man() {
    env \
        LESS_TERMCAP_mb=$(printf "\e[1;33m") \
        LESS_TERMCAP_md=$(printf "\e[1;36m") \
        LESS_TERMCAP_me=$(printf "\e[0m") \
        LESS_TERMCAP_se=$(printf "\e[0m") \
        LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
        LESS_TERMCAP_ue=$(printf "\e[0m") \
        LESS_TERMCAP_us=$(printf "\e[1;32m") \
            command man "$@"
}
