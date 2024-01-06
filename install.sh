#!/bin/sh

os=$(uname -s | tr '[:upper:]' '[:lower:]')
cd "$os" && ./install.sh
