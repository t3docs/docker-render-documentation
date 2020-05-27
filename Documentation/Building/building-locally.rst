.. include:: /Includes.rst.txt
.. highlight:: text


================
Building locall
================

...


::

   ➜  ~ z docker-render-documentation
   ➜  docker-render-documentation git:(develop) ./PRIVATE-NOT_VERSIONED/1my-build-command-NOT_VERSIONED.sh
   ➜  docker-render-documentation git:(develop)

File ./PRIVATE-NOT_VERSIONED/1my-build-command-NOT_VERSIONED.sh::

   #!/bin/bash

   OUR_IMAGE_TAG=${OUR_IMAGE_TAG:-v2.3.0-local}

   if [[ "$OUR_IMAGE_TAG" = "" ]]; then
      BUILDARGS=""
   else
      BUILDARGS="--build-arg OUR_IMAGE_TAG=\"$OUR_IMAGE_TAG\""
   fi

   EXITCODE=0

   function usage() {
      echo "Usage:"
      echo "   Specify the desired tag for the image on the command"
      echo "   line followed by a blank and the command."
      echo
      echo "Examples:"
      echo "   ./$(basename -- $0) --help"
      echo "   OUR_IMAGE_TAG=v7.8.9 ./$(basename -- $0)"
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
      echo "\n\n\nBuild:\n\n"
      cmd="docker build \
         ${BUILDARGS} \
         --force-rm=true \
         --no-cache=true \
         -f ./Dockerfile \
         -t t3docs/render-documentation:${OUR_IMAGE_TAG} \
         . "
      echo
      echo "$cmd"
      eval "$cmd"
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

.. highlight:: text

Result::

   Versions used for v2.3.0:
   Sphinx theme        :: t3SphinxThemeRtd    :: 3.6.16 :: mtime:1530870718
   Toolchain           :: RenderDocumentation :: 2.7.0
   Toolchain tool      :: TCT                 :: 1.0.0
   TYPO3-Documentation :: typo3.latex         :: v1.1.0
   TypoScript lexer    :: typoscript.py       :: v2.2.4

   DEBIAN_FRONTEND     :: noninteractive
   DOCKRUN_PREFIX      :: dockrun_
   OUR_IMAGE           :: t3docs/render-documentation:v2.3.0-local
   OUR_IMAGE_SHORT     :: t3rd
   OUR_IMAGE_SLOGAN    :: t3rd - TYPO3 render documentation
   OUR_IMAGE_TAG       :: v2.3.0-local
   OUR_IMAGE_VERSION   :: v2.3.0
   TOOLCHAIN_TOOL_URL  :: https://github.com/marble/TCT/archive/develop.zip
   TOOLCHAIN_URL       :: https://github.com/marble/Toolchain_RenderDocumentation/archive/develop.zip


   Removing intermediate container d4394f99a6a5
    ---> c8e3b0804777
   Step 14/15 : ENTRYPOINT ["/ALL/Menu/mainmenu.sh"]
    ---> Running in c9a585de2957
   Removing intermediate container c9a585de2957
    ---> dcb439de6087
   Step 15/15 : CMD []
    ---> Running in 295c8cd921b8
   Removing intermediate container 295c8cd921b8
    ---> 0a406e347ee4
   Successfully built 0a406e347ee4
   Successfully tagged t3docs/render-documentation:v2.3.0-local
   Success!
   You may now run:
      docker run --rm t3docs/render-documentation:v2.3.0-local
      source <(docker run --rm t3docs/render-documentation:v2.3.0-local show-shell-commands)
   building t3docs/render-documentation:v2.3.0-local in 157 seconds
   t3docs/render-documentation   v2.3.0-local        0a406e347ee4        1 second ago        627MB
   ➜  docker-render-documentation git:(develop)

