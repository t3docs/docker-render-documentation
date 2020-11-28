#!/bin/bash

source "$HOME/.bashrc"
source /ALL/Downloads/envvars.sh

# show line endings as CRLF
cat /ALL/Downloads/dockrun_t3rd.bat | sed -e 's/$/\r/'
