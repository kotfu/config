# load starship for our prompt, if it is installed

STARPATH=$(which starship 2>/dev/null)
if [ $? -eq 0 ]; then
	eval "$(starship init bash)"
fi
export STARSHIP_CONFIG=~/.starship
