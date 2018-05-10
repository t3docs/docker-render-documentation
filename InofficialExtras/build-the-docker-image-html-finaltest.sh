#!/bin/bash

if ((1)); then
   docker rmi t3docs/render-documentation:v1.6.9-html
fi
if ((1)); then
   BUILD_START=$(date '+%s')
   docker build \
      --force-rm=true \
      --no-cache=true \
      -f ../Dockerfile \
      -t t3docs/render-documentation:v1.6.9-html \
      ..
   BUILD_END=$(date '+%s')
   BUILD_ELAPSED=$(expr $BUILD_END - $BUILD_START)

   if [ $? -eq 0 ]; then
      echo Success!
      echo "You may now run:"
      echo "   docker run --rm $OUR_IMAGE"
      echo "   source <(docker run --rm $OUR_IMAGE show-shell-commands)"
   else
      echo Failed!
   fi
   echo "building $OUR_IMAGE in $BUILD_ELAPSED seconds"
fi
