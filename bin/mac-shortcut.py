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

# to be removed later
import pytest

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
        "-k",
        "--key-symbols",
        action="store_true",
        help="output key symbols instead of key names",
    )

    parser.add_argument(
        "-p",
        "--plus-sign",
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

    def __init__(self, key, name, html):
        self.key = key
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
    _mods_plaintext = ["*", "^", "~", "$", "@"]
    _mods_unicode = ["*", "⌃", "⌥", "⇧", "⌘"]
    _mods_names = ["Fn", "Control", "Option", "Shift", "Command"]
    _unicode_plaintext_mods_trans = str.maketrans(
        "".join(_mods_unicode), "".join(_mods_plaintext)
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
    _fkeys = []
    # programatically add function keys
    for num in range(1, 100):
        fkey = "F{}".format(num)
        _fkeys.append(fkey)

    # - if found in this dictionary, the "key" has an associated html entity,
    #   friendly name, and/or text description
    # _keys = {
    #    "⎋": Key("⎋", "Escape", "html escape"),
    # }

    # shifted key translations
    _unshifted_keys = r",./;'[]\1234567890-="
    _shifted_keys = r'<>?:"{}|!@#$%^&*()_+'
    _to_shifted_trans = str.maketrans(_unshifted_keys, _shifted_keys)
    _to_unshifted_trans = str.maketrans(_shifted_keys, _unshifted_keys)

    # modifier -> name map
    _mod_name_map = {
        "*": "",
    }

    def __init__(self, text):
        # mods is a string, key is also a string
        # if key is alphabetic, it's stored in upper
        # case
        self.mods, self.key = self._parse(text)
        self.canonical = "".join(self.mods) + self.key

    def __repr__(self):
        return "KeyboardShortcut({})".format(self.canonical)

    def __str__(self):
        return self.canonical

    @classmethod
    def _parse(cls, text):
        """parse input into a canonical non-unicode representation of the shortcut

        letters are always stored as lower case
        """
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
            elif char in cls._mods_unicode:
                # translate unicode modifier symbols to their plaintext equivilents
                mods.append(char.translate(cls._unicode_plaintext_mods_trans))
            elif char in cls._mods_plaintext:
                mods.append(char)
            else:
                key += char

        if len(key) == 1:
            if key in cls._shifted_keys:
                # command % should be command shift 5
                # but command ? should be command ?
                # these ↓ are the shifted number keys
                if key in "!@#$%^&*()":
                    mods.append("$")  # duplicates will get removed later
                    key = key.translate(cls._to_unshifted_trans)
                else:
                    mods = [mod for mod in mods if mod != "$"]
            else:
                if "$" in mods:
                    # shift is in the mods, and the key is unshifted
                    # we should have the shifted symbol unless it is
                    # a number or letter
                    # command shift 5 should remain command shift 5
                    # and command shift r should remain command shift r
                    if re.match(r"[^0-9a-zA-Z]", key):
                        # but command shift / should be command ?
                        # and shift control \ should be control |
                        key = key.translate(cls._to_shifted_trans)
                        mods = [mod for mod in mods if mod != "$"]
            # shortcuts always displayed with upper case letters
            key = key.upper()
        else:
            if key.lower() in cls._keyname_map:
                # special key names, pgup, etc are in lowercase
                key = cls._keyname_map[key.lower()]
            elif key.upper() in cls._fkeys:
                # but function keys are in uppercase
                key = key.upper()
            else:
                raise ValueError("{} is not a valid key".format(key))

        # remove duplicate modifiers
        mods = list(set(mods))
        # sort the mods to be in Apple's recommended order
        mods.sort(key=lambda x: cls._mods_plaintext.index(x))

        return ("".join(mods), key)

    @property
    def mod_names(self):
        """return a list of modifier names for this shortcut"""
        output = []
        for mod in self.mods:
            output.append(self._mods_names[self._mods_plaintext.index(mod)])
        return output

    @property
    def mod_symbols(self):
        """return a list of unicode symbols for this shortcut"""
        output = []
        for mod in self.mods:
            output.append(self._mods_unicode[self._mods_plaintext.index(mod)])
        return output

    @property
    def key_name(self):
        """return either the key, or if it has a name return that"""
        if self.key in self._keys:
            return self._keys[self.key].name
        # this is for human consumption, and keys are always upper case
        return self.key.upper()


def _parse_shortcuts(text):
    """parse a string or array of text into a standard representation of the shortcut

    returns an array of shortcut combinations

    this is a short function only called in one place, but it makes it much easier
    to test
    """
    combos = []
    for combo in re.split(r" / ", text):
        combos.append(KeyboardShortcut(combo))
    return combos


def _render_txt(combos, args):
    """render as plain text a list of keyboard combinations according to the
    options in args"""
    output = []
    for combo in combos:
        tokens = []
        joiner = ""
        if args.modifier_symbols:
            if args.plus_sign:
                joiner = "+"
            tokens.extend(combo.mod_symbols)
        else:
            joiner = "-"
            tokens.extend(combo.mod_names)
        if args.key_symbols:
            tokens.extend(combo.key.upper())
        else:
            tokens.append(combo.key_name)
        output.append(joiner.join(tokens))

    return " / ".join(output)


def main(argv=None):
    """main function"""
    parser = _build_parser()
    args = parser.parse_args(argv)
    print(args)
    combos = _parse_shortcuts(" ".join(args.shortcuts))

    if args.output == "txt":
        print(_render_txt(combos, args))
    elif args.output == "html":
        pass


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


# def setup_module():
#    global pytest
#    global mock
#    import pytest
#    import mock


@pytest.mark.parametrize(
    "inp, out",
    [
        ("command %", "$@5"),
        ("command shift %", "$@5"),
        ("command shift 5", "$@5"),
        ("shift control 6", "^$6"),
        ("shift-command-/", "@?"),
        ("shift control \\", "^|"),
        ("control \\", "^\\"),
        ("command ?", "@?"),
        ("command f", "@F"),
        ("command option r", "~@R"),
        ("⌘⌥⇧⌃r", "^~$@R"),
        ("command-shift-f", "$@F"),
        ("func f2", "*F2"),
        ("fn F13", "*F13"),
        ("F7", "F7"),
        ("command shift /", "@?"),
        ("control command  shift control H", "^$@H"),
        ("  command -", "@-"),
        ("command command q", "@Q"),
        ("H", "H"),
        ("shift h", "$H"),
        ("command control R", "^@R"),
        ("shift p", "$P"),
        ("shift 4", "$4"),
        ("ctrl 6", "^6"),
        ("command right", "@→"),
        ("control command del", "^@⌫"),
        ("shift ESCAPE", "$⎋"),
    ],
)
def test_ks_parse(inp, out):
    ks = KeyboardShortcut(inp)
    assert str(ks) == out


# def test_ks_parse():
#     parsemap = [
#         ("command %", "$@5"),
#         ("command shift %", "$@5"),
#         ("command shift 5", "$@5"),
#         ("shift-command-/", "@?"),
#         ("command ?", "@?"),
#         ("command f", "@F"),
#         ("command option r", "~@R"),
#         ("⌘⌥⇧⌃r", "^~$@R"),
#         ("command-shift-f", "$@F"),
#         ("func 2", "*2"),
#         ("command shift /", "@?"),
#         ("control command  shift control H", "^$@H"),
#         ("  command -", "@-"),
#         ("command command q", "@Q"),
#         ("shift control \\", "^|"),
#         ("H", "H"),
#         ("shift h", "$H"),
#         ("command control R", "^@R"),
#         ("shift p", "$P"),
#         ("shift 4", "$"),
#         ("ctrl 6", "^6"),
#         ("shift control 6", "^$^"),
#         ("command right", "@→"),
#         ("control command del", "^@⌫"),
#         ("shift ESCAPE", "$⎋"),
#         ("F7", "f7"),
#     ]
#     for text, canonical in parsemap:
#         ks = KeyboardShortcut(text)
#         assert str(ks) == canonical


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


# TODO figure out / verify Fn in plaintext and unicode


def test_parse_3():
    assert len(_parse_shortcuts("F10 / shift-escape / control-option-right")) == 3
