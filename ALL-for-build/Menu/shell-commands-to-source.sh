#!/bin/bash

# This script defines a helper function to be used on the host.

# 1. test the functionality here
# 2. copy the text between "EOT" to './show-shell-commands.sh'
# 3. Escape all dollar signs
# 4. Unescape: ${DOCKRUN_PREFIX}, ${OUR_IMAGE}, ${OUR_IMAGE_SHORT}


# provide defaults
DOCKRUN_PREFIX=${DOCKRUN_PREFIX:-devdockrun_}
OUR_IMAGE=${OUR_IMAGE:-t3docs/render-documentation}
OUR_IMAGE_SHORT=${OUR_IMAGE_SHORT:-t3rdf}


### start of EOT

# NOTE
# You can 'source' this file directly into the shell of your commandline with:
#     source <(docker run --rm $OUR_IMAGE show-shell-commands)
# ATTENTION:
#     No whitespace between '<('

# the usual worker command like 'dockrun_t3rdf'
function ${DOCKRUN_PREFIX}${OUR_IMAGE_SHORT} () {

# Environment variables the USER may find important,
# no slash ('/') at the end,
# default is the current directory ('pwd()'):
#
#     T3DOCS_PROJECT=/absolute/path/to/project
#     T3DOCS_RESULT=/absolute/path/to/output/folder
#     T3DOCS_TMP=/absolute/path/to/temporary/folder
#     T3DOCS_DUMMY_WEBROOT=/absolute/path/to/output/folder-2/

# assume folder PROJECT/Documentation
# absolute path to folder PROJECT
local PROJECT=${T3DOCS_PROJECT:-$(pwd)}
# assume folder RESULT/Documentation-GENERATED-temp
# absolute path to folder RESULT
local RESULT=${T3DOCS_RESULT:-$(pwd)}
# assume folder TMP/tmp-GENERATED-temp
# absolute path to folder TMP
local TMP=${T3DOCS_TMP:-$(pwd)}
# assume folder DUMMY_WEBROOT/tmp-GENERATED-dummy_webroot
# absolute path to folder DUMMY_WEBROOT
local DUMMY_WEBROOT=${T3DOCS_DUMMY_WEBROOT:-$(pwd)}

# Environment variables only some DEVELOPERS may find important,
# no slash ('/') at the end,
# default is the current directory ('pwd()'):
#
#     T3DOCS_MAKEDIR=/absolute/path/to/makedir
#     T3DOCS_MENU=/absolute/path/to/menu
#     T3DOCS_RUNDIR=/absolute/path/to/rundir
#     T3DOCS_TOOLCHAINS=/absolute/path/to/toolchains

# assume folder MAKEDIR/tmp-GENERATED-Makedir
# absolute path to folder MAKEDIR
local MAKEDIR=${T3DOCS_MAKEDIR:-$(pwd)}
# assume folder MENU/tmp-GENERATED-Menu
# absolute path to folder MENU
local MENU=${T3DOCS_MENU:-$(pwd)}
# assume folder RUNDIR/tmp-GENERATED-Rundir
# absolute path to folder RUNDIR
local RUNDIR=${T3DOCS_RUNDIR:-$(pwd)}
# assume folder TOOLCHAINS/tmp-GENERATED-Toolchains
# absolute path to folder TOOLCHAINS
local TOOLCHAINS=${T3DOCS_TOOLCHAINS:-$(pwd)}

# always create the resultfolder
mkdir "$RESULT/Documentation-GENERATED-temp" 2>/dev/null

# start building the command
local cmd="docker run --rm"

if [[ "$@" != "/bin/bash" ]]; then
cmd="$cmd --user=\$(id -u):\$(id -g)"
else
cmd="$cmd --entrypoint /bin/bash -it"
fi

cmd="$cmd -v $PROJECT:/PROJECT:ro -v $RESULT/Documentation-GENERATED-temp:/RESULT"
if [ -d "$TMP/tmp-GENERATED-temp" ]; then
   /bin/bash -c "rm -rf $TMP/tmp-GENERATED-temp/*"
   cmd="$cmd -v $TMP/tmp-GENERATED-temp:/tmp"
fi
if [ -d "$DUMMY_WEBROOT/tmp-GENERATED-dummy_webroot" ]; then
cmd="$cmd -v $DUMMY_WEBROOT/tmp-GENERATED-dummy_webroot:/ALL/dummy_webroot"
fi
if [ -d "$MAKEDIR/tmp-GENERATED-Makedir" ]; then
cmd="$cmd -v $MAKEDIR/tmp-GENERATED-Makedir:/ALL/Makedir"
fi
if [ -d "$MENU/tmp-GENERATED-Menu" ]; then
cmd="$cmd -v $MENU/tmp-GENERATED-Menu:/ALL/Menu"
fi
if [ -d "$RUNDIR/tmp-GENERATED-Rundir" ]; then
cmd="$cmd -v $RUNDIR/tmp-GENERATED-Rundir:/ALL/Rundir"
fi
if [ -d "$TOOLCHAINS/tmp-GENERATED-Toolchains" ]; then
cmd="$cmd -v $TOOLCHAINS/tmp-GENERATED-Toolchains:/ALL/Toolchains"
fi
cmd="$cmd $OUR_IMAGE"
if [[ "$@" != "/bin/bash" ]]; then
cmd="$cmd $@"
fi
echo "$cmd" >"$RESULT/Documentation-GENERATED-temp/last-docker-run-command-GENERATED.sh"
eval "$cmd"
}

echo "This function is now defined FOR THIS terminal window:"
echo "    ${DOCKRUN_PREFIX}${OUR_IMAGE_SHORT}"
echo "Tip: To inspect the function:"
echo "    declare -f ${DOCKRUN_PREFIX}${OUR_IMAGE_SHORT}"

### end of EOT