#!/usr/bin/env python

"""
Written by Jordan Matelsky (@j6k4m8)
March 5, 2016
"""

import sys
import os
import argparse

import ndio.remote.neurodata as nd
import ndio.utils.mesh as ndm

parser = argparse.ArgumentParser(description='Create a 3D mesh from an ndio download.')
parser.add_argument("-t", "--token",
                    dest="token",
                    type=str,
                    help="The name of the token to download.")
parser.add_argument("-c", "--channel",
                    dest="channel",
                    type=str,
                    help="The name of the channel to download.")
parser.add_argument("-r", "--resolution",
                    dest="resolution",
                    type=int,
                    help="The resolution at which to download.")
parser.add_argument("-o", "--outfile",
                    dest="outfile",
                    default="out.obj",
                    type=str,
                    help="The file into which to output the .obj")
parser.add_argument("-b", "--bounds",
                    dest="bounds",
                    default=None,
                    type=str,
                    help="Bounding box to download.")

args = parser.parse_args()


n = nd()
if args.bounds is None:
    s = n.get_image_size(args.token, resolution=args.resolution)
    o = n.get_image_offset(args.token, resolution=args.resolution)
else:
    bounds = args.bounds.split('/')
    o = [int(i.split(',')[0]) for i in bounds]
    s = [int(i.split(',')[1]) for i in bounds]

query = {
    "token": args.token,
    "channel": args.channel,
    "x_start": o[0],
    "x_stop":  s[0],
    "y_start": o[1],
    "y_stop":  s[1],
    "z_start": o[2],
    "z_stop":  s[2],
    "resolution": args.resolution
}

volume = n.get_cutout(**query)
ndm.export_obj(args.outfile, volume)