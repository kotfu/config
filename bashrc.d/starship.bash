# load starship for our prompt, if it is installed

STARPATH=$(which starship 2>/dev/null)
if [ $? -eq 0 ]; then
	export STARSHIP_CONFIG=$CONFIG_DIR/conf/starship.toml
	eval "$(starship init bash)"
fi
