#!/bin/bash

# example file: How to build the image
#
# Usage:
#     cd InofficialExtras
#     ./build-the-docker-image.sh
# Examples:
#     cd InofficialExtras
#     VERSION=v1.6.10-full ./build-the-docker-image.sh
#     VERSION=v1.6.10-full OUR_IMAGE_TAG=latest DOCKRUN_PREFIX="dockrun_" ./build-the-docker-image.sh
#     VERSION=v1.6.10-full DOCKRUN_PREFIX="ddockrun_" ./build-the-docker-image.sh


# How to find the theme mtime:
# cd ~/Repositories/github.com/TYPO3-Documentation/t3SphinxThemeRtd
# git show -s --format=%ci v3.6.14 ➜ 2018-05-04 20:18:58 +0200
# date "+%s" --date="$(git show -s --format=%ci v3.6.14)" ➜ 1525457938
# THEME_MTIME=date "+%s" --date="$(git show -s --format=%ci v3.6.14)"
# # THEME_MTIME ➜ 1525457938
#

# variables 1
VERSION=${VERSION:-"v1.6.10-dev-html"}
DEBIAN_FRONTEND=${DEBIAN_FRONTEND:-noninteractive}
DOCKRUN_PREFIX=${DOCKRUN_PREFIX:-"dockrun_"}
OUR_IMAGE_SHORT=${OUR_IMAGE_SHORT:-t3rd}
OUR_IMAGE_SLOGAN=${OUR_IMAGE_SLOGAN:-"t3rdh - TYPO3 render documentation full"}
# variables 2
OUR_IMAGE_TAG=${OUR_IMAGE_TAG:-"$VERSION"}
# variables 3
OUR_IMAGE=${OUR_IMAGE:-"t3docs/render-documentation:$OUR_IMAGE_TAG"}

if ((0)); then
   docker info
fi
if ((1)); then
   BUILD_START=$(date '+%s')
   if ((0)); then
      # remove existing image first!?
      # But did not fix problem of 'hanging' downloads ca. every 2nd time
      docker rmi "$OUR_IMAGE" 2>/dev/null
   fi
   docker build \
      --force-rm=true \
      --no-cache=true \
      --build-arg DEBIAN_FRONTEND="${DEBIAN_FRONTEND}" \
      --build-arg DOCKRUN_PREFIX="${DOCKRUN_PREFIX}" \
      --build-arg hack_OUR_IMAGE="${OUR_IMAGE}" \
      --build-arg hack_OUR_IMAGE_SHORT="${OUR_IMAGE_SHORT}" \
      --build-arg OUR_IMAGE_SLOGAN="${OUR_IMAGE_SLOGAN}" \
      --build-arg VERSION="${VERSION}" \
      -f ../Dockerfile \
      -t "${OUR_IMAGE}" \
      ..
   BUILD_END=$(date '+%s')
   BUILD_ELAPSED=$(expr $BUILD_END - $BUILD_START)

   echo "building $OUR_IMAGE in $BUILD_ELAPSED seconds"
   if [ $? -eq 0 ]; then
      echo Success!
      echo "You may now run:"
      echo "   docker run --rm $OUR_IMAGE"
      echo "   source <(docker run --rm $OUR_IMAGE show-shell-commands)"
   else
      echo Failed!
   fi
fi
