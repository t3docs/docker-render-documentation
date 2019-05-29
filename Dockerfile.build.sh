#!/bin/bash


OUR_IMAGE_TAG=${OUR_IMAGE_TAG:-OUR_IMAGE_TAG}
EXITCODE=0

function usage() {
   echo "Usage:"
   echo "   Specify the desired tag for the image on the command"
   echo "   line followed by a blank and the command."
   echo
   echo "Examples:"
   echo "   ./$(basename -- $0) --help"
   echo "   OUR_IMAGE_TAG=v77.88.99 ./$(basename -- $0)"
   echo
}

if [[ "/ $@ /" =~ " --help " ]]; then
   usage
   echo "Sample build command could be:"
   echo "   docker build -t t3docs/render-documentation:${OUR_IMAGE_TAG} ."
   exit 0
fi

if [[ "$OUR_IMAGE_TAG" == "OUR_IMAGE_TAG" ]]; then
   usage
   exit 1
fi

if ((1)); then
   docker rmi t3docs/render-documentation:${OUR_IMAGE_TAG}
fi

if ((1)); then
   BUILD_START=$(date '+%s')
   docker build \
      --force-rm=true \
      --no-cache=true \
      -f ./Dockerfile \
      -t t3docs/render-documentation:${OUR_IMAGE_TAG} \
      .
   EXITCODE=$?
   BUILD_END=$(date '+%s')
   BUILD_ELAPSED=$(expr $BUILD_END - $BUILD_START)

   if [ $EXITCODE -eq 0 ]; then
      echo Success!
      echo "You may now run:"
      echo "   docker run --rm t3docs/render-documentation:${OUR_IMAGE_TAG}"
      echo "   source <(docker run --rm t3docs/render-documentation:${OUR_IMAGE_TAG} show-shell-commands)"
      # echo "Rename:"
      # echo "   docker rmi t3docs/render-documentation:latest"
      # echo "   docker tag t3docs/render-documentation:${OUR_IMAGE_TAG} \\"
      # echo "              t3docs/render-documentation:latest"

   else
      echo Failed!
   fi
   echo "building t3docs/render-documentation:${OUR_IMAGE_TAG} in $BUILD_ELAPSED seconds"
fi
docker image ls | grep t3 | grep ${OUR_IMAGE_TAG}
