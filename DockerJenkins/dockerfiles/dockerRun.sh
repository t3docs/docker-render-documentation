#!/bin/bash
# 
# Since: September, 2018
# Author: thucke@web.de
# Description: Create a running docker container
# 
BASE_DIR=$(dirname `readlink --canonicalize-existing "$0"`)/../dockermounts
SRC_IMAGE_NAME="thucke/jenkins:2.138.1"
DST_IMAGE_NAME="ThuckeJenkins-2.138.1"

docker run -d --name=${DST_IMAGE_NAME} \
-p 8080:8080 -p 50000:50000 \
-v jenkins_home:/var/jenkins_home \
-v /usr/local/bin/docker:/usr/bin/docker \
-v /run/docker.sock:/run/docker.sock \
-v "${BASE_DIR}"/external:/mnt/external \
-e "DOCKER_GID_ON_HOST=0" \
${SRC_IMAGE_NAME}


echo "Please do a restart of the newly generated and running container ${DST_IMAGE_NAME}"
echo "It's been observed that otherwise working with docker could not work properly"
