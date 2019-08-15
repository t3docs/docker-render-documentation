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

First run
---------

For example, takes "2053.99 seconds". That is about 34 minutes.

Remove all previous cache and build all::

   cd ~/Repositories/git.typo3.org/Packages/TYPO3.CMS.git/typo3/sysext/core
   git pull
   dockrun_t3rd  makeall-no-cache


Followup run
------------

Run again, using the cache of the first run::

   cd ~/Repositories/git.typo3.org/Packages/TYPO3.CMS.git/typo3/sysext/core
   dockrun_t3rd  makeall

Takes only seconds:

   ...

