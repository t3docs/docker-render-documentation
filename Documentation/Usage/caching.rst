.. include:: ../Includes.txt

==================
Caching
==================

Navigate this page:

.. contents::
   :class: compact-list
   :local:
   :depth: 3
   :backlinks: top


Why?
====

Caching can speed up html rendering by factor 100. For huge manuals this can
become crucial.


How does caching work?
======================

…


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

First run without cache
-----------------------

For example, takes "1912.13 seconds". That is about 32 minutes.

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
      exitcode:   0       1790675 ms

   ==================================================
      18-Make-and-build/41-Singlehtml/run_41-Make-singlehtml.py
      exitcode:   0         17568 ms

   ==================================================
      18-Make-and-build/42-Latex/run_42-Make-Latex.py
      exitcode:   0         61933 ms


   [...]


   ==================================================
      22-Assemble-results/run_13-Create-package.py
      exitcode:   0         30334 ms


   [...]


   ==================================================
      90-Finish/run_10-Say-goodbye.py

   project : 0.0.0 : Makedir
      makedir /ALL/Makedir
      2019-08-16 20:24:52 892541,  took: 1912.13 seconds,  toolchain: RenderDocumentation
      REBUILD_NEEDED because of change,  age 434996.9 of 168.0 hours,  18124.9 of 7.0 days
      OK: buildinfo, html, package, singlehtml

      exitcode:   0            41 ms

   ==================================================


follow-up run using the cache
----------------------------

Run again, using the cache of the first run::

   cd ~/Repositories/git.typo3.org/Packages/TYPO3.CMS.git/typo3/sysext/core
   dockrun_t3rd  makeall

Takes only seconds:

   ...

To summarize:

Caching can speed up 'html' building very much (factor 100 or so). If there are
many output files they don't have to be rewritten.

'makehtml-no-cache' removes existing cache data prior to working but always
recreates it during the 'html' build. The same is true for 'makeall-no-cache'.

The other builders always try to reuse the html-cache. They usually have to
rewrite all their output so the time needed for writing doesn't change.
