# FROM python:2

FROM t3docs/docker-libreoffice-on-python2-with-latex

# t3rdf means: TYPO3 render documentation full

# Clean:
#     docker rmi t3docs/render-documentation
#     docker rmi t3docs/render-documentation:master
#     docker rmi t3docs/render-documentation:develop
# Build:
#     docker build -t t3docs/render-documentation .
#     docker build -t t3docs/render-documentation:master .
#     docker build -t t3docs/render-documentation:develop .
# Use:
#     docker run --rm t3docs/render-documentation
#     source <(docker run --rm t3docs/render-documentation show-shell-commands)
#     dockrun_t3rdf
#     dockrun_t3rdf makehtml
# Use development:
#     docker rmi t3docs/render-documentation
#     docker pull t3docs/render-documentation:develop
#
#     # then rename:
#     docker tag t3docs/render-documentation:develop t3docs/render-documentation:master

ARG \
   VERSION="1.6.5"

# flag for apt-get - affects only build time
ARG \
   DEBIAN_FRONTEND=noninteractive

ENV \
   DOCKRUN_PREFIX="dockrun_" \
   HOME="/ALL/userhome" \
   OUR_IMAGE="t3docs/render-documentation" \
   OUR_IMAGE_SHORT="t3rdf" \
   OUR_IMAGE_SLOGAN="t3rdf - TYPO3 render documentation full" \
   SPHINX_CONTRIB_HASH="3fe09d84cbef" \
   TCT_PIPINSTALL_URL="git+https://github.com/marble/TCT.git@v0.2.0#egg=tct" \
   TOOLCHAIN_UNPACKED="Toolchain_RenderDocumentation-2.2.0" \
   TOOLCHAIN_URL="https://github.com/marble/Toolchain_RenderDocumentation/archive/v2.2.0.zip"

#  Versions we use for this 1.6.5:
#
#  Sphinx theme      t3SphinxThemeRtd       release-3.6.13
#  Toolchain         RenderDocumentation    Tag v2.2.0.zip
#  Toolchain tool    TCT                    0.2.0
#  Python packages   see requirements.txt
#                    Sphinx                 < 1.6
#                    recommonmark           0.4.0

LABEL \
   Maintainer="TYPO3 Documentation Team" \
   Description="This image renders TYPO3 documentation." \
   Vendor="t3docs" Version="$VERSION"

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
   && wget https://raw.githubusercontent.com/TYPO3-Documentation/typo3-docs-typo3-org-resources/master/userroot/scripts/bin/check_include_files.py \
        --quiet --output-document /usr/local/bin/check_include_files.py \
   && chmod +x /usr/local/bin/check_include_files.py \
   && wget https://raw.githubusercontent.com/TYPO3-Documentation/typo3-docs-typo3-org-resources/master/userroot/scripts/config/_htaccess-2016-08.txt \
           --quiet --output-document /ALL/Makedir/_htaccess \
   && wget https://github.com/etobi/Typo3ExtensionUtils/raw/master/bin/t3xutils.phar \
           --quiet --output-document /usr/local/bin/t3xutils.phar \
   && chmod +x /usr/local/bin/t3xutils.phar \
   \
   && COMMENT "Install system packages" \
   && apt-get update \
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
   COMMENT "Install Python packages" \
   && pip install --upgrade pip \
   && pip install git+https://github.com/TYPO3-Documentation/t3SphinxThemeRtd@release-3.6.13 \
   && pip install -r /ALL/requirements.txt \
   \
   && COMMENT "Install Sphinx-Extensions" \
   && COMMENT "doesn't work with apt-cacher: hg clone https://bitbucket.org/xperseguers/sphinx-contrib /ALL/Downloads/sphinx-contrib" \
   && sh -c "wget -q https://bitbucket.org/xperseguers/sphinx-contrib/get/\${SPHINX_CONTRIB_HASH}.zip -O /tmp/sphinx-contrib-\${SPHINX_CONTRIB_HASH}.zip" \
   && sh -c "unzip -qq /tmp/sphinx-contrib-\${SPHINX_CONTRIB_HASH}.zip -d /tmp/" \
   && sh -c "mv /tmp/xperseguers-sphinx-contrib-\${SPHINX_CONTRIB_HASH} /ALL/Downloads/sphinx-contrib" \
   \
   && pip install /ALL/Downloads/sphinx-contrib/googlechart \
   && pip install /ALL/Downloads/sphinx-contrib/googlemaps \
   && pip install /ALL/Downloads/sphinx-contrib/httpdomain \
   && pip install /ALL/Downloads/sphinx-contrib/mscgen \
   && pip install /ALL/Downloads/sphinx-contrib/numfig \
   && pip install /ALL/Downloads/sphinx-contrib/slide \
   && pip install /ALL/Downloads/sphinx-contrib/youtube \
   && rm -rf /ALL/Downloads/sphinx-contrib

RUN \
   COMMENT "Update TypoScript lexer for highlighting" \
   && COMMENT "usually: /usr/local/lib/python2.7/site-packages/pygments/lexers" \
   && destdir=$(dirname $(python -c "import pygments; print pygments.__file__"))/lexers \
   && wget https://raw.githubusercontent.com/TYPO3-Documentation/Pygments-TypoScript-Lexer/master/bitbucket-org-birkenfeld-pygments-main/typoscript.py \
      --quiet --output-document $destdir/typoscript.py \
   && cd $destdir; python _mapping.py

RUN \
   COMMENT "Install TCT (ToolChainTool), the toolchain runner" \
   && pip install ${TCT_PIPINSTALL_URL} \
   \
   && COMMENT "Provide the toolchain" \
   && wget ${TOOLCHAIN_URL} -qO /ALL/Downloads/Toolchain_RenderDocumentation.zip \
   && unzip /ALL/Downloads/Toolchain_RenderDocumentation.zip -d /ALL/Toolchains \
   && mv /ALL/Toolchains/${TOOLCHAIN_UNPACKED} /ALL/Toolchains/RenderDocumentation \
   \
   && COMMENT "Download latex files" \
   && git clone https://github.com/TYPO3-Documentation/latex.typo3 \
                /ALL/Downloads/latex.typo3 \
   \
   && COMMENT "Final cleanup" \
   && apt-get clean \
   && rm -rf /tmp/* \
   \
   && COMMENT "Let's have some debug info" \
   && echo "debug_info DOCKRUN_PREFIX..: ${DOCKRUN_PREFIX}"  \
   && echo "debug_info OUR_IMAGE.......: ${OUR_IMAGE}"       \
   && echo "debug_info OUR_IMAGE_SHORT.: ${OUR_IMAGE_SHORT}" \
   && echo "debug_info OUR_IMAGE_SLOGAN: ${OUR_IMAGE_SLOGAN}"


ENTRYPOINT ["/ALL/Menu/mainmenu.sh"]

CMD []
