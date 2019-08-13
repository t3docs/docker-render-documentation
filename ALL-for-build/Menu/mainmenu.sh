#!/bin/bash
# http://www.thegeekstuff.com/2010/07/bash-case-statement/

source "$HOME/.bashrc"
source /ALL/Downloads/envvars.sh

# provide defaults
export OUR_IMAGE=${OUR_IMAGE:-t3docs/render-documentation}
export OUR_IMAGE_SHORT=${OUR_IMAGE_SHORT:-t3rd}
export OUR_IMAGE_SLOGAN=${OUR_IMAGE_SLOGAN:-t3rd_TYPO3_render_documentation}

function mm-bashcmd() {
   local cmd
   shift
   cmd="/bin/bash -c"
   cmd="$cmd \"$@\""
   eval $cmd
   local exitstatus=$?
   tell-about-results $exitstatus
}

function mm-minimalhelp(){
   cat <<EOT
$OUR_IMAGE_SLOGAN (${OUR_IMAGE_TAG})
For help:
   docker run --rm $OUR_IMAGE --help
   ${DOCKRUN_PREFIX}$OUR_IMAGE_SHORT --help

... did you mean '${DOCKRUN_PREFIX}$OUR_IMAGE_SHORT makehtml'?

EOT
}

function mm-usage() {
   cat <<EOT
Usage:
    Prepare:
        Define function '${DOCKRUN_PREFIX}$OUR_IMAGE_SHORT' on the commandline of your system:
            source <(docker run --rm $OUR_IMAGE show-shell-commands)
        Inspect function:
            declare -f ${DOCKRUN_PREFIX}${OUR_IMAGE_SHORT}
    Usage:
        ${DOCKRUN_PREFIX}$OUR_IMAGE_SHORT [ARGS]
            ARGUMENT             DESCRIPTION
            --help               Show this menu
            --version            Show buildinfo.txt of this container
            bashcmd              Run a bash command in the container
            makeall              Run for production - create ALL
            makehtml             Run for production - create only HTML
            tct                  Run TCT, the toolchain runner
            show-shell-commands  Show useful shell commands and functions
            /bin/bash            Enter the container's Bash shell
            show-howto           Show howto (not totally up to date)
            show-faq             Show questions and answers (not totally up to date)

    Examples:
        ${DOCKRUN_PREFIX}$OUR_IMAGE_SHORT
        ${DOCKRUN_PREFIX}$OUR_IMAGE_SHORT --help
        ${DOCKRUN_PREFIX}$OUR_IMAGE_SHORT makehtml
        ${DOCKRUN_PREFIX}$OUR_IMAGE_SHORT /bin/bash

    Only in this short form:
        # Copy /ALL to /RESULT/ALL-exported
        ${DOCKRUN_PREFIX}$OUR_IMAGE_SHORT export-ALL


End of usage.
EOT
}

function mm-version() {
   cat /ALL/Downloads/buildinfo.txt
}

function mm-show-howto() {
   $(dirname $0)/show-howto.sh
}

function mm-show-faq() {
   $(dirname $0)/show-faq.sh
}

function mm-show-shell-commands() {
   $(dirname $0)/show-shell-commands.sh
}

function mm-tct() {
   shift
   tct $@
}

function tell-about-results() {
local exitstatus=$1
if [ $exitstatus -eq 0 ]
then
   cat <<EOT

Final exit status: 0 (completed)

EOT
else
   cat <<EOT

Final exit status: $exitstatus (aborted)

EOT
fi
if [ -d "/RESULT/Result" ]; then
   echo -n >/RESULT/warning-files.txt
   echo Find the results:
   find /RESULT/Result -type f -regextype posix-egrep -iregex '.*/0\.0\.0/Index\.html$' -printf "  ./Documentation-GENERATED-temp/Result/%P\\n"
   find /RESULT/Result -type f -regextype posix-egrep -iregex '.*/0\.0\.0/singlehtml/Index\.html$'  -printf "  ./Documentation-GENERATED-temp/Result/%P\\n"
   find /RESULT/Result -type d -regextype posix-egrep -regex  '.*/0\.0\.0/_buildinfo$'  -printf "  ./Documentation-GENERATED-temp/Result/%P\\n"
   find /RESULT/Result -type f -regextype posix-egrep -regex  '.*/_buildinfo/warnings\.txt$' \! -empty -printf "  ./Documentation-GENERATED-temp/Result/%P\\n"
   find /RESULT/Result -type f -regextype posix-egrep -regex  '.*/_buildinfo/warnings\.txt$' \! -empty -printf "  ./Documentation-GENERATED-temp/Result/%P\\n" >>/RESULT/warning-files.txt
   find /RESULT/Result -type f -regextype posix-egrep -iregex '.*/latex/run-make\.sh$' -printf "  ./Documentation-GENERATED-temp/Result/%P\\n"


   if [ -f /RESULT/warning-files.txt ];then
      echo
      if [ -s /RESULT/warning-files.txt ];then
         echo "ATTENTION:"
         echo "   There are Sphinx warnings!"
      else
         echo "Congratulations:"
         echo "    There are no Sphinx warnings!"
         rm -f /RESULT/warning-files.txt
      fi
      echo
   fi
fi
}

function mm-makeall() {
   local cmd
   shift

# make sure nothing is left over from previous run
if [[ -f /tmp/RenderDocumentation/Todo/ALL.source-me.sh ]]
then
   rm -f /tmp/RenderDocumentation/Todo/ALL.source-me.sh
fi
cmd="tct --cfg-file=/ALL/venv/tctconfig.cfg --verbose"
cmd="$cmd run RenderDocumentation -c makedir /ALL/Makedir"
cmd="$cmd -c make_latex 1 -c make_package 1 -c make_pdf 1 -c make_singlehtml 1"
cmd="$cmd $@"
eval $cmd

local exitstatus=$?

# do localizations
if [[ -f /tmp/RenderDocumentation/Todo/ALL.source-me.sh ]]
then
   source /tmp/RenderDocumentation/Todo/ALL.source-me.sh
fi

# is now handled in toolchain using '-c resultdir ...'
#if [[ ( $exitstatus -eq 0 ) \
#   && ( -d /ALL/dumy_webroot/typo3cms/drafts/project ) \
#   && ( -d /RESULT ) ]]
#then
#rsync -a /ALL/dumy_webroot/typo3cms/drafts/project /RESULT/Result/ --delete
#exitstatus=$?
#fi

tell-about-results $exitstatus
}

function mm-makehtml() {
   local cmd
   shift

# make sure nothing is left over from previous run
if [[ -f /tmp/RenderDocumentation/Todo/ALL.source-me.sh ]]
then
   rm -f /tmp/RenderDocumentation/Todo/ALL.source-me.sh
fi
cmd="tct --cfg-file=/ALL/venv/tctconfig.cfg -v"
cmd="$cmd run RenderDocumentation -c makedir /ALL/Makedir"
cmd="$cmd -c make_latex 0 -c make_package 0 -c make_pdf 0 -c make_singlehtml 0"
cmd="$cmd $@"
eval $cmd

local exitstatus=$?

# do localizations
if [[ -f /tmp/RenderDocumentation/Todo/ALL.source-me.sh ]]
then
   source /tmp/RenderDocumentation/Todo/ALL.source-me.sh
fi

# is now handled in toolchain using '-c resultdir ...'
#if [[ ( $exitstatus -eq 0 ) \
#   && ( -d /ALL/dumy_webroot/typo3cms/drafts/project ) \
#   && ( -d /RESULT ) ]]
#then
#rsync -a /ALL/dumy_webroot/typo3cms/drafts/project /RESULT/Result/ --delete
#exitstatus=$?
#fi

tell-about-results $exitstatus
}

case "$1" in
--help)              mm-usage $@ ;;
--version)           mm-version $@ ;;
bashcmd)             mm-bashcmd $@ ;;
makeall)             mm-makeall $@ ;;
makehtml)            mm-makehtml $@ ;;
show-shell-commands) mm-show-shell-commands $@ ;;
show-faq)            mm-show-faq $@ ;;
show-howto)          mm-show-howto $@ ;;
tct)                 mm-tct $@ ;;
*)                   mm-minimalhelp $@ ;;
esac
