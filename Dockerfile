# FROM python:2

FROM t3docs/python2-with-latex

# t3rdf means: TYPO3 render documentation full
# Github-branch: master, Docker-image: latest, Toolchain: latest
ENV \
   OUR_IMAGE_TAG="latest" \
   OUR_IMAGE="t3docs/render-documentation" \
   OUR_IMAGE_SHORT="t3rdf" \
   OUR_IMAGE_SLOGAN="t3rdf - TYPO3 render documentation full" \
   SPHINX-CONTRIB-HASH="3fe09d84cbef"


# flag for apt-get - only at build time!
ARG \
   DEBIAN_FRONTEND=noninteractive

LABEL \
   Maintainer="TYPO3 Documentation Team" \
   Description="This image renders TYPO3 documentation." \
   Vendor="t3docs" Version="0.4.0"

# all our sources
COPY ALL-for-build  /ALL

# I'm not sure when to use the VOLUME setting.
# We are using:
#    VOLUME /PROJECT   read-only
#    VOLUME /RESULT    output
# optional:
#    VOLUME /tmp       temp data

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
   && COMMENT "Make sure other users can write" \
   && chmod -R o+w \
      /ALL/Makedir \
      /ALL/dummy_webroot \
      /RESULT \
   \
   && wget https://raw.githubusercontent.com/TYPO3-Documentation/typo3-docs-typo3-org-resources/master/userroot/scripts/bin/check_include_files.py \
        --quiet --output-document /usr/local/bin/check_include_files.py \
   && chmod +x /usr/local/bin/check_include_files.py \
   && wget https://raw.githubusercontent.com/TYPO3-Documentation/typo3-docs-typo3-org-resources/master/userroot/scripts/bin/conf-2015-10.py \
           --quiet --output-document /ALL/Makedir/conf.py \
   && wget https://raw.githubusercontent.com/TYPO3-Documentation/typo3-docs-typo3-org-resources/master/userroot/scripts/config/_htaccess-2016-08.txt \
           --quiet --output-document /ALL/Makedir/_htaccess \
   && wget https://github.com/etobi/Typo3ExtensionUtils/raw/master/bin/t3xutils.phar \
           --quiet --output-document /usr/local/bin/t3xutils.phar \
   && chmod +x /usr/local/bin/t3xutils.phar \
   \
   && COMMENT "Install system packages" \
   && apt-get update \
   && apt-get install -yq \
      ncdu \
      pandoc \
      php5-cli \
      rsync \
      unzip \
      zip \
   \
   && COMMENT "Try extra cleaning besides /etc/apt/apt.conf.d/docker-clean" \
   && apt-get clean \
   && rm -rf /var/lib/apt/lists/*

RUN \
   COMMENT "Install Python packages" \
   && pip install -r /ALL/requirements.txt \
   \
   && COMMENT "Install Sphinx-Extensions" \
   && COMMENT "doesn't work with apt-cacher: hg clone https://bitbucket.org/xperseguers/sphinx-contrib /ALL/Downloads/sphinx-contrib" \
   && wget -q https://bitbucket.org/xperseguers/sphinx-contrib/get/${SPHINX-CONTRIB-HASH}.zip -O /tmp/sphinx-contrib-${SPHINX-CONTRIB-HASH}.zip \
   && unzip -qq /tmp/sphinx-contrib-${SPHINX-CONTRIB-HASH}.zip -d /tmp/ \
   && mv /tmp/xperseguers-sphinx-contrib-${SPHINX-CONTRIB-HASH} /ALL/Downloads/sphinx-contrib \
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
   && git clone https://github.com/marble/TCT.git /ALL/Downloads/tct \
   && pip install /ALL/Downloads/tct/ \
   \
   && COMMENT "Download the toolchain" \
   && git clone --branch ${}OUR_IMAGE_TAG} \
          https://github.com/marble/Toolchain_RenderDocumentation.git \
          /ALL/Toolchains/RenderDocumentation \
   \
   && COMMENT "Download latex files" \
   && git clone https://github.com/TYPO3-Documentation/latex.typo3 \
                /ALL/Downloads/latex.typo3 \
   \
   && COMMENT "Final cleanup" \
   && rm -rf /tmp/* \
   ;


ENTRYPOINT ["/ALL/Menu/mainmenu.sh"]

CMD []
