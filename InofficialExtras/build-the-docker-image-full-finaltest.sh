#!/bin/bash

OUR_IMAGE_TAG=v1.6.10-html
EXITCODE=0

if ((1)); then
   docker rmi t3docs/render-documentation:${OUR_IMAGE_TAG}
fi
if ((1)); then
   BUILD_START=$(date '+%s')
   docker build \
      --force-rm=true \
      --no-cache=true \
      -f ../Dockerfile \
      -t t3docs/render-documentation:${OUR_IMAGE_TAG} \
      ..
   EXITCODE=$?
   BUILD_END=$(date '+%s')
   BUILD_ELAPSED=$(expr $BUILD_END - $BUILD_START)

   if [ $EXITCODE -eq 0 ]; then
      echo Success!
      echo "You may now run:"
      echo "   docker run --rm t3docs/render-documentation:${OUR_IMAGE_TAG}"
      echo "   source <(docker run --rm t3docs/render-documentation:${OUR_IMAGE_TAG} show-shell-commands)"
   else
      echo Failed!
   fi
   echo "building t3docs/render-documentation:${OUR_IMAGE_TAG} in $BUILD_ELAPSED seconds"
fi
docker image ls | grep t3 | grep ${OUR_IMAGE_TAG}
