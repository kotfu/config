#
# aliases for managing favorite directories

export FDIR_FILE=~/.fdirs

function _fdirs_removeblanks() {
	local FDIRS=$(cat $FDIR_FILE)
	echo "$FDIRS" | grep . > $FDIR_FILE
}

# go to a favorite directory
function f() {
	# TODO add --value= parameter with arguments
	local NEWDIR=$(cat $FDIR_FILE | gum filter --no-fuzzy --placeholder="cd to...")
	# expand tilde's in the directory
	case "$NEWDIR" in "~"*)
		NEWDIR=${NEWDIR/#'~'/$HOME}
	esac
	# change there
	cd $NEWDIR
}

# save a given directory, or the current directory as a favorite
function fa() {
	_fdirs_removeblanks
    if [ $# -eq 0 ]; then
		# add the current directory as a favorite
		# now replace $HOME with ~
		local NEWFAV=${PWD/#$HOME/'~'}
		# save it as a favorite if it doesn't exist already
		grep -qxF "$NEWFAV" $FDIR_FILE || echo "$NEWFAV" >> $FDIR_FILE
    else
		# save the diven directories as favorites
		local DIR
		for DIR in "$@"; do
			# replace $HOME with ~
			local NEWFAV=${DIR/#$HOME/'~'}
			# check if it's in the file, if not, then add it
			grep -qxF "$NEWFAV" $FDIR_FILE || echo "$NEWFAV" >> $FDIR_FILE
		done
    fi
	fls
}

# remove a directory as a favorite
function frm() {
	_fdirs_removeblanks
	if [ $# -eq 0 ]; then
		local RMFAV=$(cat $FDIR_FILE | gum filter --no-fuzzy --placeholder="remove favorite...")
		# slurp the file into a variable, so we don't read and write to the file at the same time
		# and remove the matching directory before writing the file back out
		local SLURP=$(cat $FDIR_FILE)
		echo "$SLURP" | grep -xF -v "$RMFAV" > $FDIR_FILE
	else
		# remove all given directories from favorites
		local DIR
		for DIR in "$@"; do
			# replace $HOME with ~
			local RMFAV=${DIR/#$HOME/'~'}
			# slurp the file into a variable, so we don't read and write to the file at the same time
			# and remove the matching directory before writing the file back out
			local SLURP=$(cat $FDIR_FILE)
			echo "$SLURP" | grep -xF -v "$RMFAV" > $FDIR_FILE		
		done
		
	fi
	fls
}

# edit the file
function fe() {
	$EDITOR $FDIR_FILE
}

# cat the file
function fls() {
	cat $FDIR_FILE | less --quit-at-eof --quit-if-one-screen
}
