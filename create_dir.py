#!/usr/bin/python2
""" This script create directory Tree
	Version:1.0
	Created By-Jitendra
"""

import os
import sys

def usages():
	print "Usages: "+sys.argv[0]+" [source dir]"+ " [dest dir]"


def create_dir(src_dir=None,dst_dir=None):
	"""This function create dir based on passed arguments"""
	if src_dir and dst_dir and os.path.exists(src_dir) and os.path.exists(dst_dir):
		mkdir=str()
		for root, dirs, files in os.walk(src_dir, topdown=True):
			for name in dirs:
				if not root.endswith('/'):
					root = root + "/"
				mkdir=dst_dir+root[len(src_dir):]+name
				#print mkdir
				if not os.path.exists(mkdir):
					os.mkdir(mkdir)
				else:
					print "Path exists: " + mkdir
	else:
		print "Please check arguments passed, something wrong with src dir/dst dir: Source dir= {} Destination dir= {}".format(src_dir,dst_dir)
		return None 

def main():
	"""Main function """
	if len(sys.argv) > 2:
		src_dir = sys.argv[1]
		dst_dir = sys.argv[2]
		return create_dir(src_dir,dst_dir)
	else:
		usages()
		return
	
	

if __name__ == '__main__':
	main()