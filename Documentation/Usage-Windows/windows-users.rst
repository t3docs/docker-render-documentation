.. include:: /Includes.rst.txt
.. highlight:: text

==================
Windows users
==================

.. **On this page:**

   .. contents::
      :class: compact-list
      :local:
      :depth: 3
      :backlinks: top

About Linux, Mac, Windows: Please read the short chapter about :ref:`operating
systems <operating-systems>`.

**Windows users, please contribute!** Please help and contribute how you port
measures and procedure of this manual to Windows.


A start to rewrite the 'dockrun_t3rd' script for PowerShell
===========================================================

If you are using Windows and Powershell, you can add the following
function to your $PROFILE. For example, you can use `code $PROFILE` to edit the
file. This is code for the PowerShell:

.. code-block:: powershell
   :linenos:

   <#
   .SYNOPSIS
       Generate TYPO3 HTML Documentation from rst files.
   .DESCRIPTION
       Runs docker to generate TYPO3 documentation.
   .PARAMETER SourcePath
       The path to the Documentation folder - uses current directory if none given.
   .PARAMETER TargetPath
       The output path (will be created if it does not exist). Uses "Documentation-GENERATED-temp"
       as fallback.
   .PARAMETER Latex
       Disables/Enables Latex output.
   .PARAMETER SingleHtml
       Disables/Enables generation of single HTML file.
   .PARAMETER Cache
       Removes and recreates target path before running if 0 is given. Default: 1
   .PARAMETER Help
       Show help for this command.
   .EXAMPLE
       C:\PS> Generate-TYPO3-Documentation -SingleHtml 1 -Cache 0
   .NOTES
       Author: Susanne Moog
       Date:   August 28, 2019
   #>
   Function Generate-TYPO3-Documentation(
       [String]
       $SourcePath,
       [String]
       $TargetPath,
       [Boolean]
       $Latex ,
       [Boolean]
       $SingleHtml,
       [Boolean]
       $Cache = 1,
       [Switch]
       $Help
   ) {
       if ($Help) {
           Get-Help $($MYINVOCATION.InvocationName)
       }
       else {
           if ([String]::IsNullOrEmpty($SourcePath)) {
               $SourcePath = $PWD;
           }

           if ([String]::IsNullOrEmpty($TargetPath)) {
               $TargetPath = "$($PWD)\Documentation-GENERATED-temp\"
           }

           If ($Cache -And (test-path $TargetPath)) {
               Remove-Item -Recurse -Force $TargetPath
           }

           If (!(test-path $TargetPath)) {
               New-Item -ItemType Directory -Force -Path $TargetPath
           }

           $cmd = "docker run --rm -v $($SourcePath):/PROJECT/:ro -v $($TargetPath):/RESULT/ " +
           "t3docs/render-documentation makehtml -c make_latex $([int]$Latex)" +
           " -c make_singlehtml $([int]$SingleHtml);"

           Invoke-Expression $cmd
       }
   }


Linux version
-------------

The script was coded to achieve something like this::

   #01 cd ~/Repositories/github.com/TYPO3-Documentation/TYPO3CMS-Reference-Typoscript
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

   #01 cd ~/Repositories/github.com/TYPO3-Documentation/TYPO3CMS-Reference-Typoscript
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
