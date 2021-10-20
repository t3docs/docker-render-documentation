FROM ubuntu:20.04
# Reflect the development progress. Set to the release number or something
# like vX.Y.devN
ARG OUR_IMAGE_VERSION=v3.0.dev2
# Specify tag. Should be 'latest' or 'develop' or '<RELEASE_VERSION>' where
# release version looks like 'v3.0.0'
ARG OUR_IMAGE_TAG=develop
#
# flag for apt-get - affects only build time
ARG DEBIAN_FRONTEND=noninteractive
ARG DOCKRUN_PREFIX="dockrun_"
ARG hack_OUR_IMAGE="t3docs/render-documentation:${OUR_IMAGE_TAG}"
ARG hack_OUR_IMAGE_SHORT="t3rd"
ARG OUR_IMAGE_SLOGAN="t3rd - TYPO3 render documentation"
#
# PlantUML tagged file name as shown on https://plantuml.com/en/download
# Doesn't work at the moment, but should in future.
ARG PLANTUML_TAGGED_FILE_NAME="plantuml.1.2020.20.jar"

# THEME_MTIME=int(datetime.datetime(2021, 10, 3).timestamp())
ENV \
   LC_ALL=C.UTF-8 \
   LANG=C.UTF-8 \
   HOME="/ALL/userhome" \
   OUR_IMAGE="$hack_OUR_IMAGE" \
   OUR_IMAGE_SHORT="$hack_OUR_IMAGE_SHORT" \
   OUR_IMAGE_VERSION="$OUR_IMAGE_VERSION" \
   PIP_NO_CACHE_DIR=1 \
   PIP_CACHE_DIR="/ALL/userhome/.cache/pip" \
   PIP_DISABLE_PIP_VERSION_CHECK=1 \
   PIP_NO_PYTHON_VERSION_WARNING=1 \
   THEME_MTIME="1633212000" \
   THEME_NAME="unknown" \
   THEME_PIP_SOURCE="git+https://github.com/TYPO3-Documentation/sphinx_typo3_theme@v4.7.dev1" \
   THEME_VERSION="unknown" \
   TOOLCHAIN_TOOL_VERSION="v1.2.0" \
   TOOLCHAIN_TOOL_URL="https://github.com/marble/TCT/archive/refs/tags/v1.2.0.zip" \
   TOOLCHAIN_UNPACKED="Toolchain_RenderDocumentation-2.12.dev1" \
   TOOLCHAIN_URL="https://github.com/marble/Toolchain_RenderDocumentation/archive/refs/tags/v2.12.dev1.zip" \
   TOOLCHAIN_VERSION="2.12-dev" \
   TYPOSCRIPT_PY_URL="https://raw.githubusercontent.com/TYPO3-Documentation/Pygments-TypoScript-Lexer/v2.2.4/typoscript.py" \
   TYPOSCRIPT_PY_VERSION="v2.2.4"

## Set THEME_PIP_SOURCE to any argument PIP accepts, like:
#  THEME_PIP_SOURCE=sphinx_typo3_theme
#  THEME_PIP_SOURCE=git+https://github.com/TYPO3-Documentation/sphinx_typo3_theme@develop
#  THEME_PIP_SOURCE=git+https://github.com/TYPO3-Documentation/sphinx_typo3_theme/releases/tag/v4.7.dev1

# Notation:
#  TOOLCHAIN_URL="https://github.com/marble/Toolchain_RenderDocumentation/archive/develop.zip"
#  TOOLCHAIN_UNPACKED="Toolchain_RenderDocumentation-develop"
#  TOOLCHAIN_VERSION="develop (2.12.dev1)"
#
#  TOOLCHAIN_URL="https://github.com/marble/Toolchain_RenderDocumentation/archive/refs/tags/v2.12.dev1.zip"
#  TOOLCHAIN_UNPACKED="Toolchain_RenderDocumentation-2.12.dev1"
#  TOOLCHAIN_VERSION="2.12.dev1"


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
   && mkdir /THEMES \
   && mkdir /WHEELS \
   \
   && COMMENT "Avoid GIT bug" \
   && cp /ALL/global-gitconfig.cfg /root/.gitconfig \
   && cp /ALL/global-gitconfig.cfg /.gitconfig \
   && chmod 666 /.gitconfig \
   \
   && COMMENT "Install and upgrade system packages" \
   && apt-get update \
   && apt-get install -y apt-utils 2>/dev/null \
   && apt-get upgrade -qy \
   \
   && COMMENT "What the toolchains needs" \
   && apt-get install -yq --no-install-recommends \
      git \
      graphviz \
      moreutils \
      pandoc \
      plantuml \
      rsync \
      tidy \
      unzip \
      wget \
      zip \
   \
   && COMMENT "Make sure we have the latest plantuml.jar - DISABLED this time" \
   && COMMENT "wget https://sourceforge.net/projects/plantuml/files/${PLANTUML_TAGGED_FILE_NAME}/download \
           --quiet --output-document /usr/share/plantuml/${PLANTUML_TAGGED_FILE_NAME}" \
   && COMMENT "PLANTUML_TAGGED_FILE :: /usr/share/plantuml/${PLANTUML_TAGGED_FILE_NAME}" \
   \
   && COMMENT "Install python3, pip, setuptools, wheel" \
   && apt-get install -yq  \
      python3-pip \
      python3-dev \
      python3.8-venv \
   && COMMENT "Make python3 the default" \
   && ln -s /usr/bin/python3 /usr/local/bin/python \
   && pip3 install --upgrade pip wheel \
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
   && rm -rf /ALL/venv/.venv  \
   && python3 -m venv /ALL/venv/.venv \
   && bash -c 'ls -la /ALL/venv/.venv/bin' \
   && python=$(pwd)/.venv/bin/python3 \
   && pip=$(pwd)/.venv/bin/pip3 \
   && $pip install wheel \
   && $pip install future \
   && $pip install setuptools_scm \
   && $pip install "$THEME_PIP_SOURCE" "$TOOLCHAIN_TOOL_URL"\
   && $pip install -r requirements.txt \
   && echo source $(pwd)/.venv/bin/activate >>$HOME/.bashrc \
   \
   && COMMENT bash -c 'find /ALL/Downloads -name "*.whl" -exec .venv/bin/pip install -v {} \;' \
   \
   && COMMENT "All files of the theme of a given theme version should have the" \
   && COMMENT "same mtime (last commit) to not turn off Sphinx caching" \
   && destdir=$(dirname $($python -c "import sphinx_typo3_theme; print(sphinx_typo3_theme.__file__, end='')")) \
   && THEME_MTIME=$($python -c "import sphinx_typo3_theme; print(sphinx_typo3_theme.get_theme_mtime())") \
   && THEME_NAME=$($python -c "import sphinx_typo3_theme; print(sphinx_typo3_theme.get_theme_name())") \
   && THEME_VERSION=$($python -c "import sphinx_typo3_theme; print(sphinx_typo3_theme.__version__)") \
   && find $destdir -exec touch --no-create --time=mtime --date="$(date --rfc-2822 --date=@$THEME_MTIME)" {} \; \
   \
   && COMMENT "Update TypoScript lexer for highlighting. It comes with Sphinx" \
   && COMMENT "but isn't up to date there. So we use it from our own repo." \
   && COMMENT "usually: /ALL/venv/.venv/lib/python3.8/site-packages/pygments/lexers" \
   && destdir=$(dirname $($python -c "import pygments; print(pygments.__file__, end='')"))/lexers \
   && rm $destdir/typoscript.* \
   && wget $TYPOSCRIPT_PY_URL --quiet --output-document $destdir/typoscript.py \
   && echo curdir=$(pwd); cd $destdir; $python _mapping.py; cd $curdir \
   && curdir=$(pwd); cd $destdir; $python _mapping.py; cd $curdir \
   \
   && COMMENT "Provide the toolchain" \
   && wget ${TOOLCHAIN_URL} -qO /ALL/Downloads/Toolchain_RenderDocumentation.zip \
   && unzip /ALL/Downloads/Toolchain_RenderDocumentation.zip -d /ALL/Toolchains \
   && mv /ALL/Toolchains/${TOOLCHAIN_UNPACKED} /ALL/Toolchains/RenderDocumentation \
   && rm /ALL/Downloads/Toolchain_RenderDocumentation.zip \
   \
   && $pip freeze > /ALL/venv/pip-frozen-requirements.txt \
   \
   && COMMENT "Final cleanup" \
   && apt-get clean \
   && COMMENT pip cache purge \
   && rm -rf /tmp/* /ALL/userhome/.cache \
   \
   && COMMENT "Make sure other users can write" \
   && chmod -R a+w \
      /ALL/Makedir \
      /ALL/userhome \
      /ALL/venv \
      /RESULT \
   \
   && COMMENT "Memorize the settings in the container" \
   && echo "export DEBIAN_FRONTEND=\"${DEBIAN_FRONTEND}\""         >> /ALL/Downloads/envvars.sh \
   && echo "export DOCKRUN_PREFIX=\"${DOCKRUN_PREFIX}\""           >> /ALL/Downloads/envvars.sh \
   && echo "export OS_NAME=\"$(   grep -e ^NAME=    /etc/os-release | sed -r 's/.*"(.+)".*/\1/')\""  >> /ALL/Downloads/envvars.sh \
   && echo "export OS_VERSION=\"$(grep -e ^VERSION= /etc/os-release | sed -r 's/.*"(.+)".*/\1/')\""  >> /ALL/Downloads/envvars.sh \
   && echo "export OUR_IMAGE=\"${OUR_IMAGE}\""                     >> /ALL/Downloads/envvars.sh \
   && echo "export OUR_IMAGE_SHORT=\"${OUR_IMAGE_SHORT}\""         >> /ALL/Downloads/envvars.sh \
   && echo "export OUR_IMAGE_SLOGAN=\"${OUR_IMAGE_SLOGAN}\""       >> /ALL/Downloads/envvars.sh \
   && echo "export OUR_IMAGE_TAG=\"${OUR_IMAGE_TAG}\""             >> /ALL/Downloads/envvars.sh \
   && echo "export OUR_IMAGE_VERSION=\"${OUR_IMAGE_VERSION}\""     >> /ALL/Downloads/envvars.sh \
   && echo "export TOOLCHAIN_URL=\"${TOOLCHAIN_URL}\""             >> /ALL/Downloads/envvars.sh \
   \
   && COMMENT "Let\'s have some info ('::' as separator) about the build" \
   && echo "# cat /ALL/venv/pip-frozen-requirements.txt:"\
   && cat /ALL/venv/pip-frozen-requirements.txt \
   && echo "\n\
      $OUR_IMAGE_VERSION\n\
      Versions used for $OUR_IMAGE_VERSION:\n\
      Theme                :: $THEME_NAME :: $THEME_VERSION :: mtime:$THEME_MTIME\n\
      Toolchain            :: RenderDocumentation :: $TOOLCHAIN_VERSION\n\
      Toolchain tool       :: TCT                 :: $TOOLCHAIN_TOOL_VERSION\n\
      TYPO3-Documentation  :: typo3.latex         :: v1.1.0\n\
      TypoScript lexer     :: typoscript.py       :: $TYPOSCRIPT_PY_VERSION\n\
      \n\
      DOCKRUN_PREFIX       :: ${DOCKRUN_PREFIX}\n\
      OS_NAME              :: $(grep -e ^NAME=    /etc/os-release | sed -r 's/.*"(.+)".*/\1/')\n\
      OS_VERSION           :: $(grep -e ^VERSION= /etc/os-release | sed -r 's/.*"(.+)".*/\1/')\n\
      OUR_IMAGE            :: ${OUR_IMAGE}\n\
      OUR_IMAGE_SHORT      :: ${OUR_IMAGE_SHORT}\n\
      OUR_IMAGE_SLOGAN     :: ${OUR_IMAGE_SLOGAN}\n\
      OUR_IMAGE_TAG        :: ${OUR_IMAGE_TAG}\n\
      OUR_IMAGE_VERSION    :: ${OUR_IMAGE_VERSION}\n\
      TOOLCHAIN_TOOL_URL   :: ${TOOLCHAIN_TOOL_URL}\n\
      TOOLCHAIN_URL        :: ${TOOLCHAIN_URL}\n\
      \n" | cut -b 7- > /ALL/Downloads/buildinfo.txt \
   && cat /ALL/Downloads/envvars.sh >> /ALL/Downloads/buildinfo.txt \
   && cat /ALL/Downloads/buildinfo.txt

ENTRYPOINT ["/ALL/Menu/mainmenu.sh"]

CMD []
