#!/bin/bash

source ~/.dockrun/dockrun_t3rd/shell-commands.sh
cd ..
mkdir -p tmp-GENERATED-logs
dockrun_t3rd makehtml-no-cache -c make_singlehtml 1 >tmp-GENERATED-logs/dockrun_t3rd-makehtml.log.txt
