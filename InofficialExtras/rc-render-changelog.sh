#!/bin/bash
# run or - better - source me

# Martin's development helper

# use 'build-the-docker-image.sh' first.

# define shortcut 'developer dockrun': ddockrun_t3rdh
source <(docker run --rm t3docs/render-documentation:v1.6.10-html show-shell-commands)

# ##################################################
unset T3DOCS_DEBUG T3DOCS_DUMMY_WEBROOT T3DOCS_MAKEDIR T3DOCS_MENU
unset T3DOCS_PROJECT T3DOCS_PROJECT T3DOCS_RESULT T3DOCS_RUNDIR T3DOCS_TMP
unset T3DOCS_TOOLCHAINS
# ##################################################
# select project
T3DOCS_PROJECT=/home/marble/Repositories/git.typo3.org/Packages/TYPO3.CMS.git/typo3/sysext/core
T3DOCS_RESULT=/home/marble/Repositories/github.com/t3docs/VOLUMES/GENERATED
T3DOCS_TMP=/home/marble/Repositories/github.com/t3docs/VOLUMES/GENERATED
# rsync -a $T3DOCS_PROJECT/Documentation-GENERATED-temp $T3DOCS_TMP/
#developer settings
T3DOCS_DEBUG=0
T3DOCS_MENU=/home/marble/Repositories/github.com/t3docs/docker-render-documentation/ALL-for-build/Menu
T3DOCS_RUNDIR=/home/marble/Repositories/github.com/t3docs/docker-render-documentation/ALL-for-build/Rundir
T3DOCS_TOOLCHAINS=/home/marble/Repositories/github.com/t3docs/VOLUMES/Toolchains
# Make a copy of the Makedir, since it is modified during building
rsync -a --delete \
   /home/marble/Repositories/github.com/t3docs/docker-render-documentation/ALL-for-build/Makedir/ \
   /home/marble/Repositories/github.com/t3docs/VOLUMES/GENERATED/tmp-GENERATED-Makedir/
T3DOCS_MAKEDIR=/home/marble/Repositories/github.com/t3docs/VOLUMES/GENERATED/tmp-GENERATED-Makedir

# Set file modification dates 'mtimes' to allow sphinx caching:
# Solution: https://github.com/MestreLion/git-tools !!!
#
# which git-restore-mtime ➜ /home/marble/bin/git-restore-mtime

# prepare the ChangeLog source
pushd $T3DOCS_PROJECT >/dev/null
git checkout master
git pull
git-restore-mtime
popd >/dev/null

# ##################################################

# how to add what you need:

ddockrun_t3rdh makehtml

#   -c make_singlehtml 1
#   -c make_latex 1
#   -c make_package 1
#   -c make_pdf 1

# ##################################################
# how to deselect what you don't need:

#ddockrun_t3rdh makeall

#   -c make_latex 0 \
#   -c make_package 0 \
#   -c make_pdf 0 \
#   -c make_singlehtml 0

# ##################################################
# how to run with site-packages that are hacked for debugging:

if ((0)); then true
docker run --rm --user=1000:1000 \
   -v /home/marble/Repositories/github.com/TYPO3-Documentation/TYPO3CMS-Tutorial-SitePackage:/PROJECT:ro \
   -v /home/marble/Repositories/github.com/t3docs/VOLUMES/GENERATED/Documentation-GENERATED-temp:/RESULT \
   -v /home/marble/Repositories/github.com/t3docs/VOLUMES/GENERATED/tmp-GENERATED-temp:/tmp \
   -v /home/marble/Repositories/github.com/t3docs/VOLUMES/GENERATED/tmp-GENERATED-dummy_webroot:/ALL/dummy_webroot \
   -v /home/marble/Repositories/github.com/t3docs/VOLUMES/GENERATED/tmp-GENERATED-Makedir:/ALL/Makedir \
   -v /home/marble/Repositories/github.com/t3docs/docker-render-documentation/ALL-for-build/Menu:/ALL/Menu \
   -v /home/marble/Repositories/github.com/t3docs/docker-render-documentation/ALL-for-build/Rundir:/ALL/Rundir \
   -v /home/marble/Repositories/github.com/t3docs/VOLUMES/Toolchains:/ALL/Toolchains \
   -v /home/marble/Repositories/github.com/t3docs/VOLUMES/GENERATED/Documentation-GENERATED-temp/Cache/site-packages:/usr/local/lib/python2.7/site-packages \
   t3docs/render-documentation:v1.6.10-html makehtml
fi

# ##################################################
unset T3DOCS_DEBUG T3DOCS_DUMMY_WEBROOT T3DOCS_MAKEDIR T3DOCS_MENU
unset T3DOCS_PROJECT T3DOCS_PROJECT T3DOCS_RESULT T3DOCS_RUNDIR T3DOCS_TMP
unset T3DOCS_TOOLCHAINS
# ##################################################

# Enyjoy!