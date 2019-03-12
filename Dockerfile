# Choose and uncomment one of the 3 possible base images:

# ==================================================
# (1) results in ca. 821MB
FROM python:2

# ==================================================

# t3rd means: TYPO3 render documentation

# Clean:
#    docker rmi t3docs/render-documentation[:tag]
# List:
#    docker image ls | grep t3
# Build (see build-the-docker-image*.sh):
#    docker build --force-rm=true --no-cache=true \
#       -t t3docs/render-documentation[:tag]  . || {
#             echo "There was an error building the image."
#             exit 1
#          }

ARG OUR_IMAGE_VERSION=v2.0.0
ARG OUR_IMAGE_TAG=${OUR_IMAGE_VERSION}
# flag for apt-get - affects only build time
ARG DEBIAN_FRONTEND=noninteractive
ARG DOCKRUN_PREFIX="dockrun_"
ARG hack_OUR_IMAGE="t3docs/render-documentation:${OUR_IMAGE_TAG}"
ARG hack_OUR_IMAGE_SHORT="t3rd"
ARG OUR_IMAGE_SLOGAN="t3rd - TYPO3 render documentation"

ENV \
   HOME="/ALL/userhome" \
   TCT_PIPINSTALL_URL="git+https://github.com/marble/TCT.git@v0.2.0#egg=tct" \
   TOOLCHAIN_VERSION="v2.3.1" \
   TOOLCHAIN_UNPACKED="Toolchain_RenderDocumentation-2.3.1" \
   TOOLCHAIN_URL="https://github.com/marble/Toolchain_RenderDocumentation/archive/v2.3.1.zip" \
   TYPOSCRIPT_PY_VERSION="v2.2.4" \
   TYPOSCRIPT_PY_URL="https://raw.githubusercontent.com/TYPO3-Documentation/Pygments-TypoScript-Lexer/v2.2.4/typoscript.py" \
   OUR_IMAGE="$hack_OUR_IMAGE" \
   OUR_IMAGE_SHORT="$hack_OUR_IMAGE_SHORT" \
   THEME_VERSION="v3.6.15" \
   THEME_MTIME="1530710653"

LABEL \
   Maintainer="TYPO3 Documentation Team" \
   Description="This image renders TYPO3 documentation." \
   Vendor="t3docs" Version="$OUR_IMAGE_VERSION"

# all our sources
COPY ALL-for-build  /ALL

# From here we start TCT. Place a tctconfig.cfg here.
WORKDIR /ALL/Rundir

RUN \
   true "Create executable COMMENT as a workaround to allow commenting here" \
   && cp /bin/true /bin/COMMENT \
   \
   && COMMENT "Garantee folders" \
   && mkdir /PROJECT \
   && mkdir /RESULT \
   \
   && COMMENT "Avoid GIT bug" \
   && cp /ALL/global-gitconfig.cfg /root/.gitconfig \
   && cp /ALL/global-gitconfig.cfg /.gitconfig \
   && chmod 666 /.gitconfig \
   \
   && COMMENT "Make sure other users can write" \
   && chmod -R o+w \
      /ALL/Makedir \
      /ALL/dummy_webroot \
      /RESULT \
   \
   && COMMENT "Install system packages" \
   && apt-get update \
   && apt-get install -yq --no-install-recommends \
      pandoc \
      rsync \
      unzip \
      wget \
      zip \
   \
   && COMMENT "Try extra cleaning besides /etc/apt/apt.conf.d/docker-clean" \
   && apt-get clean \
   && rm -rf /var/lib/apt/lists/* \
   \
   && COMMENT "Provide some special files" \
   && wget https://raw.githubusercontent.com/TYPO3-Documentation/typo3-docs-typo3-org-resources/master/userroot/scripts/bin/check_include_files.py \
        --quiet --output-document /usr/local/bin/check_include_files.py \
   && chmod +x /usr/local/bin/check_include_files.py \
   && wget https://raw.githubusercontent.com/TYPO3-Documentation/typo3-docs-typo3-org-resources/master/userroot/scripts/config/_htaccess-2016-08.txt \
           --quiet --output-document /ALL/Makedir/_htaccess \
   && wget https://github.com/etobi/Typo3ExtensionUtils/raw/master/bin/t3xutils.phar \
           --quiet --output-document /usr/local/bin/t3xutils.phar \
   && chmod +x /usr/local/bin/t3xutils.phar

RUN \
   COMMENT "Install Python packages" \
   && pip install --upgrade pip \
   && pip install https://github.com/TYPO3-Documentation/t3SphinxThemeRtd/archive/${THEME_VERSION}.zip \
   && find /usr/local/lib/python2.7/site-packages/t3SphinxThemeRtd/ -exec touch --no-create --time=mtime --date="$(date --rfc-2822 --date=@$THEME_MTIME)" {} \; \
   && pip install -r /ALL/requirements.txt \
   \
   && COMMENT "Install Sphinx-Extensions" \
   && pip install https://github.com/TYPO3-Documentation/recommonmark/archive/v2018-04-27.zip \
   && pip install https://github.com/TYPO3-Documentation/sphinx-contrib-googlechart/archive/master.zip \
   && pip install https://github.com/TYPO3-Documentation/sphinx-contrib-googlemaps/archive/master.zip \
   && pip install https://github.com/TYPO3-Documentation/sphinx-contrib-slide/archive/master.zip \
   && pip install https://github.com/TYPO3-Documentation/sphinx-contrib-youtube/archive/develop.zip \
   && pip install https://github.com/TYPO3-Documentation/sphinxcontrib.t3fieldlisttable/archive/master.zip \
   && pip install https://github.com/TYPO3-Documentation/sphinxcontrib.t3tablerows/archive/master.zip \
   && pip install https://github.com/TYPO3-Documentation/sphinxcontrib.t3targets/archive/develop.zip \
   \
   && COMMENT "Update TypoScript lexer for highlighting" \
   && COMMENT "usually: /usr/local/lib/python2.7/site-packages/pygments/lexers" \
   && destdir=$(dirname $(python -c "import pygments; print pygments.__file__"))/lexers \
   && wget $TYPOSCRIPT_PY_URL --quiet --output-document $destdir/typoscript.py \
   && cd $destdir; python _mapping.py \
   \
   && COMMENT "Install TCT (ToolChainTool), the toolchain runner" \
   && pip install ${TCT_PIPINSTALL_URL}

RUN COMMENT "Provide the toolchain" \
   && wget ${TOOLCHAIN_URL} -qO /ALL/Downloads/Toolchain_RenderDocumentation.zip \
   && unzip /ALL/Downloads/Toolchain_RenderDocumentation.zip -d /ALL/Toolchains \
   && mv /ALL/Toolchains/${TOOLCHAIN_UNPACKED} /ALL/Toolchains/RenderDocumentation \
   && rm /ALL/Downloads/Toolchain_RenderDocumentation.zip \
   \
   && COMMENT "Final cleanup" \
   && apt-get clean \
   && rm -rf /tmp/* \
   \
   && COMMENT "Memorize the settings in the container" \
   && echo "export DEBIAN_FRONTEND=\"${DEBIAN_FRONTEND}\""         >> /ALL/Downloads/envvars.sh \
   && echo "export DOCKRUN_PREFIX=\"${DOCKRUN_PREFIX}\""           >> /ALL/Downloads/envvars.sh \
   && echo "export OUR_IMAGE=\"${OUR_IMAGE}\""                     >> /ALL/Downloads/envvars.sh \
   && echo "export OUR_IMAGE_SHORT=\"${OUR_IMAGE_SHORT}\""         >> /ALL/Downloads/envvars.sh \
   && echo "export OUR_IMAGE_SLOGAN=\"${OUR_IMAGE_SLOGAN}\""       >> /ALL/Downloads/envvars.sh \
   && echo "export OUR_IMAGE_VERSION=\"${OUR_IMAGE_VERSION}\""     >> /ALL/Downloads/envvars.sh \
   && echo "export SPHINX_CONTRIB_HASH=\"${SPHINX_CONTRIB_HASH}\"" >> /ALL/Downloads/envvars.sh \
   && echo "export TCT_PIPINSTALL_URL=\"${TCT_PIPINSTALL_URL}\""   >> /ALL/Downloads/envvars.sh \
   && echo "export TOOLCHAIN_URL=\"${TOOLCHAIN_URL}\""             >> /ALL/Downloads/envvars.sh \
   \
   && COMMENT "Let's have some debug info"                          \
   && echo "\
      debug_info DEBIAN_FRONTEND....: ${DEBIAN_FRONTEND}\n\
      debug_info DOCKRUN_PREFIX.....: ${DOCKRUN_PREFIX}\n\
      debug_info OUR_IMAGE..........: ${OUR_IMAGE}\n\
      debug_info OUR_IMAGE_SHORT....: ${OUR_IMAGE_SHORT}\n\
      debug_info OUR_IMAGE_SLOGAN...: ${OUR_IMAGE_SLOGAN}\n\
      debug_info OUR_IMAGE_VERSION..: ${OUR_IMAGE_VERSION}\n\
      debug_info TCT_PIPINSTALL_URL.: ${TCT_PIPINSTALL_URL}\n\
      debug_info TOOLCHAIN_URL......: ${TOOLCHAIN_URL}\n\
      \n\
      Versions used for $OUR_IMAGE_VERSION:\n\
      \n\
      Sphinx theme        t3SphinxThemeRtd       $THEME_VERSION  mtime:$THEME_MTIME\n\
      Toolchain           RenderDocumentation    $TOOLCHAIN_VERSION\n\
      Toolchain tool      TCT                    0.2.0\n\
      Python packages     see requirements.txt\n\
                          Sphinx\n\
                          recommonmark           v2018-05-04\n\
      TypoScript lexer    typoscript.py          $TYPOSCRIPT_PY_VERSION\n" | cut -b 7- > /ALL/Downloads/buildinfo.txt \
   && cat /ALL/Downloads/buildinfo.txt

ENTRYPOINT ["/ALL/Menu/mainmenu.sh"]

CMD []
