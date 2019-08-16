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



Example: sysext:core
====================

First run without cache
-----------------------

For example, takes "2013.81 seconds". That is about 34 minutes.

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
      exitcode:   0       1922828 ms

   ==================================================
      18-Make-and-build/41-Singlehtml/run_41-Make-singlehtml.py
      exitcode:   0         17420 ms

   ==================================================
      18-Make-and-build/42-Latex/run_42-Make-Latex.py
      exitcode:   0         62372 ms



   [...]



   ==================================================
      90-Finish/run_10-Say-goodbye.py

   project : 0.0.0 : Makedir
      makedir /ALL/Makedir
      2019-08-15 16:02:08 306015,  took: 2013.81 seconds,  toolchain: RenderDocumentation
      REBUILD_NEEDED because of change,  age 434968.6 of 168.0 hours,  18123.7 of 7.0 days
      OK: buildinfo, html, singlehtml

      exitcode:   0            40 ms



follow-up run using the cache
----------------------------

Run again, using the cache of the first run::

   cd ~/Repositories/git.typo3.org/Packages/TYPO3.CMS.git/typo3/sysext/core
   dockrun_t3rd  makeall

Takes only seconds:

   ...

