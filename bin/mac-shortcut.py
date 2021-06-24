#!/usr/bin/env python3
#
# take practially any description of a mac shortcut and output
# a standardized representation of it
#
# Adapted from Brett Terpstra's kbd: https://github.com/ttscoff/JekyllPlugins/tree/master/KBDTag
#
# Use symbols for modifier keys (Command, Option, etc.).
# Apple's guidelines say to spell them out in most cases,
# but personally I prefer to use symbols.
# use_modifier_symbols: true

# Use symbols for non-character keys (Home, PgUp, Right Arrow, etc.).
# Again, Apple recommends spelling these out. A lot of the symbols are
# unfamiliar to users, like Home (↖) or Escape (⎋). Your choice.
# use_key_symbols: true

# When using symbols for modifiers, Apple recommends separating them
# with `+`. This looks like ⌘+⌥+C. Disable this to just output ⌘⌥C.
# Ignored if not using modifier symbols.
# use_plus_sign: true

import argparse
import re
import sys

# constants
VERSION_STRING = "1.0.0"
EXIT_SUCCESS = 0
EXIT_ERROR = 1
EXIT_USAGE = 2


def _build_parser():
    """build an arg parser with all the proper parameters"""
    parser = argparse.ArgumentParser(
        description="Create a standardized representation of a macOS keyboard shortcut"
    )
    parser.add_argument("shortcuts", nargs="+", help="keyboard shortcut(s)")

    parser.add_argument(
        "-v",
        "--version",
        action="version",
        version=VERSION_STRING,
        help="show the version information and exit",
    )

    parser.add_argument(
        "-m",
        "--modifier-symbols",
        action="store_true",
        help="output modifier symbols instead of modifier names",
    )

    parser.add_argument(
        "-k" "--key-symbols",
        action="store_true",
        help="output key symbols instead of key names",
    )

    parser.add_argument(
        "-p" "--plus-sign",
        action="store_true",
        help="output + between modifier symbols",
    )

    parser.add_argument(
        "-o",
        "--output",
        choices=["txt", "html"],
        default="txt",
        help="output format",
    )
    return parser


class Key:
    """store the name of a key, the html rendering of it, and a friendly text render of it"""

    def __init__(self, name, html):
        self.name = name
        self.html = html


class KeyboardShortcut:
    """methods to store and parse a keyboard shortcut

    The canonical representation of a keyboard shortcut is the same as is used in macOS
    keyboard bindings files, ie:

    * = fn
    ^ = control
    $ = shift
    ~ = option
    @ = command


    """

    # * isn't really a unicode version of the modifier, but it's included
    # here because we map between unicode and plaintext mods
    # these are in the order apple recommends they be presented
    _unicode_mods = ["*", "⌃", "⇧", "⌥", "⌘"]
    _plaintext_mods = ["*", "^", "$", "~", "@"]
    _unicode_plaintext_mods_trans = str.maketrans(
        "".join(_unicode_mods), "".join(_plaintext_mods)
    )

    # on parsing user input, allow specification of certain keynames
    # which may be mapped to the associated single character symbol
    # all names are in lower case
    # if a keyname is more than one character and not found in this list
    # then it is not valid
    _keyname_map = {
        "esc": "⎋",
        "escape": "⎋",
        "tab": "⇥",
        "caps": "⇪",
        "capslock": "⇪",
        "space": "␣",
        "eject": "⏏",
        "del": "⌫",
        "delete": "⌫",
        "back": "⌫",
        "backspace": "⌫",
        "fwddel": "⌦",
        "fwddelete": "⌦",
        "return": "↩",
        "rtn": "↩",
        "enter": "⌤",
        "ent": "⌤",
        "pageup": "⇞",
        "pgup": "⇞",
        "pagedown": "⇟",
        "pgdn": "⇟",
        "home": "↖",
        "end": "↘",
        "left": "←",
        "leftarrow": "←",
        "right": "→",
        "rightarrow": "→",
        "up": "↑",
        "uparrow": "↑",
        "down": "↓",
        "downarrow": "↓",
        "click": "leftclick",
        "leftclick": "leftclick",
        "rightclick": "rightclick",
        "rclick": "rightclick",
    }
    # programatically add function keys to the map
    for num in range(1, 100):
        fkey = "f{}".format(num)
        _keyname_map[fkey] = fkey

    # - if found in this dictionary, the "key" has an associated html entity,
    #   friendly name, and/or text description
    _keys = {}

    # shifted key translations
    _unshifted = r"abcdefghijklmnopqrstuvwxyz,./;'[]\1234567890-="
    _shifted = r'ABCDEFGHIJKLMNOPQRSTUVWXYZ<>?:"{}|!@#$%^&*()_+'
    _shifted_trans = str.maketrans(_unshifted, _shifted)

    def __init__(self, text):
        self._canonical = self._parse(text)

    def __repr__(self):
        return "KeyboardShortcut({})".format(self._canonical)

    def __str__(self):
        return self._canonical

    @classmethod
    def _parse(cls, text):
        # Only remove hyphens preceeded and followed by non-space character
        # to avoid removing the last hyphen from 'option-shift--' or 'command -'
        text = re.sub(r"(?<=\S)-(?=\S)", " ", text)
        text = re.sub(r"\b(comm(and)?|cmd|clover)\b", "@", text, re.IGNORECASE)
        text = re.sub(r"\b(cont(rol)?|ctl|ctrl)\b", "^", text, re.IGNORECASE)
        text = re.sub(r"\b(opt(ion)?|alt)\b", "~", text, re.IGNORECASE)
        text = re.sub(r"\bshift\b", "$", text, re.IGNORECASE)
        text = re.sub(r"\b(func(tion)?|fn)\b", "*", text, re.IGNORECASE)
        mods = []
        key = ""
        # add other regexes here
        for char in text.strip():
            if char == " ":
                continue
            elif char in cls._unicode_mods:
                # translate unicode modifier symbols to their plaintext equivilents
                mods.append(char.translate(cls._unicode_plaintext_mods_trans))
            elif char in "*^$@~":
                mods.append(char)
            else:
                key += char
        # remove duplicate modifiers
        mods = list(set(mods))
        # sort the mods to be in Apple's recommended order
        mods.sort(key=lambda x: cls._plaintext_mods.index(x))

        if len(key) == 1:
            if not mods and key in cls._shifted:
                # turn H into $H and { into ${
                mods.append("$")
            if "$" in mods:
                # shift is in the mods, turn lowercase letters and unshifted symbols
                # into their shifted equivilents
                key = key.translate(cls._shifted_trans)
        else:
            if key.lower() in cls._keyname_map:
                key = cls._keyname_map[key.lower()]
            else:
                raise ValueError("{} is not a valid key".format(key))
        return "".join(mods) + key


def _parse_shortcuts(text):
    """parse a string or array of text into a standard representation of the shortcut

    returns an array of shortcut combinations
    """
    combos = []
    for combo in re.split(r' / ', text):
        combos.append(KeyboardShortcut(combo))
    return combos


def main(argv=None):
    """main function"""
    parser = _build_parser()
    args = parser.parse_args(argv)
    combos = _parse_shortcuts(' '.join(args.shortcuts))


if __name__ == "__main__":
    sys.exit(main())


#
# embedded tests
#
# to run the test simply do
#
#   $ pytest mac-shortcut
#
# you can't use pytest decorators with this method, but you also don't
# import pytest and mock unless you run the tests. Tradeoffs. If you want
# to use decorators, move the imports in setup_module() to the top and then
# delete that function


def setup_module():
    global pytest
    global mock
    import pytest
    import mock


def test_ks_parse():
    parsemap = [
        ("command f", "@f"),
        ("command option r", "~@r"),
        ("⌘⌥⇧⌃r", "^$~@R"),
        ("command-shift-f", "$@F"),
        ("func 2", "*2"),
        ("shift-command--", "$@_"),
        ("control command  shift control H", "^$@H"),
        ("  command -", "@-"),
        ("command command q", "@q"),
        ("shift control \\", "^$|"),
        ("H", "$H"),
        ("shift p", "$P"),
        ("shift 4", "$$"),
        ("ctrl 6", "^6"),
        ("shift control 6", "^$^"),
        ("command right", "@→"),
        ("control command del", "^@⌫"),
        ("shift ESCAPE", "$⎋"),
        ("F7", "f7"),
    ]
    for text, canonical in parsemap:
        ks = KeyboardShortcut(text)
        assert str(ks) == canonical


def test_ks_parse_error():
    errors = [
        "Q99",
        "F0",
        "F100",
        "fred",
    ]
    for error in errors:
        with pytest.raises(ValueError):
            ks = KeyboardShortcut(error)


#def test_parse_empty():
#    assert _parse_shortcuts("") == [""]


def test_parse_3():
    assert len(_parse_shortcuts("F10 / shift-escape / control-option-right")) == 3
