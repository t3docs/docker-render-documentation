#!/bin/bash

source /ALL/Downloads/envvars.sh

# provide defaults
#1
VERSION=${VERSION:-"v1.6.11-full"}
DOCKRUN_PREFIX=${DOCKRUN_PREFIX:-"dockrun_"}
OUR_IMAGE_SHORT=${OUR_IMAGE_SHORT:-t3rdf}
OUR_IMAGE_SLOGAN=${OUR_IMAGE_SLOGAN:-"t3rdf - TYPO3 render documentation full"}
#2
OUR_IMAGE_TAG=${OUR_IMAGE_TAG:-"$VERSION"}
#3
OUR_IMAGE=${OUR_IMAGE:-"t3docs/render-documentation:$OUR_IMAGE_TAG"}

cat <<EOT

# NOTE
# You can 'source' this file directly into the shell of your commandline with:
#     source <(docker run --rm $OUR_IMAGE show-shell-commands)
# ATTENTION:
#     No whitespace between '<('

# the usual worker command like 'dockrun_t3rdf'
function ${DOCKRUN_PREFIX}${OUR_IMAGE_SHORT} () {

# Environment variables the USER may find important (on the host!),
# no slash ('/') at the end,
# default is the current directory \$(pwd):
#
#     T3DOCS_PROJECT=/absolute/path/to/project/start/folder
#     T3DOCS_RESULT=/absolute/path/to/result/folder
#     T3DOCS_TMP=/absolute/path/to/temporary/folder
#     T3DOCS_DUMMY_WEBROOT=/absolute/path/to/output/dummy_webroot/
#
# Environment variables only some DEVELOPERS may find important,
# no slash ('/') at the end,
#
#     T3DOCS_MAKEDIR=/absolute/path/to/makedir
#     T3DOCS_MENU=/absolute/path/to/menu
#     T3DOCS_RUNDIR=/absolute/path/to/rundir
#     T3DOCS_TOOLCHAINS=/absolute/path/to/toolchains

# Example:
# local DEBUG=\${T3DOCS_DEBUG:-0}
# local DEBUG=\${T3DOCS_DEBUG:-1}
# set T3DOCS_DEBUG=0 or set T3DOCS_DEBUG=1
local DEBUG=\${T3DOCS_DEBUG:-0}
local git_restore_mtime=\$(which git-restore-mtime)
local exitcode=\$?
if [[ \$exitcode -ne 0 ]]; then git_restore_mtime=; fi

# start command building
local cmd="docker run --rm"
if [[ \$# -eq 0 ]]; then
   # note: CREATING=0 leads to root:root permissions (why? to be solved!)
   local CREATING=1
   cmd="\$cmd --user=\$(id -u):\$(id -g)"
elif [[ "\$@" = "/bin/bash" ]]; then
   # note: CREATING=0 leads to root:root permissions (why? to be solved!)
   local CREATING=1
   cmd="\$cmd --entrypoint /bin/bash -it"
else
   local CREATING=1
   cmd="\$cmd --user=\$(id -u):\$(id -g)"
fi

# PROJECT - read only!
# assume existing folder PROJECT/Documentation
# absolute path to existing folder PROJECT or current dir
local PROJECT=\${T3DOCS_PROJECT:-\$(pwd)}
cmd="\$cmd -v \$PROJECT:/PROJECT:ro"
if ((\$DEBUG)); then echo "PROJECT......: \$PROJECT"; fi

# RESULT
# absolute path to existing folder RESULT of (RESULT/Documentation-GENERATED-temp)
local RESULT=\${T3DOCS_RESULT:-\$(pwd)}
# force special name to prevent create/delete disasters
RESULT=\${RESULT}/Documentation-GENERATED-temp
cmd="\$cmd -v \$RESULT:/RESULT"
if ((\$CREATING)); then
   if ((\$DEBUG)); then echo creating: mkdir -p "\$RESULT" ; fi
   mkdir -p "\$RESULT" 2>/dev/null
fi
if ((\$DEBUG)); then echo "RESULT.......: \$RESULT"; fi

# TMP
# absolute path to existing folder TMP of (TMP/tmp-GENERATED-temp)
local TMP=\${T3DOCS_TMP:-\$(pwd)}
# force special name to prevent create/delete disasters
TMP=\${TMP}/tmp-GENERATED-temp
if ((\$CREATING)) && [[ -n "\${T3DOCS_TMP}" ]]; then
   mkdir -p "\$TMP" 2>/dev/null
fi
if [[ -d "\${TMP}" ]]; then
   cmd="\$cmd -v \$TMP:/tmp"
   if ((\$CREATING)); then
      /bin/bash -c "rm -rf \$TMP/*"
   fi
   if ((\$DEBUG)); then echo "TMP..........: \$TMP"; fi
fi

# DUMMY_WEBROOT
# absolute path to existing folder DUMMY_WEBROOT
local DUMMY_WEBROOT=\${T3DOCS_DUMMY_WEBROOT:-\$(pwd)/tmp-GENERATED-dummy_webroot}
if [ -d "\$DUMMY_WEBROOT" ]; then
   cmd="\$cmd -v \$DUMMY_WEBROOT:/ALL/dummy_webroot"
   if ((\$DEBUG)); then echo "DUMMY_WEBROOT: \$DUMMY_WEBROOT"; fi
fi

# MAKEDIR
# absolute path to existing folder MAKEDIR
local MAKEDIR=\${T3DOCS_MAKEDIR:-\$(pwd)/tmp-GENERATED-Makedir}
if [ -d "\$MAKEDIR" ]; then
   cmd="\$cmd -v \$MAKEDIR:/ALL/Makedir"
   if ((\$DEBUG)); then echo "MAKEDIR......: \$MAKEDIR"; fi
fi

# MENU
# absolute path to existing folder MENU
local MENU=\${T3DOCS_MENU:-\$(pwd)/tmp-GENERATED-Menu}
if [ -d "\$MENU" ]; then
   cmd="\$cmd -v \$MENU:/ALL/Menu"
   if ((\$DEBUG)); then echo "MENU.........: \$MENU"; fi
fi

# RUNDIR
# absolute path to existing folder RUNDIR
local RUNDIR=\${T3DOCS_RUNDIR:-\$(pwd)/tmp-GENERATED-Rundir}
if [ -d "\$RUNDIR" ]; then
   cmd="\$cmd -v \$RUNDIR:/ALL/Rundir"
   if ((\$DEBUG)); then echo "RUNDIR.......: \$RUNDIR"; fi
fi

# TOOLCHAINS
# absolute path to existing folder TOOLCHAINS
local TOOLCHAINS=\${T3DOCS_TOOLCHAINS:-\$(pwd)/tmp-GENERATED-Toolchains}
if [ -d "\$TOOLCHAINS" ]; then
   cmd="\$cmd -v \$TOOLCHAINS:/ALL/Toolchains"
   if ((\$DEBUG)); then echo "TOOLCHAINS...: \$TOOLCHAINS"; fi
fi

# Add current working directory in environment variable HOST_CWD
# (PWD should be defined in all POSIX compliant shells)
if [ ! -z "${PWD}" ];then
    cmd="\$cmd -e HOST_CWD=\$PWD"
fi

cmd="\$cmd $OUR_IMAGE"
if ((\$DEBUG)); then echo "OUR_IMAGE....: $OUR_IMAGE"; fi

# add remaining arguments
if [[ "\$@" != "/bin/bash" ]]; then
   cmd="\$cmd \$@"
   # if script git-restore-mtime exists and '*make*' in args try the command
   # See README: get 'git-restore-mtime' from https://github.com/MestreLion/git-tools
   if [[ "\$git_restore_mtime" != "" ]] && [[ \$@ =~ .*make.* ]]; then
      if ((\$DEBUG)); then
         echo \$git_restore_mtime
         \$git_restore_mtime
      else
         \$git_restore_mtime 2>/dev/null
      fi
   fi
fi
if [[ -w "\$RESULT" ]]; then true
   echo "\$cmd" | sed "s/-v /\\\\\\\\\\\\n   -v /g" >"\$RESULT/last-docker-run-command-GENERATED.sh"
fi
if ((\$DEBUG)); then
   echo \$cmd | sed "s/-v /\\\\\\\\\\\\n   -v /g"
fi
eval "\$cmd"
}

echo "This function is now defined FOR THIS terminal window:"
echo "    ${DOCKRUN_PREFIX}${OUR_IMAGE_SHORT}"

EOT