@echo OFF

rem dockrun_t3rd.bat, mb, 2019-09-27, 2020-04-03
rem Author: Martin.Bless@mbless.de
rem License: MIT (feel free, use on your own risk, cite me)
rem
rem Save this script as:  %home%\dockrun_t3rd.bat
rem Run it like:          %home%\dockrun_t3rd.bat [ARGS] <ENTER>'
rem
rem Learn from https://en.wikibooks.org/wiki/Windows_Batch_Scripting
rem
rem Welcome to the power of Spaghetti code :-)
rem
rem Created and tested on Windows 10.
rem

set PROJECT=%cd%
if not x%PROJECT:~-1%x == x\x (
   set PROJECT=%PROJECT%\
)
set RESULT=%PROJECT%Documentation-GENERATED-temp
set TMP=%PROJECT%tmp-GENERATED-temp
if not exist %TMP% (
   set TMP=
)

if x%T3DOCS_OURIMAGE%x == xx (
   set T3DOCS_OURIMAGE=t3docs/render-documentation:v2.5.1
)

if not exist %RESULT% (
   mkdir %RESULT%
)

set argcount=0
set arg1=%1
set arg2ff=
set allargs=%1
shift
if not x%arg1%x == xx  set /a argcount+=1

:collectargsstart
if x%1x==xx goto collectargsend
set allargs=%allargs% %1
set arg2ff=%arg2ff% %1
set /a argcount+=1
shift
goto collectargsstart
:collectargsend

if x%argcount%x==x0x (
   set interactive=1
) else (
   set interactive=0
)

if x%interactive%x == x1x (
echo.
echo.
echo.
echo.
)


if x%interactive%x == x0x  goto oneshot

:menu
echo.
echo ==========================================
echo Render TYPO3 documentation
echo ------------------------------------------
echo Using  : %T3DOCS_OURIMAGE%
echo PROJECT: %PROJECT%
echo RESULT : %RESULT%
echo TMP    : %TMP%
echo.
echo CHOICE ACTION
echo ------ -----------------------------------
echo 1      dockrun_t3rd.bat  makehtml
echo 1nc    dockrun_t3rd.bat  makehtml-no-cache
echo 2      dockrun_t3rd.bat  makeall
echo 2nc    dockrun_t3rd.bat  makeall-no-cache
echo bb     dockrun_t3rd.bat  /bin/bash
echo ea     dockrun_t3rd.bat  export-ALL
echo v      dockrun_t3rd.bat  --version
echo ?      show usage
echo q      quit - leave and do nothing
echo ------ -----------------------------------
echo.
set INP=
set /P INP="Please enter your choice and press ENTER: "

if "%INP%"=="1"   goto makehtml
if "%INP%"=="1nc" goto makehtml-no-cache
if "%INP%"=="2"   goto makeall
if "%INP%"=="2nc" goto makeall-no-cache
if "%INP%"=="bb"  goto binbash
if "%INP%"=="h"   goto containerhelp
if "%INP%"=="ea"  goto exportall
if "%INP%"=="v"   goto containerversion
if "%INP%"=="?"   goto usage
if "%INP%"=="q"   goto quit
echo --------------------------
echo unknown choice '%INP%'
pause
goto menu


:usage
echo.
echo ==========================================
echo Render TYPO3 documentation
echo ------------------------------------------
echo.
echo Usage:
echo    dockrun_t3rd.bat [ARGS]
echo.
echo Advice:
echo    1. Save the script to %%HOME%%\dockrun_t3rd.bat
echo    2. Start the script from everywhere with:
echo          %%HOME%%\dockrun_t3rd.bat
echo.
echo Example:
echo    %%HOME%%\dockrun_t3rd.bat  makehtml -c make_singlehtml 1
echo.
echo Usage:
echo    dockrun_t3rd.bat [ARGS]
echo.
echo       ARGUMENT             DESCRIPTION
echo       ?                    Show this menu
echo       --version            Show buildinfo.txt of this container
echo       makeall              Create all output formats
echo       makeall-no-cache     Remove cache first, then create all
echo       makehtml             Create HTML output
echo       makehtml-no-cache    Remove cache first, then build HTML
echo       show-shell-commands  Show useful linux shell commands and functions
echo       show-bat-file        Show source of dockrun_t3rd.bat
echo       show-howto           Show howto (not totally up to date)
echo       show-faq             Show questions and answers (not totally up to date)
echo       bashcmd              Run a bash command in the container
echo       /bin/bash            Enter the container's Bash shell as superuser
echo       /usr/bin/bash        Enter the container's Bash shell as normal user
echo       export-ALL           Copy /ALL to /RESULT/ALL-exported
echo       tct                  Run TCT, the toolchain runner
echo.
echo Examples:
echo    dockrun_t3rd.bat        (enter interactive mode)
echo    dockrun_t3rd.bat --help
echo    dockrun_t3rd.bat export-ALL
echo    dockrun_t3rd.bat makeall-no-cache
echo    dockrun_t3rd.bat makehtml
echo    dockrun_t3rd.bat bashcmd ls -la /ALL
echo    dockrun_t3rd.bat /bin/bash
echo    dockrun_t3rd.bat /usr/bin/bash
echo.
echo Container selection:
echo    Set the environment variable T3DOCS_OURIMAGE to the container you want
echo    to use. Afterwards run 'dockrun_t3rd.bat'.
echo.
echo    Example:
echo       set T3DOCS_OURIMAGE=t3docs/render-documentation:develop
echo cm      %%HOME%%\dockrun_t3rd.bat
echo.
if x%interactive%x == x1x  pause & goto menu
goto alldone


:binbash
set arg1=/bin/bash
goto menuaction

:containerversion
set arg1=--version
goto menuaction

:exportall
set arg1=export-ALL
goto menuaction

:makeall
set arg1=makeall
goto menuaction

:makeall-no-cache
set arg1=makeall-no-cache
goto menuaction

:makehtml
set arg1=makehtml
goto menuaction

:makehtml-no-cache
set arg1=makehtml-no-cache
goto menuaction

:menuaction
set allargs=%arg1%
echo %arg1%
goto oneshot

:oneshot
if x%arg1%x == x?x goto usage
if xx == xx (
   set cmd=docker run --rm
   set trailingargs=%allargs%
)
if x%arg1%x == x/bin/bashx (
   set cmd=docker run --rm --entrypoint=/bin/bash -it
   set trailingargs=
)
if x%arg1%x == x/usr/bin/bashx (
   set cmd=docker run --rm --entrypoint=/bin/bash -it
   set trailingargs=
)
if x%arg1%x == xexport-ALLx (
   set cmd=docker run --rm --entrypoint=/bin/bash
   set trailingargs=-c "rsync -a --delete /ALL/ /RESULT/ALL-exported"
   echo The export will go to:
   echo    %RESULT%/ALL-exported
)
if x%arg1%x == xbashcmdx (
   set cmd=docker run --rm --entrypoint=/bin/bash
   set trailingargs=-c %arg2ff%
)
set cmd=%cmd% -v %PROJECT%:/PROJECT:ro
set cmd=%cmd% -v %RESULT%:/RESULT
if not x%TMP%x == xx (
   set cmd=%cmd% -v %TMP%:/tmpq

)
set cmd=%cmd% %T3DOCS_OURIMAGE% %trailingargs%
%cmd%

if x%interactive%x == x1x  pause
echo ------------------------------------------
echo last call was:
echo    dockrun_t3rd.bat %allargs%
echo.
echo last command was:
echo    %cmd%
echo.
if x%interactive%x == x1x  pause & goto menu
goto alldone


:quit
echo quit
goto alldone


:alldone
