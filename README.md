# config
My collection of home directory config files, including various bash tools

## How to install

- Clone this repository to ~/config
- add the following line to ```~/.bashrc``` or ```~/.profile```:

        source ~/config/bashrc

## Prerequisites
You'll need bash, and also the following command line tools
- git
- curl

## Customizing

You can customize various behaviors by setting environment variables in
```.bashrc``` or ```.profile``` before you source ```~/config/bashrc```

CONFIG_DIR - if you put the git repo somewhere besides ```~/config```, set
this variable to the directory where you put the repo

```~/.localprofile``` - this file gets sourced very last, so you can
override or add anything that you want. This file is intended to be host
specific, and not in the config repo




## Todo

- bash completion https://github.com/scop/bash-completion
- get https://github.com/rupa/z
- https://github.com/clvv/fasd
- https://github.com/junegunn/fzf - from brew?
- bbedit support in EDITORS
- local copy of lesspipe?
- get la() to show dotfiles first and then regular files
