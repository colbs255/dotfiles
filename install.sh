#!/bin/sh

os=$(uname -s)
os_lowercase=${os,,}
cd $os_lowercase && ./install.sh
