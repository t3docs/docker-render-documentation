#!/bin/bash
# run or - better - source me

# Martin's development helper

# use 'build-the-docker-image.sh' first.

# define shortcuts dockrun_t3rdh, dockrun_t3rdh
# source <(docker run --rm t3docs/render-documentation:v1.6.10-dev-html show-shell-commands)
source <( \
   docker run --rm \
   -v /home/marble/Repositories/github.com/t3docs/docker-render-documentation/ALL-for-build/Menu:/ALL/Menu \
   t3docs/render-documentation:v1.6.10-html show-shell-commands \
   )

# ##################################################
unset T3DOCS_DEBUG T3DOCS_DUMMY_WEBROOT T3DOCS_MAKEDIR T3DOCS_MENU
unset T3DOCS_PROJECT T3DOCS_PROJECT T3DOCS_RESULT T3DOCS_RUNDIR T3DOCS_TMP
unset T3DOCS_TOOLCHAINS
unset T3DOCS_SITE_PACKAGES
# ##################################################
# select project
T3DOCS_PROJECT=/home/marble/Repositories/github.com/TYPO3-Documentation/TYPO3CMS-Reference-CoreApi
T3DOCS_RESULT=/home/marble/Repositories/github.com/t3docs/VOLUMES/GENERATED
T3DOCS_TMP=/home/marble/Repositories/github.com/t3docs/VOLUMES/GENERATED
#developer settings
T3DOCS_DEBUG=0
T3DOCS_MENU=/home/marble/Repositories/github.com/t3docs/docker-render-documentation/ALL-for-build/Menu
#T3DOCS_RUNDIR=/home/marble/Repositories/github.com/t3docs/docker-render-documentation/ALL-for-build/Rundir
#T3DOCS_TOOLCHAINS=/home/marble/Repositories/github.com/t3docs/VOLUMES/Toolchains
# Make a copy of the Makedir, since it is modified during building
rsync -a --delete \
   /home/marble/Repositories/github.com/t3docs/docker-render-documentation/ALL-for-build/Makedir/ \
   /home/marble/Repositories/github.com/t3docs/VOLUMES/GENERATED/tmp-GENERATED-Makedir/
#T3DOCS_MAKEDIR=/home/marble/Repositories/github.com/t3docs/VOLUMES/GENERATED/tmp-GENERATED-Makedir

T3DOCS_SITE_PACKAGES="$T3DOCS_RESULT/Documentation-GENERATED-temp/Cache/site-packages"
if ((1)); then true
   mkdir -p "$T3DOCS_SITE_PACKAGES"
   if ((0)); then
      # create 'EXPORT_TO_HERE' to trigger a new export
      touch "$T3DOCS_SITE_PACKAGES/EXPORT_TO_HERE";
   fi
fi
if [[ ! -w "$T3DOCS_SITE_PACKAGES" ]]; then
   unset T3DOCS_SITE_PACKAGES
fi

# Set file modification dates 'mtimes' to allow sphinx caching:
# Solution: https://github.com/MestreLion/git-tools !!!
#
# which git-restore-mtime ➜ /home/marble/bin/git-restore-mtime

# prepare the ChangeLog source
pushd $T3DOCS_PROJECT >/dev/null
git checkout latest
git pull
git-restore-mtime
popd >/dev/null

# ##################################################

dockrun_t3rdh makehtml

# ##################################################
unset T3DOCS_DEBUG T3DOCS_DUMMY_WEBROOT T3DOCS_MAKEDIR T3DOCS_MENU
unset T3DOCS_PROJECT T3DOCS_PROJECT T3DOCS_RESULT T3DOCS_RUNDIR T3DOCS_TMP
unset T3DOCS_TOOLCHAINS
unset T3DOCS_SITE_PACKAGES

# ##################################################

# Enyjoy!