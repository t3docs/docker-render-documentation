#!/bin/bash

docker run --rm \
   t3docs/render-documentation:v2.3.0-local \
   show-shell-commands \
   > docker-shell-commands.sh

