#!/bin/bash
# 
# Since: March, 2018
# Author: thucke@web.de
# Description: Build script for building Jenkins Docker images.
# 
usage() {
  cat << EOF

Usage: buildDockerImage.sh -v [version] [-e | -s | -x] [-i] [-o] [Docker build option]
Builds a Docker Image for Oracle Database.
  
Parameters:
   -v: Jenkins base image version to build (default: 2.107.1)
   -z: Timezone descriptor (default: "Europe/Berlin")
   -o: passes on Docker build option

* select one edition only: -e, -s, or -x

LICENSE UPL 1.0

Copyright (c) 2018 Thomas Hucke. All rights reserved.

EOF
  exit 0
}

##############
#### MAIN ####
##############
# Parameters
VERSION="2.138.1"
DOCKEROPS=""

while getopts "hv:z:o:" optname; do
  case "$optname" in
    "h")
      usage
      ;;
    "o")
      DOCKEROPS="${DOCKEROPS} $OPTARG"
	  ;;
    "v")
	  VERSION="$OPTARG"
      ;;
    "z")
      DOCKEROPS="${DOCKEROPS} --build-arg SET_TIMEZONE=$OPTARG"
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

# Image Name
IMAGE_NAME="/jenkins:${VERSION}"
DEST_IMAGE_NAME="thucke${IMAGE_NAME}"
DOCKEROPS="${DOCKEROPS} --build-arg IMAGENAME=${IMAGE_NAME}"

echo "=========================="
echo "DOCKER info:"
docker info
echo "=========================="

# ################## #
# BUILDING THE IMAGE #
# ################## #
echo "Building image '$DEST_IMAGE_NAME' ..."

# BUILD THE IMAGE (replace all environment variables)
BUILD_START=$(date '+%s')
docker build --force-rm=true --no-cache=true $DOCKEROPS -t ${DEST_IMAGE_NAME} -f Dockerfile . || {
  echo "There was an error building the image."
  exit 1
}
BUILD_END=$(date '+%s')
BUILD_ELAPSED=`expr $BUILD_END - $BUILD_START`

echo ""

if [ $? -eq 0 ]; then
cat << EOF
  Jenkins Image for version $VERSION is ready to be extended: 
    
    --> $DEST_IMAGE_NAME

  Build completed in $BUILD_ELAPSED seconds.
  
EOF

else
  echo "Jenkins Docker Image was NOT successfully created. Check the output and correct any reported problems with the docker build operation."
fi

