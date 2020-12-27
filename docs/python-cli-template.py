#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#
# Copyright (c) 2020 Jared Crapo
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#
"""
TODO: My command line program
"""
import argparse
import logging
import sys

VERSION_STRING = "0.1"


def _build_parser():
    """Build the argument parser"""
    parser = argparse.ArgumentParser(
        description="TODO: My command line program"
    )

    filename_help = "path to a movie file"
    parser.add_argument("filename", nargs=1, help=filename_help)

    debug_help = "show additional debugging information while processing commands"
    parser.add_argument("-d", "--debug", action="store_true", help=debug_help)

    version_help = "show the version information and exit"
    parser.add_argument(
        "-v",
        "--version",
        action="version",
        version=VERSION_STRING,
        help=version_help,
    )

    return parser

#
# entry point for command line
def main(argv=None):
    """Entry point for command line program."""
    parser = _build_parser()
    args = parser.parse_args(argv)
    if args.debug:
        logging.basicConfig(format="%(levelname)s: %(message)s", level=logging.DEBUG)
    else:
        logging.basicConfig(format="%(levelname)s: %(message)s", level=logging.ERROR)
    logging.debug("argv=%s", str(argv))
    logging.debug("args=%s", str(args))

    print("{}: {}".format(parser.prog, args.filename[0])
    return 0


if __name__ == "__main__":
    sys.exit(main())
