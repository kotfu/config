# How to Setup Python

## Get pyenv and friends

On macOS via brew:
```
$ brew install pyenv
$ brew install pyenv-virtualenv
```

Otherwise:
```
$ curl -L https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash
$ git clone https://github.com/pyenv/pyenv-virtualenv.git $(pyenv root)/plugins/pyenv-virtualenv
```


## Install pythons

```
$ pyenv install 2.7.13
$ pyenv install 3.6.2
```

Add more pythons if you need them.

## Create virtualenvs

```
$ pyenv virtualenv 3.6.2 virtual-env-name
```

When using pyenv-virtualenv the virtualenv you create sets the version of python is was created with as well as the packages.

## List virtualenvs

This only lists the virtual envs:
```
$ pyenv virtualenvs
```

This lists all the pythons (which have their own default set of packages) and the virtualenvs:
```
$ pyenv versions
```

## Activate virtualenvs

Manually:
```
$ pyenv activate virtual-env-name
```

You can automatically select virtualenvs and the pythons that created them
using `.python-version` files, which can be managed with `pyenv local`

See what version and virtualenv you are using:
```
$ pyenv version
```
