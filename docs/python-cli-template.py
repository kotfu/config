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

VERSION_STRING = "1.0"


def _build_parser():
    """Build the argument parser"""
    parser = argparse.ArgumentParser(
        description="TODO: My command line program"
    )

    filename_help = "path to a file"
    parser.add_argument("filename", nargs=1, help=filename_help)

    debug_help = "show additional debugging information while processing commands"
    parser.add_argument("-d", "--debug", action="store_true", help=debug_help)

    version_help = "show the version information and exit"
    parser.add_argument(
        "-v",
        "--version",
        action="version",
        version="{} {}".format(parser.prog, VERSION_STRING),
        help=version_help,
    )

    return parser

class BraceLogRecord(logging.LogRecord):
    """A subclass log record that formats using new style braces"""

    def getMessage(self):
        """
        Return the message for this LogRecord.

        Return the message for this LogRecord after merging any user-supplied
        arguments with the message.
        """
        msg = str(self.msg)
        if self.args:
            # self.args is a tuple, so we need to unpack it for format()
            msg = msg.format(*self.args)
        return msg

#
# entry point for command line
def main(argv=None):
    """Entry point for command line program."""
    parser = _build_parser()
    args = parser.parse_args(argv)
    if args.debug:
        logging.basicConfig(format="--{message}", style='{', level=logging.DEBUG)
    else:
        logging.basicConfig(format="--{message}", style='{', level=logging.ERROR)
    logging.setLogRecordFactory(BraceLogRecord)
    logging.debug("argv={}", argv)
    logging.debug("args={}", str(args))

    print("{}: {}".format(parser.prog, args.filename[0])
    return 0


if __name__ == "__main__":
    sys.exit(main())
