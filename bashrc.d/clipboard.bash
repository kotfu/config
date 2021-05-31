#
# http://brettterpstra.com/2015/04/27/a-universal-clipboard-command-for-bash/
#
# copy darn near anything to the clipboard in macos

if [[ ! $OSTYPE =~ darwin* ]]; then
    exit 0
fi

clipboard() {
	if [[ $1 == "-h" || $1 == "-H" || $1 == "--help" ]]; then
		echo "Intelligently copies command results, text file, or raw text to"
		echo "OS X clipboard"
		echo
		echo "Usage: clipboard [command or text]"
		echo "  or pipe a command: [command] | clipboard"
		return
	fi

	local output
	local res=false
	local tmpfile="${TMPDIR}/clipboard.$RANDOM.txt"
	local msg=""

	if [[ $# == 0 ]]; then
		output=$(cat)
		msg="Input copied to clipboard"
		res=true
	else
		local cmd=""
		for arg in $@; do
			cmd+="\"$(echo -en $arg|sed -E 's/"/\\"/g')\" "
		done
		output=$(eval "$cmd" 2> /dev/null)
		if [[ $? == 0 ]]; then
			msg="Results of command are in the clipboard"
			res=true
		else
			if [[ -f $1 ]]; then
				output=""
				for arg in $@; do
					if [[ -f $arg ]]; then
						type=`file "$arg"|grep -c text`
						if [ $type -gt 0 ]; then
							output+=$(cat $arg)
							msg+="Contents of $arg are in the clipboard."
							res=true
						else
							msg+="File \"$arg\" is not plain text."
						fi
					fi
				done
			else
				output=$@
				msg="Text copied to clipboard"
				res=true
			fi
		fi
	fi

	$res && echo -ne "$output" | pbcopy -Prefer txt
	echo -e "$msg"
}
