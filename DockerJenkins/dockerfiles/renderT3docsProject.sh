#!/bin/bash
# 
# Since: September, 2018
# Author: thucke@web.de
# Description: Launch t3docs rendering in docker (https://hub.docker.com/r/t3docs/render-documentation/)
# 
set -x
###################################################################################################################################
# Configuration section
# T3DOCS_EXTERNAL_MOUNT:  absolute path to the Jenkins mounted directory from hosts perspective
# T3DOCS_LOCAL_MOUNT:     absolute path to the Jenkins mounted directory from Jenkins perspective
# JENKINS_GIT_DIR:        relative path under T3DOCS_LOCAL_MOUNT/T3DOCS_EXTERNAL_MOUNT to which Jenkins does its git checkout
#                         (Git plugin - Additional behaviours - Check out to a subdirectory
# T3DOCS_RESULT_DIR:      relative path under T3DOCS_LOCAL_MOUNT/T3DOCS_EXTERNAL_MOUNT where the rendering result should be stored
###################################################################################################################################
T3DOCS_EXTERNAL_MOUNT=${T3DOCS_EXTERNAL_MOUNT:-/volume1/docker/Jenkins/dockermounts/external}
T3DOCS_LOCAL_MOUNT=${T3DOCS_LOCAL_MOUNT:-/mnt/external}
JENKINS_GIT_DIR=${JENKINS_GIT_DIR:-git}
T3DOCS_RESULT_DIR=${T3DOCS_RESULT_DIR:-t3docs}
######################

######################
#create target directory
cd "${T3DOCS_LOCAL_MOUNT}"
mkdir -p "${T3DOCS_RESULT_DIR}/Documentation-GENERATED-temp"

#set filetime to last commit for caching (https://github.com/MestreLion/git-tools)
cd "${T3DOCS_LOCAL_MOUNT}"/"${JENKINS_GIT_DIR}" 
git-restore-mtime

#Prepare and execute rendering process
T3DOCS_PROJECT="${T3DOCS_EXTERNAL_MOUNT}/${JENKINS_GIT_DIR}"
T3DOCS_RESULT="${T3DOCS_EXTERNAL_MOUNT}/${T3DOCS_RESULT_DIR}"

docker run --rm --user=1000:1000 \
   -v "${T3DOCS_PROJECT}":/PROJECT:ro \
   -v "${T3DOCS_RESULT}/Documentation-GENERATED-temp":/RESULT t3docs/render-documentation:v1.6.10-html makehtml
