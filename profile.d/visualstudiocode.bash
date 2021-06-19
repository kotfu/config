#
# add Visual Studio Code mac command line tools to the path if it exists

DIR="/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
if [ -d "$DIR" ]
then
    _assure_in_path "$DIR"
fi
