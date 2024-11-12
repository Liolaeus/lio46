#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# https://github.com/ceoloide/corney-island/blob/main/kibot/export_dsn.py
import sys, getopt
import pcbnew

"""
This program runs pcbnew and exports a Specctra DSN file.
"""


def main(argv):
    board_file = ""
    output_file = ""
    try:
        opts, _ = getopt.getopt(argv, "hb:o:", ["board=", "output="])
        if len(opts) != 2:
            raise getopt.GetoptError("Invalid arguments")
    except getopt.GetoptError:
        print("export_dsn.py -b <board_file> -o <ouput_dsn_file>")
        sys.exit(2)
    for opt, arg in opts:
        if opt == "-h":
            print("export_dsn.py -b <board_file> -o <ouput_dsn_file>")
            sys.exit()
        elif opt in ("-b", "--board"):
            board_file = arg
        elif opt in ("-o", "--output"):
            output_file = arg
    board = pcbnew.LoadBoard(board_file)
    if pcbnew.ExportSpecctraDSN(board, output_file):
        print(f"Successfully exported specctra DSN for {board_file} at {output_file}")
    else:
        raise Exception(f"Error while exporting specctra DSN for {board_file} at {output_file}")


if __name__ == "__main__":
    main(sys.argv[1:])
