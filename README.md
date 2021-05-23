# config

My collection of home directory config and script files, including various bash tools


## How to install

- Clone this repository to `~/config`
    ```
    $ git clone https://github.com/kotfu/config.git ~/config
    ```

- Type `~/config/update`
- add the following line to `~/.bashrc` and `~/.profile`:
    ```
    source ~/config/bashrc
    ```
  You want to add it to both initialization files so that this stuff
  will all get run whether you launch bash as a login shell or not.


## Updating

- type `~/config/update` to update the git repo and download updates to third party tools


## Prerequisites

You'll need bash, and also the following command line tools:

- git
- curl


## Customizing

If you put the git repo somewhere besides `~/config`, set the `CONFIG_DIR`
variable to the directory where you put the repo.

If you have anything that it unique to the current machine that you want to
have run when you log in, put it in `~/.localprofile`. This file gets sourced
very last, and is intended to be host specific, and not in the config repo.


## Other packages to install

- [bat](https://github.com/sharkdp/bat) - a better cat


## Todo

- check out https://github.com/shyiko/dotfiles
- get https://github.com/rupa/z?
- https://github.com/clvv/fasd
- https://github.com/junegunn/fzf - from brew?
- bbedit support in EDITORS
- local copy of lesspipe? https://github.com/wofr06/lesspipe
