#!/bin/bash
# 
# Since: December, 2017
# Author: thucke@web.de
# Description: Build script for building Openhab Docker images.
# 
usage() {
  cat << EOF

Usage: buildDockerImage.sh -v [version] [-e | -s | -x] [-i] [-o] [Docker build option]
Builds a Docker Image for Oracle Database.
  
Parameters:
   -o: passes on Docker build option

LICENSE UPL 1.0

Copyright (c) 2014-2017 Oracle and/or its affiliates. All rights reserved.

EOF
  exit 0
}

##############
#### MAIN ####
##############
# Parameters
VERSION="1.6.5"
DOCKEROPS=""

while getopts "hv:o:" optname; do
  case "$optname" in
    "h")
      usage
      ;;
    "o")
      VERSION="$OPTARG"
	  ;;
    "o")
      DOCKEROPS="${DOCKEROPS} $OPTARG"
	  ;;
    "?")
      usage;
      exit 1;
      ;;
    *)
    # Should not occur
      echo "Unknown error while processing options inside buildDockerImage.sh"
      ;;
  esac
done

# Oracle Database Image Name
IMAGE_NAME="t3docs/render-documentation:${VERSION}"
DOCKEROPS="${DOCKEROPS} --build-arg VERSION=${VERSION}"

echo "=========================="
echo "DOCKER info:"
docker info
echo "=========================="

# ################## #
# BUILDING THE IMAGE #
# ################## #
echo "Building image '$IMAGE_NAME' ..."

# BUILD THE IMAGE (replace all environment variables)
BUILD_START=$(date '+%s')
docker build --force-rm=true --no-cache=true $DOCKEROPS -t ${IMAGE_NAME} -f Dockerfile . || {
  echo "There was an error building the image."
  exit 1
}
BUILD_END=$(date '+%s')
BUILD_ELAPSED=`expr $BUILD_END - $BUILD_START`

echo ""

if [ $? -eq 0 ]; then
cat << EOF
  Openhab Image for version $VERSION is ready to be extended: 
    
    --> $IMAGE_NAME

  Build completed in $BUILD_ELAPSED seconds.
  
EOF

else
  echo "Openhab Docker Image was NOT successfully created. Check the output and correct any reported problems with the docker build operation."
fi

