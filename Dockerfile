# Choose and uncomment one of the 3 possible base images:

# ==================================================
# (1) results in ca. 821MB
FROM python:2

# (2) results in ca. 2.06GB, can create latex pdf
# FROM t3docs/python2-with-latex

# (3) results in ca. 2.53 GB, can create latex pdf, can read OpenOffice
#FROM t3docs/docker-libreoffice-on-python2-with-latex

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
# Use:
#    docker run --rm t3docs/render-documentation[:tag]
#    source <(docker run --rm t3docs/render-documentation[:tag] show-shell-commands)
#    dockrun_t3rdf
#    dockrun_t3rdf makehtml
# or
#    ddockrun_t3rdf
#    ddockrun_t3rdf makeall
#
# Rename example:
#   docker tag t3docs/render-documentation[:tag1] t3docs/render-documentation[:tag2]

ARG OUR_IMAGE_VERSION=v1.6.9-full
ARG OUR_IMAGE_TAG=${OUR_IMAGE_VERSION}
# flag for apt-get - affects only build time
ARG DEBIAN_FRONTEND=noninteractive
ARG DOCKRUN_PREFIX="dockrun_"
ARG hack_OUR_IMAGE="t3docs/render-documentation:${OUR_IMAGE_TAG}"
ARG hack_OUR_IMAGE_SHORT="t3rdf"
ARG OUR_IMAGE_SLOGAN="t3rdf - TYPO3 render documentation full"

ENV \
   HOME="/ALL/userhome" \
   TCT_PIPINSTALL_URL="git+https://github.com/marble/TCT.git@v0.2.0#egg=tct" \
   TOOLCHAIN_UNPACKED="Toolchain_RenderDocumentation-2.3.0" \
   TOOLCHAIN_URL="https://github.com/marble/Toolchain_RenderDocumentation/archive/v2.3.0.zip" \
   OUR_IMAGE="$hack_OUR_IMAGE" \
   OUR_IMAGE_SHORT="$hack_OUR_IMAGE_SHORT" \
   THEME_MTIME="1525457938"

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
   \
   && COMMENT "for ubuntu:18.04: (unfinished)" \
   && apt-get install --dry-run -yq --no-install-recommends \
      wget \
      python \
      \
   && COMMENT "always:" \
   && apt-get install -yq --no-install-recommends \
      less \
      nano \
      ncdu \
      pandoc \
      php5-cli \
      rsync \
      tidy \
      unzip \
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
   && chmod +x /usr/local/bin/t3xutils.phar \
   \
   && COMMENT "Install Python packages" \
   && pip install --upgrade pip \
   && pip install https://github.com/TYPO3-Documentation/t3SphinxThemeRtd/archive/v3.6.14.zip \
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
   && wget https://raw.githubusercontent.com/TYPO3-Documentation/Pygments-TypoScript-Lexer/master/bitbucket-org-birkenfeld-pygments-main/typoscript.py \
      --quiet --output-document $destdir/typoscript.py \
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
   && COMMENT "Download latex files" \
   && wget https://github.com/TYPO3-Documentation/latex.typo3/archive/master.zip -qO /tmp/latex.typo3-master.zip \
   && unzip /tmp/latex.typo3-master.zip -d /tmp \
   && mv /tmp/latex.typo3-master /ALL/Downloads/latex.typo3 \
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
   && echo "debug_info DEBIAN_FRONTEND....: ${DEBIAN_FRONTEND}"     \
   && echo "debug_info DOCKRUN_PREFIX.....: ${DOCKRUN_PREFIX}"      \
   && echo "debug_info OUR_IMAGE..........: ${OUR_IMAGE}"           \
   && echo "debug_info OUR_IMAGE_SHORT....: ${OUR_IMAGE_SHORT}"     \
   && echo "debug_info OUR_IMAGE_SLOGAN...: ${OUR_IMAGE_SLOGAN}"    \
   && echo "debug_info OUR_IMAGE_VERSION..: ${OUR_IMAGE_VERSION}"   \
   && echo "debug_info SPHINX_CONTRIB_HASH: ${SPHINX_CONTRIB_HASH}" \
   && echo "debug_info TCT_PIPINSTALL_URL.: ${TCT_PIPINSTALL_URL}"  \
   && echo "debug_info TOOLCHAIN_URL......: ${TOOLCHAIN_URL}"       \
   \
   && echo "\n\
      Versions we use for this $OUR_IMAGE_VERSION:\n\
      \n\
      Sphinx theme        t3SphinxThemeRtd       v3.6.14  mtime:$THEME_MTIME \n\
      Toolchain           RenderDocumentation    Tag v2.2.0.zip \n\
      Toolchain tool      TCT                    0.2.0 \n\
      Python packages     see requirements.txt   \n\
                          Sphinx                 \n\
                          recommonmark           v2018-05-04 \n\
      TYPO3-Documentation typo3.latex            master \n\
      "

ENTRYPOINT ["/ALL/Menu/mainmenu.sh"]

CMD []
