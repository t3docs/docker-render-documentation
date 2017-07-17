FROM python:2

ENV \
   OUR_IMAGE="t3docs/render-documentation" \
   OUR_IMAGE_SHORT=t3rd

LABEL \
   Maintainer="TYPO3 Documentation Team" \
   Description="This image is used to render and deploy TYPO3 documentation." \
   Vendor="t3docs" Version="0.2.0"

# all the container resources
COPY . /ALL

# The host project ($PWD) is mounted as /PROJECT
WORKDIR /PROJECT

# From here we start TCT. Place a tctconfig.cfg here.
# Use a mount if desired.
WORKDIR /ALL/Rundir

RUN \
   true "Create executable COMMENT as a workaround to allow commenting" \
   && cp /bin/true /bin/COMMENT \
   \
   && wget https://raw.githubusercontent.com/TYPO3-Documentation/typo3-docs-typo3-org-resources/master/userroot/scripts/bin/check_include_files.py \
        --quiet --output-document /usr/local/bin/check_include_files.py \
   && chmod +x /usr/local/bin/check_include_files.py \
   && wget https://raw.githubusercontent.com/TYPO3-Documentation/typo3-docs-typo3-org-resources/master/userroot/scripts/bin/conf-2015-10.py \
           --quiet --output-document /ALL/Makedir/conf.py \
   && wget https://raw.githubusercontent.com/TYPO3-Documentation/typo3-docs-typo3-org-resources/master/userroot/scripts/config/_htaccess-2016-08.txt \
           --quiet --output-document /ALL/Makedir/_htaccess
RUN \
   COMMENT "Install System dependencies" \
   && apt-get update \
   && apt-get install -y --no-install-recommends \
      rsync \
      unzip \
      zip \
   \
   && COMMENT "Remove downloaded packages and lists" \
   && apt-get clean \
   && rm -rf /var/lib/apt/lists/*

RUN \
   COMMENT "Install TYPO3 pip requirements" \
   && pip install --no-cache-dir -r /ALL/requirements.txt \
   \
   && COMMENT "Install Sphinx-Extensions" \
   && hg clone https://bitbucket.org/xperseguers/sphinx-contrib /ALL/Downloads/sphinx-contrib \
   \
   && pip install /ALL/Downloads/sphinx-contrib/googlechart \
   && pip install /ALL/Downloads/sphinx-contrib/googlemaps \
   && pip install /ALL/Downloads/sphinx-contrib/httpdomain \
   && pip install /ALL/Downloads/sphinx-contrib/mscgen \
   && pip install /ALL/Downloads/sphinx-contrib/slide \
   && pip install /ALL/Downloads/sphinx-contrib/youtube \
   && rm -rf /ALL/Downloads/sphinx-contrib

RUN \
   COMMENT "Install TCT (ToolChainTool), the toolchain runner" \
   && git clone https://github.com/marble/TCT.git /ALL/Downloads/tct \
   && pip install /ALL/Downloads/tct/

RUN \
   COMMENT "Download the toolchain" \
   && git clone -b this-is-the-future \
          https://github.com/marble/Toolchain_RenderDocumentation.git \
          /ALL/Toolchains/RenderDocumentation

ENTRYPOINT ["/ALL/Menu/mainmenu.sh"]

CMD []
