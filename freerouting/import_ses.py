#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# https://github.com/ceoloide/corney-island/blob/main/kibot/import_ses.py
import sys, getopt
import pcbnew

"""
This program runs pcbnew and imports a Specctra SES file, then saves the result
as a new KiCad PCB.
"""

def usage():
    print("import_ses.py -b <board_file> -s <session_file> -o <output_file>")
    sys.exit(2)


def main(argv):
    board_file = ""
    output_file = ""
    session_file = ""
    try:
        opts, args = getopt.getopt(argv, "hb:s:o:", ["board=", "session=", "output="])
        if len(opts) != 3:
            usage()
    except getopt.GetoptError:
        usage()

    for opt, arg in opts:
        if opt == "-h":
            usage()
        elif opt in ("-b", "--board"):
            board_file = arg
        elif opt in ("-s", "--session"):
            session_file = arg
        elif opt in ("-o", "--output"):
            output_file = arg

    print("Importing Specctra SES ", session_file, " for ", board_file)
    board = pcbnew.LoadBoard(board_file)
    pcbnew.ImportSpecctraSES(board, session_file)
    success = pcbnew.SaveBoard(output_file, board, True)
    if success:
        print("Saved output to ", output_file)
    else:
        print("Couldn not save output to ", output_file)


if __name__ == "__main__":
    main(sys.argv[1:])
