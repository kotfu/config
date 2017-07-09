#
#

# TODO platform specific search for and installation of completions
for bc in "$CONFIG_DIR/bash_completion.d/*"; do
    source $bc
done
