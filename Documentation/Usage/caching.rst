.. include:: ../Includes.rst.txt

==================
Caching
==================

Navigate this page:

.. contents::
   :class: compact-list
   :local:
   :depth: 3
   :backlinks: top


################
As of 2020-05-11
################

Container v2.6.0

========== =================================== ======== ==================
Run        Command                             Seconds  Minutes
========== =================================== ======== ==================
initial    `dockrun_t3rd makehtml-no-cache`     2,730   ≈ 45.5 min
follow-up  `dockrun_t3rd makehtml`                719   ≈ 12.0 min

initial    `dockrun_t3rd makehtml-no-cache \\`  2,049   ≈ 34.2 min
           `   -c allow_unsafe 1`
follow-up  `dockrun_t3rd makehtml \\`              25   **≈ 24.5 sec**
           `   -c allow_unsafe 1`
========== =================================== ======== ==================




################
As of 2019-10-25
################


Why?
====

Caching can speed up html rendering by factor 100. For huge manuals this can
become crucial.


How does caching work?
======================

…

Caching can speed up 'html' building very much (factor 100 or so). If there are
many output files they don't have to be rewritten.

'makehtml-no-cache' removes existing cache data prior to working but always
recreates it during the 'html' build. The same is true for 'makeall-no-cache'.

The other builders always try to reuse the html-cache. They usually have to
rewrite all their output so the time needed for writing doesn't change.



Working with repositories
=========================

File modification times (mtime) aren't stable. That's normal.

Sphinx checks mtimes to decide about validity of cache data.

Cure::

      # if script git-restore-mtime exists and '*make*' in args try the command
   # See README: get 'git-restore-mtime' from https://github.com/MestreLion/git-tools
   if [[ "$git_restore_mtime" != "" ]] && [[ $@ =~ .*make.* ]]; then
      if (($DEBUG)); then
         echo $git_restore_mtime
         $git_restore_mtime
      else
         $git_restore_mtime 2>/dev/null
      fi
   fi

It's a tool packaged into Debian.

Example: sysext:core
====================

What is shown below:

* An initial `makeall` "took 1914.98 seconds". That is about 32 minutes.
* A second run using the cache "took 125.35 seconds". That is about 2 minutes.
* A second run with just `makehtml` "took 11.83 seconds" - let's say 12 seconds.


Initial 'makeall' without cache (32 minutes)
--------------------------------------------


Remove all previous cache and build all::

   ➜  ~ cd ~/Repositories/git.typo3.org/Packages/TYPO3.CMS.git/typo3/sysext/core
   ➜  core git:(master) git pull

   ➜  core git:(master) dockrun_t3rd makeall-no-cache

   ==================================================
   10-Toolchain-actions/run_01-Start-with-everything.py
   exitcode:   0            41 ms


   [...]


   ==================================================
      18-Make-and-build/40-Html/run_40-Make-html.py
      exitcode:   0       1793583 ms

   ==================================================
      18-Make-and-build/41-Singlehtml/run_41-Make-singlehtml.py
      exitcode:   0         17814 ms

   ==================================================
      18-Make-and-build/42-Latex/run_42-Make-Latex.py
      exitcode:   0         62932 ms


   [...]


   ==================================================
      22-Assemble-results/run_13-Create-package.py
      exitcode:   0         29509 ms


   [...]


   ==================================================
      90-Finish/run_10-Say-goodbye.py

   project : 0.0.0 : Makedir
      makedir /ALL/Makedir
      2019-08-18 17:20:14 065035,  took: 1914.98 seconds,  toolchain: RenderDocumentation
      REBUILD_NEEDED because of change,  age 435041.9 of 168.0 hours,  18126.7 of 7.0 days
      OK: buildinfo, html, package, singlehtml

      exitcode:   0            42 ms

   ==================================================


   [...]


   Find the results:
     ./Documentation-GENERATED-temp/Result/project/0.0.0/Index.html
     ./Documentation-GENERATED-temp/Result/project/0.0.0/singlehtml/Index.html
     ./Documentation-GENERATED-temp/Result/project/0.0.0/_buildinfo
     ./Documentation-GENERATED-temp/Result/project/0.0.0/_buildinfo/warnings.txt
     ./Documentation-GENERATED-temp/Result/latex/run-make.sh
     ./Documentation-GENERATED-temp/Result/package/package.zip



Second run 'makeall' using the cache (2 minutes)
------------------------------------------------

"took: 125.35 seconds", that is about 2 minutes (not 32)!

Render all using the cache::

   ➜  core git:(master) dockrun_t3rd  makeall

   ==================================================
   10-Toolchain-actions/run_01-Start-with-everything.py
   exitcode:   0            41 ms


   [...]


   ==================================================
      18-Make-and-build/40-Html/run_40-Make-html.py
      exitcode:   0          4836 ms

   ==================================================
      18-Make-and-build/41-Singlehtml/run_41-Make-singlehtml.py
      exitcode:   0         17560 ms

   ==================================================
      18-Make-and-build/42-Latex/run_42-Make-Latex.py
      exitcode:   0         62567 ms


   [...]


   ==================================================
      22-Assemble-results/run_13-Create-package.py
      exitcode:   0         31088 ms


   [...]


   ==================================================
      90-Finish/run_10-Say-goodbye.py

   project : 0.0.0 : Makedir
      makedir /ALL/Makedir
      2019-08-18 20:20:46 671706,  took: 125.35 seconds,  toolchain: RenderDocumentation
      REBUILD_NEEDED because of change,  age 435044.4 of 168.0 hours,  18126.8 of 7.0 days
      OK: buildinfo, html, package, singlehtml

      exitcode:   0            45 ms

   ==================================================


   [...]


   Find the results:
     ./Documentation-GENERATED-temp/Result/project/0.0.0/Index.html
     ./Documentation-GENERATED-temp/Result/project/0.0.0/singlehtml/Index.html
     ./Documentation-GENERATED-temp/Result/project/0.0.0/_buildinfo
     ./Documentation-GENERATED-temp/Result/project/0.0.0/_buildinfo/warnings.txt
     ./Documentation-GENERATED-temp/Result/latex/run-make.sh
     ./Documentation-GENERATED-temp/Result/package/package.zip


Second run 'makehtml' using the cache (12 seconds)
--------------------------------------------------

...


