FROM ubuntu:18.04

ARG OUR_IMAGE_VERSION=v2.2.6
ARG OUR_IMAGE_TAG=${OUR_IMAGE_TAG:-$OUR_IMAGE_VERSION}
# flag for apt-get - affects only build time
ARG DEBIAN_FRONTEND=noninteractive
ARG DOCKRUN_PREFIX="dockrun_"
ARG hack_OUR_IMAGE="t3docs/render-documentation:${OUR_IMAGE_TAG}"
ARG hack_OUR_IMAGE_SHORT="t3rd"
ARG OUR_IMAGE_SLOGAN="t3rd - TYPO3 render documentation"

ENV \
   LC_ALL=C.UTF-8 \
   LANG=C.UTF-8 \
   HOME="/ALL/userhome" \
   TOOLCHAIN_VERSION="2.6.1" \
   TOOLCHAIN_UNPACKED="Toolchain_RenderDocumentation-2.6.1" \
   TOOLCHAIN_URL="https://github.com/marble/Toolchain_RenderDocumentation/archive/v2.6.1.zip" \
   TYPOSCRIPT_PY_VERSION="v2.2.4" \
   TYPOSCRIPT_PY_URL="https://raw.githubusercontent.com/TYPO3-Documentation/Pygments-TypoScript-Lexer/v2.2.4/typoscript.py" \
   OUR_IMAGE="$hack_OUR_IMAGE" \
   OUR_IMAGE_SHORT="$hack_OUR_IMAGE_SHORT" \
   THEME_VERSION="3.6.16" \
   THEME_MTIME="1530870718"

LABEL \
   Maintainer="TYPO3 Documentation Team" \
   Description="This image renders TYPO3 documentation." \
   Vendor="t3docs" Version="$OUR_IMAGE_VERSION"

COPY ALL-for-build  /ALL

WORKDIR /ALL/venv

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
   && COMMENT "Install and upgrade system packages" \
   && apt-get update \
   && apt-get upgrade -qy \
   && apt-get install -yq  \
      python-pip \
   \
   && COMMENT "What the toolchains needs" \
   && apt-get install -yq --no-install-recommends \
      moreutils \
      pandoc \
      rsync \
      tidy \
      unzip \
      wget \
   \
   && COMMENT "What we need - convenience tools" \
   && apt-get install -yq --no-install-recommends \
      less \
      nano \
      ncdu \
   \
   && COMMENT "Try extra cleaning besides /etc/apt/apt.conf.d/docker-clean" \
   && apt-get clean \
   && rm -rf /var/lib/apt/lists/* \
   \
   && COMMENT "Python stuff" \
   && /usr/bin/pip install --upgrade pip \
   && apt-get remove python-pip -y \
   && /usr/local/bin/pip install --upgrade pipenv \
   \
   && COMMENT "Disable /ALL/venv/Pipfile.lock - it didn't work reliably" \
   && rm -f Pipfile.lock.DISABLED \
   && if [ -f "Pipfile.lock" ]; then mv Pipfile.lock Pipfile.lock.DISABLED; fi \
   \
   && COMMENT "Install from /ALL/venv/Pipfile" \
   && pipenv install \
   && echo source $(pipenv --venv)/bin/activate >>$HOME/.bashrc \
   \
   && COMMENT "Provide some special files" \
   && wget https://raw.githubusercontent.com/TYPO3-Documentation/typo3-docs-typo3-org-resources/master/userroot/scripts/bin/check_include_files.py \
           --quiet --output-document /usr/local/bin/check_include_files.py \
   && wget https://raw.githubusercontent.com/TYPO3-Documentation/typo3-docs-typo3-org-resources/master/userroot/scripts/bin/conf-2017-09.py \
           --quiet --output-document /ALL/Makedir/conf-2017-09.py \
   && wget https://raw.githubusercontent.com/TYPO3-Documentation/typo3-docs-typo3-org-resources/master/userroot/scripts/config/_htaccess-2016-08.txt \
           --quiet --output-document /ALL/Makedir/_htaccess \
   && wget https://github.com/etobi/Typo3ExtensionUtils/raw/master/bin/t3xutils.phar \
           --quiet --output-document /usr/local/bin/t3xutils.phar \
   && chmod +x /usr/local/bin/t3xutils.phar \
   \
   && COMMENT "All files of the theme of a given theme version should have the" \
   && COMMENT "same mtime (last commit) to not turn off Sphinx caching" \
   && python=$(pipenv --venv)/bin/python \
   && destdir=$(dirname $($python -c "import t3SphinxThemeRtd; print t3SphinxThemeRtd.__file__")) \
   && find $destdir -exec touch --no-create --time=mtime --date="$(date --rfc-2822 --date=@$THEME_MTIME)" {} \; \
   \
   && COMMENT "Update TypoScript lexer for highlighting. It comes with Sphinx" \
   && COMMENT "but isn't up to date there. So we use it from our own repo." \
   && COMMENT "usually: /usr/local/lib/python2.7/site-packages/pygments/lexers" \
   && python=$(pipenv --venv)/bin/python \
   && destdir=$(dirname $($python -c "import pygments; print pygments.__file__"))/lexers \
   && rm $destdir/typoscript.* \
   && wget $TYPOSCRIPT_PY_URL --quiet --output-document $destdir/typoscript.py \
   && curdir=$(pwd); cd $destdir; $python _mapping.py; cd $curdir \
   \
   && COMMENT "Provide the toolchain" \
   && wget ${TOOLCHAIN_URL} -qO /ALL/Downloads/Toolchain_RenderDocumentation.zip \
   && unzip /ALL/Downloads/Toolchain_RenderDocumentation.zip -d /ALL/Toolchains \
   && mv /ALL/Toolchains/${TOOLCHAIN_UNPACKED} /ALL/Toolchains/RenderDocumentation \
   && rm /ALL/Downloads/Toolchain_RenderDocumentation.zip \
   \
   && COMMENT "Download latex files, since we can still render Latex without drawbacks" \
   && wget https://github.com/TYPO3-Documentation/latex.typo3/archive/v1.1.0.zip -qO /tmp/latex.typo3-v1.1.0.zip \
   && unzip /tmp/latex.typo3-v1.1.0.zip -d /tmp \
   && mv /tmp/latex.typo3-1.1.0 /ALL/Downloads/latex.typo3 \
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
   && echo "export OUR_IMAGE_TAG=\"${OUR_IMAGE_TAG}\""             >> /ALL/Downloads/envvars.sh \
   && echo "export OUR_IMAGE_VERSION=\"${OUR_IMAGE_VERSION}\""     >> /ALL/Downloads/envvars.sh \
   && echo "export TOOLCHAIN_URL=\"${TOOLCHAIN_URL}\""             >> /ALL/Downloads/envvars.sh \
   \
   && COMMENT "Let's have some debug info" \
   && echo "\
      debug_info DEBIAN_FRONTEND....: ${DEBIAN_FRONTEND}\n\
      debug_info DOCKRUN_PREFIX.....: ${DOCKRUN_PREFIX}\n\
      debug_info OUR_IMAGE..........: ${OUR_IMAGE}\n\
      debug_info OUR_IMAGE_SHORT....: ${OUR_IMAGE_SHORT}\n\
      debug_info OUR_IMAGE_SLOGAN...: ${OUR_IMAGE_SLOGAN}\n\
      debug_info OUR_IMAGE_TAG......: ${OUR_IMAGE_TAG}\n\
      debug_info OUR_IMAGE_VERSION..: ${OUR_IMAGE_VERSION}\n\
      debug_info TOOLCHAIN_URL......: ${TOOLCHAIN_URL}\n\
      \n\
      Versions used for $OUR_IMAGE_VERSION:\n\
      Sphinx theme        t3SphinxThemeRtd       $THEME_VERSION  mtime:$THEME_MTIME\n\
      Toolchain           RenderDocumentation    $TOOLCHAIN_VERSION\n\
      Toolchain tool      TCT                    0.3.0\n\
      TYPO3-Documentation typo3.latex            v1.1.0\n\
      TypoScript lexer    typoscript.py          $TYPOSCRIPT_PY_VERSION\n" | cut -b 7- > /ALL/Downloads/buildinfo.txt \
   && cat /ALL/Downloads/buildinfo.txt


ENTRYPOINT ["/ALL/Menu/mainmenu.sh"]

CMD []
