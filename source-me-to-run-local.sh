#!/usr/bin/env bash

cd /home/marble/Repositories/github.com/t3docs/docker-render-documentation

docker rmi t3rdf
docker build -t t3rdf .

source <(docker run --rm t3rdf show-shell-commands)

rsync -a --delete ./ALL-for-build/Menu/   ./tmp-GENERATED-Menu/
rsync -a --delete ./ALL-for-build/Rundir/ ./tmp-GENERATED-Rundir/
rsync -a --delete \
  /home/marble/Repositories/mbnas/mbgit/Toolchains/RenderDocumentation/ \
  ./tmp-GENERATED-Toolchains/RenderDocumentation/

ddockrun_t3rdf makehtml
