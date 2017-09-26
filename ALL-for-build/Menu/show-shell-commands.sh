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
local cmd;
mkdir Documentation-GENERATED-temp 2>/dev/null
cmd="docker run --rm"
if [[ "\$@" != "/bin/bash" ]]; then
cmd="\$cmd --user=\$(id -u):\$(id -g)"
else
cmd="\$cmd --entrypoint /bin/bash -it"
fi
cmd="\$cmd -v \$PWD:/PROJECT/:ro -v \$PWD/Documentation-GENERATED-temp/:/RESULT/"
if [ -d ./tmp-GENERATED-temp ]; then
   /bin/bash -c "rm -rf ./tmp-GENERATED-temp/*"
   cmd="\$cmd -v \$PWD/tmp-GENERATED-temp/:/tmp/"
fi
if [ -d ./tmp-GENERATED-Toolchains ]; then
cmd="\$cmd -v \$PWD/tmp-GENERATED-Toolchains/:/ALL/Toolchains/"
fi
if [ -d ./tmp-GENERATED-dummy_webroot ]; then
cmd="\$cmd -v \$PWD/tmp-GENERATED-dummy_webroot/:/ALL/dummy_webroot/"
fi
if [ -d ./tmp-GENERATED-Makedir ]; then
cmd="\$cmd -v \$PWD/tmp-GENERATED-Makedir/:/ALL/Makedir"
fi
if [ -d ./tmp-GENERATED-Menu ]; then
cmd="\$cmd -v \$PWD/tmp-GENERATED-Menu/:/ALL/Menu"
fi
if [ -d ./tmp-GENERATED-Rundir ]; then
cmd="\$cmd -v \$PWD/tmp-GENERATED-Rundir/:/ALL/Rundir"
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
