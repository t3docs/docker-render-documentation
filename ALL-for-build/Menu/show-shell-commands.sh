#!/bin/bash

# provide default
DOCKRUN_PREFIX=${DOCKRUN_PREFIX:-devdockrun_}
OUR_IMAGE=${OUR_IMAGE:-t3docs/render-documentation}
OUR_IMAGE_SHORT=${OUR_IMAGE_SHORT:-t3rd}

cat <<EOT

# NOTE
# You can 'source' the following directly into the shell of your commandline with:
#     source <(docker run --rm $OUR_IMAGE show-shell-commands)
# ATTENTION:
#     No whitespace between '<('

# the usual worker command
function ${DOCKRUN_PREFIX}${OUR_IMAGE_SHORT} () {
local cmd
local TARGET_DIR
local WEBROOT_DIR
if [ -z "\$T3DOCS_TARGET" -o ! -d "\$T3DOCS_TARGET" ]; then
  TARGET_DIR="\$PWD"
else
  TARGET_DIR="\$T3DOCS_TARGET"
fi
mkdir "\$TARGET_DIR/Documentation-GENERATED-temp" 2>/dev/null
if [ -z "\$T3DOCS_WEBROOT" -o ! -d "\$T3DOCS_WEBROOT" ]; then
  WEBROOT_DIR="\$TARGET_DIR/tmp-GENERATED-dummy_webroot"
else
  WEBROOT_DIR="\$T3DOCS_WEBROOT"
fi
/bin/bash -c "rm -rf \${WEBROOT_DIR}/*"
if [ -n "\$T3DOCS_SOURCE" ]; then
  cd "\$T3DOCS_SOURCE"
fi
if [ -z "\$T3DOCS_SOURCE" ]; then
  T3DOCS_SOURCE="\$PWD"
fi
cmd="docker run --rm"
if [[ "\$@" != "/bin/bash" ]]; then
cmd="\$cmd --user=\$(id -u):\$(id -g)"
else
cmd="\$cmd --entrypoint /bin/bash -it"
fi
cmd="\$cmd -v \$T3DOCS_SOURCE:/PROJECT/:ro -v \$TARGET_DIR/Documentation-GENERATED-temp/:/RESULT/"
if [ -d "\$TARGET_DIR/tmp-GENERATED-temp" ]; then
   /bin/bash -c "rm -rf \$TARGET_DIR/tmp-GENERATED-temp/*"
   cmd="\$cmd -v \$TARGET_DIR/tmp-GENERATED-temp/:/tmp/"
fi
if [ -d "\$TARGET_DIR/tmp-GENERATED-Toolchains" ]; then
cmd="\$cmd -v \$TARGET_DIR/tmp-GENERATED-Toolchains/:/ALL/Toolchains/"
fi
if [ -d "\$WEBROOT_DIR" ]; then
  cmd="\$cmd -v \$WEBROOT_DIR/:/ALL/dummy_webroot/"
fi
if [ -d "\$TARGET_DIR/tmp-GENERATED-Makedir" ]; then
cmd="\$cmd -v \$TARGET_DIR/tmp-GENERATED-Makedir/:/ALL/Makedir"
fi
if [ -d "\$TARGET_DIR/tmp-GENERATED-Menu" ]; then
cmd="\$cmd -v \$TARGET_DIR/tmp-GENERATED-Menu/:/ALL/Menu"
fi
if [ -d "\$TARGET_DIR/tmp-GENERATED-Rundir" ]; then
cmd="\$cmd -v \$TARGET_DIR/tmp-GENERATED-Rundir/:/ALL/Rundir"
fi
cmd="\$cmd $OUR_IMAGE"
if [[ "\$@" != "/bin/bash" ]]; then
cmd="\$cmd \$@"
fi
echo \$cmd >Documentation-GENERATED-temp/last-docker-run-command-GENERATED.sh
eval \$cmd
}

echo "This function is now defined FOR THIS terminal window:"
echo "    ${DOCKRUN_PREFIX}$OUR_IMAGE_SHORT"

EOT
