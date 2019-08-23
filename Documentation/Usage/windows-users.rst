.. include:: ../Includes.txt
.. highlight:: text

==================
Windows users
==================

.. On this page:

   .. contents::
      :class: compact-list
      :local:
      :depth: 3
      :backlinks: top

Linux, Mac, Windows: Please read the short chapter about :ref:`operating
systems <operating-systems>`.

**Windows users, please contribute!**
Please help and contribute how you port measures and procedure of this manual
to Windows.


A start to rewrite the 'dockrun_t3rd' script for PowerShell?
============================================================

Susanne Moog contributed this script. It may serve as a starter for a more
advanced script that mimics the bahaviour of 'dockrun_t3rd' on windows.
Susanne wrote:

   As a Windows user you will want to have something like this in your
   `$PROFILE`. Start the PowerShell and run `Generate-TYPO3-Documentation`.
   Works very well, and you have autocompletion :-)

PowerShell:

.. code-block:: powershell

   Function Generate-TYPO3-Documentation(
       [String]
       $SourcePath,
       [String]
       $TargetPath,
       [Boolean]
       $Latex,
       [Boolean]
       $SingleHtml
   ) {

       if ([String]::IsNullOrEmpty($SourcePath)) {
           $SourcePath = $PWD;
       }

       if ([String]::IsNullOrEmpty($TargetPath)) {
           $TargetPath = "$($PWD)\Documentation-GENERATED-temp\"
       }

       $cmd = "docker run --rm -v $($SourcePath):/PROJECT/:ro -v $($TargetPath):/RESULT/ " +
              "t3docs/render-documentation makehtml -c make_latex $([int]$Latex)" +
              " -c make_singlehtml $([int]$SingleHtml);"

       Invoke-Expression $cmd
   }

Linux version
-------------


The above PowerShell script was coded to achieve something like this::

   #01 cd /home/marble/Repositories/github.com/TYPO3-Documentation/TYPO3CMS-Reference-Typoscript
   #02
   #03 docker run \
   #04   --rm \
   #05   --user=$(id -u):$(id -g) \
   #06   -v $PWD:/PROJECT/:ro
   #07   -v $PWD/Documentation-GENERATED-temp/:/RESULT/ \
   #08   t3docs/render-documentation \
   #09   makehtml \
   #10   -c make_latex 0 \
   #11   -c make_singlehtml 0


which expands to::

   #01 cd /home/marble/Repositories/github.com/TYPO3-Documentation/TYPO3CMS-Reference-Typoscript
   #02
   #03 docker run \
   #04   --rm \
   #05   --user=1000:1000 \
   #06   -v /home/marble/Repositories/github.com/TYPO3-Documentation/TYPO3CMS-Reference-Typoscript:/PROJECT/:ro
   #07   -v /home/marble/Repositories/github.com/TYPO3-Documentation/TYPO3CMS-Reference-Typoscript/Documentation-GENERATED-temp/:/RESULT/ \
   #08   t3docs/render-documentation \
   #09   makehtml \
   #10   -c make_latex 0 \
   #11   -c make_singlehtml 0

What the lines mean:

#01
   Go to the top folder of your project (not the `project/Documentation`
   subfolder.

#03
   Run Docker from the commandline with `run` action.

#04
   --rm: Remove the container (= writable copy of the read-only image) right
   after it has finished. Otherwise each run leaves a copy.

#05
  --user: Set user permissions. Otherwise all generated files would be own by
  the superuser.

#06
   -v: Read-only volume mapping to the project. Must be the complete and
   absolute path.

#07
   -v: Writable volume mapping to the result folder, usually
   `Documentation-GENERATED-temp`.

#08
   The container that is to be run.

#09
   Action `makehtml` tells the container what it should do.

#10
   Pass option `make_latex=0` to the toolchain that the container will run.

#11
   Pass option `make_singlehtml=0` to the toolchain that the container will
   run.
