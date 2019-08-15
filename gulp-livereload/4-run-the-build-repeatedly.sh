#!/bin/bash

source docker-shell-commands.sh
cd ..
mkdir -p tmp-GENERATED-logs
dockrun_t3rd makehtml-no-cache >tmp-GENERATED-logs/dockrun_t3rd-makehtml.log.txt
