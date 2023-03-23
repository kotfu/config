# config

My collection of home directory config and script files, including various bash tools


## Clearing up common misunderstandings

`~/.profile` should set the path, and things like `~/.bashrc` should not. We have two
initilization chains, one intended to be run from `~/.profile`, and the other from
`~/.bashrc`.


## How to install

- Clone this repository to `~/config`
    ```
    $ git clone https://github.com/kotfu/config.git ~/config
    ```

- Type `~/config/update`
- add the following line to `~/.profile`:
    ```
    source ~/config/profile
    if [ -f ~/.bashrc ]; then
	    . ~/.bashrc
    fi
    ```
- add the following line to `~/.bashrc`:
    ```
    source ~/config/bashrc
    ```

## Updating

- type `~/config/update` to update the git repo and download updates to third party tools


## Prerequisites

You'll need bash, and also the following command line tools:

- git
- curl
- less
- fzf
- gum (used by shell themekit)
- coreutils package (macos and openbsd) - so you get color ls

## Other packages to install

- you need a [Nerd Font](https://www.nerdfonts.com/) - I typically use MesloLGL Nerd Font Mono and it's configured in iterm2 in Settings → Profiles → Text
- [bat](https://github.com/sharkdp/bat) - a better cat
- [lesspipe](https://github.com/wofr06/lesspipe) - less preprocessor
- [delta](https://github.com/dandavison/delta) - better viewer for git and diff output
- MacOS modern bash (it ships with an old version)
  - `brew install bash`
  - `brew install bash-completion@2`
- duf
- emacs
- pyenv
- starship
- shell-themekit


## Customizing

If you put the git repo somewhere besides `~/config`, set the `CONFIG_DIR`
variable to the directory where you put the repo.

If you have anything that it unique to the current machine that you want to
have run when you log in, put it in `~/.profile` or `~/.bashrc` before or after
you source the appropriate files in `~/config/`



## Todo

- make a standard env var for less options to make a minimal pager like we use for l or la
- revise fzf keybindings
- check out https://github.com/shyiko/dotfiles
- get https://github.com/rupa/z?
- https://github.com/clvv/fasd
- local copy of lesspipe? https://github.com/wofr06/lesspipe
